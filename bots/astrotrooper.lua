---@name AstroTrooper
---@author AstricUnion
---@include astronew/libs/astrosound.lua
---@include astronew/libs/bmodentity/entity.lua
---@include astronew/libs/model/model.lua
---@include astronew/libs/tween/tweens.lua
---@include astronew/models/astrotrooper.lua
---@include astronew/src/astrobase.lua
---@include astronew/src/astromodule.lua
---@include astronew/src/guns.lua
---@include astronew/libs/beffect/effects.lua
---@include astronew/libs/beffect/safeparticle.lua
---@include astronew/modules/blaster.lua
---@include astronew/modules/dash.lua

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
require("astronew/src/astromodule.lua")
require("astronew/src/astrobase.lua")
require("astronew/modules/blaster.lua")
require("astronew/modules/dash.lua")

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
    {offset = Vector(0, 40, 0), module = "astroblaster"},
    {offset = Vector(0, -40, 0), module = "astroblaster"},
    {offset = Vector(), module = "astrodash"}
}

if SERVER then
    function AstroTrooper:astroInitialize()
        self.ent:setSequence(1)
        self.ent:emitSound("npc/combine_gunship/dropship_engine_distant_loop1.wav", 75, 70, 1)
        self.shootFrom = 1
        self.modules[3].dashEnd = function(mod)
            timer.simple(1, function()
                self:setState(STATE.Idle)
            end)
        end
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
        if state ~= STATE.Idle then return end
        if button == MOUSE.MOUSE1 then
            local mod = self.modules[self.shootFrom]
            mod:sendAction("shoot")
            local newId = self.shootFrom == 1 and 2 or 1
            if self.modules[newId]:isAlive() then
                self.shootFrom = newId
            end
        elseif button == MOUSE.MOUSE2 then
            if !self.modules[3]:canAction("dash") then return end
            astrosound.play {"predash", nil, self.ent}
            for i=0, 1 do
                local mod = self.modules[i + 1]
                timer.simple(0.2 * i, function()
                    if !isValid(mod) then return end
                    mod.ent:setSequence(3)
                end)
            end
            self:setState(STATE.ReadyToDash)
            timer.simple(1, function()
                createDashEffectHolo(Vector(0, 40, 0), self.ent)
                createDashEffectHolo(Vector(0, -40, 0), self.ent)
                astrosound.play {"dash", nil, self.ent}
                self.modules[3]:sendAction("dash")
                self:setState(STATE.Dashing)
            end)
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
