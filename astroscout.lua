---@name AstroScout
---@author AstricUnion
---@include astronew/baseincludes.lua
---@include astronew/models/astroscout.lua
---@include astronew/entities/astroscout.lua
---@include astronew/entities/astroscout_arms.lua

require("astronew/baseincludes.lua")

---@includedir astronew/effects
dodir("astronew/effects", {})

require("astronew/models/astroscout.lua")
require("astronew/entities/astroscout.lua")
require("astronew/entities/astroscout_arms.lua")


if SERVER then
    local ent = ents.create("astroscout")
    ent:spawn(chip():getPos() + Vector(0, 0, 30), Angle(), true)
end
