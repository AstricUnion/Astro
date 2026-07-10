---@include astronew/baseincludes.lua
---@include astronew/models/astroscout.lua

require("astronew/baseincludes.lua")
require("astronew/models/astroscout.lua")


if SERVER then
    local ch = chip()
    local mdl = model.create("astroscout_leftarm")
    mdl:setPos(ch:getPos())
    mdl:setAngles(ch:getAngles())
    mdl:setParent(ch)
end
