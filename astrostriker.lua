---@name AstroStriker
---@author AstricUnion
---@include astronew/baseincludes.lua
---@include astronew/models/astrostriker.lua
---@include astronew/entities/astrostriker.lua

require("astronew/baseincludes.lua")

require("astronew/models/astrostriker.lua")
require("astronew/entities/astrostriker.lua")


if SERVER then
    local ent = ents.create("astrostriker")
    ent:spawn(chip():getPos() + Vector(0, 0, 50), Angle(), false)
end
