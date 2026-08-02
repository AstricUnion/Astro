---@name AstroTrooper
---@author AstricUnion
---@include astronew/baseincludes.lua
---@include astronew/models/astrotrooper.lua
---@include astronew/entities/astroblaster.lua
---@include astronew/entities/astrodash.lua
---@include astronew/entities/astrowarpdash.lua
---@include astronew/entities/astrotrooper.lua

require("astronew/baseincludes.lua")

---@include effects/blaster_muzzle.lua
---@include effects/hitsmoke.lua
---@include effects/plasma_exhaust.lua
---@include effects/projectile_explosion.lua
---@include effects/quantum_burst.lua
require("effects/blaster_muzzle.lua")
require("effects/hitsmoke.lua")
require("effects/plasma_exhaust.lua")
require("effects/projectile_explosion.lua")
require("effects/quantum_burst.lua")

require("astronew/models/astrotrooper.lua")
require("astronew/entities/astroblaster.lua")
require("astronew/entities/astrodash.lua")
require("astronew/entities/astrowarpdash.lua")
require("astronew/entities/astrotrooper.lua")


if SERVER then
    local ent = ents.create("astrotrooper")
    ent:spawn(chip():getPos() + Vector(0, 0, 30), Angle(), false)
end
