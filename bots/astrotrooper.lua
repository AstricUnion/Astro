---@name AstroTrooper
---@author AstricUnion
---@include astronew/libs/astrosound.lua
---@include astronew/libs/bmodentity/entity.lua
---@include astronew/libs/model/model.lua
---@include astronew/libs/tween/tweens.lua
---@include astronew/models/astrotrooper.lua
---@include astronew/src/astrobase.lua
---@include astronew/src/guns.lua
---@include astronew/libs/beffect/effects.lua
---@include astronew/libs/beffect/safeparticle.lua

---@class astrosound
astrosound = require("astronew/libs/astrosound.lua")

---@class ents
ents = require("astronew/libs/bmodentity/entity.lua")

---@class model
model = require("astronew/libs/model/model.lua")

---@class tween 
tween = require("astronew/libs/tween/tweens.lua")

---@class beff
beff = require("astronew/libs/beffect/effects.lua")
require("astronew/libs/beffect/safeparticle.lua")

---@includedir astronew/effects
dodir("astronew/effects", {})

require("astronew/models/astrotrooper.lua")
require("astronew/src/astrobase.lua")

---@class guns
guns = require("astronew/src/guns.lua")

if CLIENT then
    local sounds = "https://raw.githubusercontent.com/AstricUnion/AstroBots/refs/heads/main/sounds/astrotrooper/"
    astrosound.preloadURL("loop", sounds .. "Idle.mp3")
    astrosound.preloadURL("dash", sounds .. "Dash.mp3")
    astrosound.preloadURL("predash", sounds .. "Prepdash.mp3")
    astrosound.preloadURL("reload", sounds .. "Reload.mp3")
    astrosound.preloadURL("blaster", sounds .. "Fire.mp3")
end


---@class AstroTrooperBlaster: AstroModuleBase
---@field nextShoot number
---@field ammo number
---@field shootSound Sound?
local AstroTrooperBlaster = {}
AstroTrooperBlaster.Identifier = "astrotrooper_blaster"
AstroTrooperBlaster.Name = "AstroTrooper blaster"
AstroTrooperBlaster.Health = 400
AstroTrooperBlaster.Model = function()
    local mdl = model.create("astrotrooper_blaster")
    return mdl
end
AstroTrooperBlaster.hooks = {}

local projectileModel = function()
    local mdl = model.create("astrotrooper_projectile")
    mdl:setTrails(54, 0, 0.3, "trails/laser", Color(255, 0, 0))
    return mdl
end

if SERVER then
    function AstroTrooperBlaster:moduleInitialize()
        self.nextShoot = 0
        self.ammo = 4
    end

    function AstroTrooperBlaster:onActivate()
        local cur = timer.curtime()
        if cur < self.nextShoot then
            return
        end
        local angs = self.ent:getAngles()
        local pos = self.ent:getPos()
        local function proj(filter)
            guns.createProjectile(pos, angs, projectileModel, filter or {self.ent})
            astrosound.play {"blaster", nil, self.ent}
        end
        if self:isAlive() then
            local astro = self:getAstro()
            if !astro then return end
            self.nextShoot = cur + 0.3
            self.ent:setSequence(1)
            self.ammo = self.ammo - 1
            astro.ent:applyForceOffset(-angs:getForward() * 100, astro.ent:worldToLocal(pos))
            astro:addVelocity(-angs:getForward() * 30)
            proj(astro.filter)
            if self.ammo <= 0 then
                self.nextShoot = cur + 1.3
                astrosound.play {"reload", nil, self.ent}
                timer.simple(0.3, function()
                    self.ent:setSequence(2)
                    self.ammo = 4
                end)
            end
        else
            if self.ammo <= 0 then
                return
            end
            self.nextShoot = cur + 0.5
            self.ammo = self.ammo - 1
            proj()
            self.ent:addVelocity(-angs:getForward() * 200)
        end
    end

    ---@param self AstroTrooperBlaster
    function AstroTrooperBlaster.hooks.PlayerUse(self, ply, ent)
        if self.ent ~= ent then return end
        if !self:isAlive() then
            self:activate()
        end
    end

    function AstroTrooperBlaster:think()
        if !self:isAlive() then return end
        local astro = self:getAstro()
        if !astro then return end
        local tr = astro:getEyeTrace()
        if !tr then return end
        self.ent:setAngles((tr.HitPos - self.ent:getPos()):getAngle())
    end

    local exp = effect.create()

    function AstroTrooperBlaster:onDeath()
        local astro = self:getAstro()
        if !astro then return end
        local pos = self.ent:getPos()
        self.ent:setParent(nil)
        self.ent:setPos(pos)
        local angs = self.ent:getAngles()
        local astroPos = astro.ent:getPos()
        local forceAng = (astroPos - pos):getAngle()
        astro:addVelocity(forceAng:getForward() * 300)
        astro.ent:applyForceOffset(-angs:getForward() * 1000, astro.ent:worldToLocal(pos))
        self.ent:applyForceCenter(angs:getForward() * 100)
        exp:setOrigin(pos)
        exp:play("Explosion")
        astro.ent:emitSound("WaterExplosionEffect.Sound")
    end
