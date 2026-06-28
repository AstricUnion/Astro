---@name Astro
---@author AstricUnion
---@include astronew/libs/bmodentity/entity.lua
---@include astronew/libs/model/model.lua
---@include astronew/libs/tween/tweens.lua
---@include astronew/models/astrotrooper.lua
---@include astronew/src/astrobase.lua
---@include astronew/src/guns.lua

---@class ents
ents = require("astronew/libs/bmodentity/entity.lua")

---@class model
model = require("astronew/libs/model/model.lua")

---@class tween 
tween = require("astronew/libs/tween/tweens.lua")

require("astronew/models/astrotrooper.lua")
require("astronew/src/astrobase.lua")

---@class guns
guns = require("astronew/src/guns.lua")


---@class AstroTrooperBlaster: AstroModuleBase
local AstroTrooperBlaster = {}
AstroTrooperBlaster.Identifier = "astrotrooper_blaster"
AstroTrooperBlaster.Name = "AstroTrooper blaster"
AstroTrooperBlaster.Model = function()
    local mdl = model.create("astrotrooper_blaster")
    return mdl
end
AstroTrooperBlaster.hooks = {}

if SERVER then
    function AstroTrooperBlaster:onActivate()
        self.ent:setSequence(1)
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
    {
        offset = Vector(0, 40, 0),
        module = "astrotrooper_blaster"
    },
    {
        offset = Vector(0, -40, 0),
        module = "astrotrooper_blaster"
    }
}

local projectileModel = function()
    return model.create("astrotrooper_projectile")
end

if SERVER then
    function AstroTrooper:astroInitialize()
        self.ent:setSequence(1)
    end

    function AstroTrooper:inputPressed(button)
        if button == MOUSE.MOUSE1 then
            local mod = self.modules[self.shootFrom or 2]
            mod:activate()
            guns.createProjectile(mod.ent:getPos(), mod.ent:getAngles(), projectileModel, self.filter)
            self.shootFrom = self.shootFrom == 1 and 2 or 1
        end
    end
end

ents.register(AstroTrooper, "astrobase")

if SERVER then
    local ent = ents.create("astrotrooper")
    ent:spawn(chip():getPos() + Vector(0, 0, 30), Angle(), true)
end
