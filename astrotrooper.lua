---@name AstroTrooper
---@author AstricUnion
---@include astronew/baseincludes.lua
---@include astronew/models/astrotrooper.lua
---@include astronew/entities/astroblaster.lua
---@include astronew/entities/astrodash.lua
---@include astronew/entities/astrowarpdash.lua
---@include astronew/entities/astrotrooper.lua

require("astronew/baseincludes.lua")

---@include astronew/effects/blaster_muzzle.lua
---@include astronew/effects/hitsmoke.lua
---@include astronew/effects/plasma_exhaust.lua
---@include astronew/effects/projectile_explosion.lua
---@include astronew/effects/quantum_burst.lua
require("astronew/effects/blaster_muzzle.lua")
require("astronew/effects/hitsmoke.lua")
require("astronew/effects/plasma_exhaust.lua")
require("astronew/effects/projectile_explosion.lua")
require("astronew/effects/quantum_burst.lua")

require("astronew/models/astrotrooper.lua")
require("astronew/entities/astroblaster.lua")
require("astronew/entities/astrodash.lua")
require("astronew/entities/astrowarpdash.lua")
require("astronew/entities/astrotrooper.lua")


if SERVER then
    local ent = ents.create("astrotrooper")
    ent:spawn(chip():getPos() + Vector(0, 0, 30), Angle(), false)
end
