---@name AstroTrooper
---@author AstricUnion
---@include astronew/baseincludes.lua
---@include astronew/models/astrotrooper.lua
---@include astronew/entities/astroblaster.lua
---@include astronew/entities/astrowarpdash.lua
---@include astronew/entities/astrotrooper.lua

require("astronew/baseincludes.lua")

---@includedir astronew/effects
dodir("astronew/effects", {})

require("astronew/models/astrotrooper.lua")
require("astronew/entities/astroblaster.lua")
require("astronew/entities/astrowarpdash.lua")
require("astronew/entities/astrotrooper.lua")


if SERVER then
    local ent = ents.create("astrotrooper")
    ent:spawn(chip():getPos() + Vector(0, 0, 30), Angle(), false)
end
