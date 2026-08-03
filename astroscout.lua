---@name AstroScout
---@author AstricUnion
---@include astronew/baseincludes.lua
---@include astronew/models/astroscout.lua
---@include astronew/entities/astrodash.lua
---@include astronew/entities/astroscout.lua

require("astronew/baseincludes.lua")

---@include effects/berserk.lua
---@include effects/dashtrail.lua
---@include effects/hitsmoke.lua
---@include effects/laser.lua
---@include effects/projectile_explosion.lua
require("effects/berserk.lua")
require("effects/dashtrail.lua")
require("effects/hitsmoke.lua")
require("effects/laser.lua")
require("effects/projectile_explosion.lua")

require("astronew/models/astroscout.lua")
require("astronew/entities/astrodash.lua")
require("astronew/entities/astroscout.lua")


if SERVER then
    local ent = ents.create("astroscout")
    ent:spawn(chip():getPos() + Vector(0, 0, 50), Angle(), false)
end
