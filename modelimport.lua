
---@include astronew/baseincludes.lua
---@include astronew/models/astrostriker.lua

require("astronew/baseincludes.lua")
require("astronew/models/astrostriker.lua")


if CLIENT and OWNER then
    local mdl = model.create("astrostriker")
    if !mdl then return end
    timer.simple(3, function()
        local objStr = mdl:getObj()
        file.write("astrostriker.sexmdl.txt", objStr)
    end)
end
