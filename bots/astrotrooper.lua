---@name Astro
---@author AstricUnion
---@include astronew/libs/bmodentity/entity.lua
---@include astronew/libs/model/model.lua
---@include astronew/models/astrotrooper.lua
---@include astronew/src/astrobase.lua

---@class ents
ents = require("astronew/libs/bmodentity/entity.lua")

---@class model
model = require("astronew/libs/model/model.lua")

require("astronew/models/astrotrooper.lua")
require("astronew/src/astrobase.lua")

---@class AstroTrooper: AstroBase
local AstroTrooper = {}
AstroTrooper.Identifier = "astrotrooper"
AstroTrooper.Name = "AstroTrooper"
AstroTrooper.Model = function()
    local mdl = model.create("astrotrooper")
    return mdl
end
AstroTrooper.hooks = {}

ents.register(AstroTrooper, "astrobase")

if SERVER then
    local ent = ents.create("astrotrooper")
    ent:spawn(chip():getPos() + Vector(0, 0, 30), Angle(), true)
end
