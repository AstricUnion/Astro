---@include astronew/baseincludes.lua
---@include astronew/models/astroscout_full.lua

require("astronew/baseincludes.lua")
require("astronew/models/astroscout_full.lua")


if SERVER then
    local ch = chip()
    local mdl = model.create("astroscout")
    mdl:setPos(ch:getPos())
    mdl:setAngles(ch:getAngles())
    mdl:setParent(ch)
end