end

ents.register(AstroTrooperBlaster, "astromodule_base")

---@enum STATE
local STATE = {
    Idle = 0,
    ReadyToDash = 1,
    Dashing = 2
}

---@class AstroTrooper: AstroBase
---@field shootFrom number Shoot from module. Relative to curtime
---@field dashDirection Vector
---@field inDash boolean 
local AstroTrooper = {}
AstroTrooper.Identifier = "astrotrooper"
AstroTrooper.Name = "AstroTrooper"
AstroTrooper.Model = function()
    local mdl = model.create("astrotrooper")
    return mdl
end
AstroTrooper.hooks = {}
AstroTrooper.CameraOffset = Vector(9, 0, -4)
---@type AstroModuleCfg[]
AstroTrooper.Modules = {
    { offset = Vector(0, 40, 0), module = "astrotrooper_blaster" },
    { offset = Vector(0, -40, 0), module = "astrotrooper_blaster" }
}

if SERVER then
    function AstroTrooper:astroInitialize()
        self.ent:setSequence(1)
        self.ent:emitSound("npc/combine_gunship/dropship_engine_distant_loop1.wav", 75, 70, 1)
        self:setState(STATE.Idle)
    end

    ---[SERVER] Set next dash time
    ---@param nextDash number Relative to curtime
    function AstroTrooper:setNextDash(nextDash)
        self:setNWVar("NextDash", nextDash)
    end

    local function createDashEffectHolo(offset, parent)
        local holo = hologram.create(parent:localToWorld(offset), Angle(), "models/hunter/plates/plate.mdl")
        if !holo then return end
        holo:setParent(parent)
        holo:setTrails(32, 0, 2, "trails/laser", Color(255, 0, 0))
        holo:setColor(Color(0, 0, 0, 0))
        timer.simple(1.8, function()
            holo:setParent(nil)
            timer.simple(3, function()
                holo:remove()
            end)
        end)
        return holo
    end

    function AstroTrooper:inputPressed(button)
        local state = self:getState()
        if button == MOUSE.MOUSE1 and state == STATE.Idle then
            local mod = self.modules[self.shootFrom or 2]
            mod:activate()
            local newId = self.shootFrom == 1 and 2 or 1
            if self.modules[newId]:isAlive() then
                self.shootFrom = newId
            end
        elseif button == MOUSE.MOUSE2 and state == STATE.Idle then
            if self:getNextDash() > timer.curtime() then return end
            self:setState(STATE.ReadyToDash)
            astrosound.play {"predash", nil, self.ent}
            for _, v in ipairs(self.modules) do
                timer.simple(v:getModuleID() == 2 and 0.2 or 0, function()
                    if !isValid(v) then return end
                    v.ent:setSequence(3)
                end)
            end
            timer.simple(1, function()
                if !isValid(self) or self:getState() ~= STATE.ReadyToDash then return end
                createDashEffectHolo(Vector(0, 40, 0), self.ent)
                createDashEffectHolo(Vector(0, -40, 0), self.ent)
                self:setState(STATE.Dashing)
                local dir = self:getDirection()
                if !dir then return end
                astrosound.play {"dash", nil, self.ent}
                self.dashDirection = !dir:isZero() and dir or self.ent:getAngles():getForward()
            end)
            timer.simple(2.4, function()
                if !isValid(self) or self:getState() ~= STATE.Dashing then return end
                self:setState(STATE.Idle)
                self:setNextDash(timer.curtime() + 3)
            end)
        end
    end

    function AstroTrooper:think()
        local state = self:getState()
        if state == STATE.Dashing and self.dashDirection then
            self:setVelocity(self.dashDirection * 4000)
        end
    end

    function AstroTrooper:onDeath()
        for _, v in ipairs(self.modules) do
            v.ent:applyDamage(v:getHealth())
        end
        self:remove()
    end
else
    local l1 = light.create(Vector(), 80, 10, Color(255, 0, 0))
    local l2 = light.create(Vector(), 80, 10, Color(255, 0, 0))

    function AstroTrooper:renderOffscreen()
        if !self:getDriver() then return end
        l1:setPos(self.ent:localToWorld(Vector(0, 0, 20)))
        l2:setPos(self.ent:localToWorld(Vector(0, 0, -10)))
        l1:draw()
        l2:draw()
    end
end

---[SHARED] Get next dash time
---@return number nextDash
function AstroTrooper:getNextDash()
    return self:getNWVar("NextDash", 0)
end

ents.register(AstroTrooper, "astrobase")

if SERVER then
    local ent = ents.create("astrotrooper")
    ent:spawn(chip():getPos() + Vector(0, 0, 30), Angle(), true)
end
