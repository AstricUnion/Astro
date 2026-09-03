---@name AstroStriker
---@author AstricUnion
---@include ./baseincludes.lua
---@include ./models/astrostriker.lua
---@include ./entities/astrostriker.lua

require("./baseincludes.lua")

require("./models/astrostriker.lua")
require("./entities/astrostriker.lua")


if SERVER then
    local ent = ents.create("astrostriker")
    ent:spawn(chip():getPos() + Vector(0, 0, 50), Angle(), false)
end
