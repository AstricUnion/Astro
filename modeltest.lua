---@include astronew/baseincludes.lua
---@include astronew/models/astrostriker.lua

require("astronew/baseincludes.lua")
require("astronew/models/astrostriker.lua")


if CLIENT then
    local ch = chip()
    local mdl = model.create("astrostriker")
    mdl:setPos(ch:getPos())
    mdl:setAngles(ch:getAngles())
    mdl:setSequence(1)
end
