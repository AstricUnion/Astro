---@name AstroTrooper
---@author AstricUnion
---@include astronew/libs/bmodentity/entity.lua
---@include astronew/libs/model/model.lua
---@include astronew/libs/tween/tweens.lua
---@include astronew/models/astrotrooper.lua
---@include astronew/src/astrobase.lua
---@include astronew/src/guns.lua
---@include astronew/libs/beffect/effects.lua
---@include astronew/libs/beffect/safeparticle.lua

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


---@class AstroTrooperBlaster: AstroModuleBase
---@field nextShoot number
---@field ammo number
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
        local astro = self:getAstro()
        if !astro then return end
        self.nextShoot = cur + 0.1
        self.ent:setSequence(1)
        self.ammo = self.ammo - 1
        local angs = self.ent:getAngles()
        guns.createProjectile(self.ent:getPos(), angs, projectileModel, astro.filter)
        astro:addVelocity(-angs:getForward() * 20)
        if self.ammo <= 0 then
            self.nextShoot = cur + 1.3
            timer.simple(0.3, function()
                self.ent:setSequence(2)
                self.ammo = 4
            end)
        end
    end

    function AstroTrooperBlaster:think()
        local astro = self:getAstro()
        if !astro then return end
        local tr = astro:getEyeTrace()
        if !tr then return end
        self.ent:setAngles((tr.HitPos - self.ent:getPos()):getAngle())
    end
end

ents.register(AstroTrooperBlaster, "astromodule_base")



---@class AstroTrooper: AstroBase
---@field shootFrom number Shoot from module
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
    end

    function AstroTrooper:inputPressed(button)
        if button == MOUSE.MOUSE1 then
            local mod = self.modules[self.shootFrom or 2]
            mod:activate()
            self.shootFrom = self.shootFrom == 1 and 2 or 1
        end
    end
else
    local l1 = light.create(Vector(), 80, 10, Color(255, 0, 0))
    local l2 = light.create(Vector(), 80, 10, Color(255, 0, 0))

    function AstroTrooper:renderOffscreen()
        l1:setPos(self.ent:localToWorld(Vector(0, 0, 20)))
        l2:setPos(self.ent:localToWorld(Vector(0, 0, -10)))
        l1:draw()
        l2:draw()
    end
end

ents.register(AstroTrooper, "astrobase")

if SERVER then
    local ent = ents.create("astrotrooper")
    ent:spawn(chip():getPos() + Vector(0, 0, 30), Angle(), true)
end
