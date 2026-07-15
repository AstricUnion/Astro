
---@include astronew/baseincludes.lua
---@include astronew/models/astroscout_full.lua

require("astronew/baseincludes.lua")
require("astronew/models/astroscout_full.lua")


if CLIENT and OWNER then
    local mdl = model.create("astroscout")
    timer.simple(1, function()
        local modelData = mdl:getObj()
        file.write("astroscout.sexmdl.txt", modelData)
    end)
end
