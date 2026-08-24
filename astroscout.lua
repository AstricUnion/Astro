---@name AstroScout
---@author AstricUnion
---@include astronew/baseincludes.lua
---@include astronew/models/astroscout.lua
---@include astronew/entities/astrodash.lua
---@include astronew/entities/astroscout.lua

require("astronew/baseincludes.lua")

---@include astronew/effects/berserk.lua
---@include astronew/effects/dashtrail.lua
---@include astronew/effects/hitsmoke.lua
---@include astronew/effects/laser.lua
---@include astronew/effects/projectile_explosion.lua
require("astronew/effects/berserk.lua")
require("astronew/effects/dashtrail.lua")
require("astronew/effects/hitsmoke.lua")
require("astronew/effects/laser.lua")
require("astronew/effects/projectile_explosion.lua")

require("astronew/models/astroscout.lua")
require("astronew/entities/astrodash.lua")
require("astronew/entities/astroscout.lua")


if SERVER then
    local ent = ents.create("astroscout")
    ent:spawn(chip():getPos() + Vector(0, 0, 50), Angle(), false)
end
