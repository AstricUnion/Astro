---@class ToDraw
---@field lifetime number Relative to timer.curtime()
---@field data table Draw data
---@field drawFunction string Draw function name

---@class bdebug
---@field drawFunctions table<string, fun(data: table)>
---@field toDraw ToDraw[]
local bdebug = {}
bdebug.drawFunctions = {
    ["box"] = function(data)
        local pos, ang, mins, maxs, color = data.pos, data.ang, data.mins, data.maxs, data.color
        render.draw3DWireframeBox(pos, ang, mins, maxs)
        render.setColor(color)
        render.draw3DBox(pos, ang, mins, maxs)
    end,
    ["cross"] = function(data)
        local pos, size, color = data.pos, data.ang, data.mins
        render.setColor(color)
        render.draw3DLine(pos, ang, mins, maxs)
    end
}
bdebug.toDraw = {}


---[SHARED] Displays a solid coloured box at the specified position.
---Note: This function will silently fail if the developer ConVar is set to 0
---It is not networked to clients, except for chip owner 
---@param pos Vector Position origin
---@param mins Vector Minimum bounds of the box
---@param maxs Vector Maximum bounds of the box
---@param lifetime number? Number of seconds to appear. By default is 1
---@param color Color? The color of the box
function bdebug.box(pos, mins, maxs, lifetime, color)
    if !CLIENT then return end
    bdebug.toDraw[#bdebug.toDraw+1] = {
        lifetime = timer.curtime() + (lifetime or 1),
        data = {
            pos = pos,
            mins = mins,
            maxs = maxs,
            color = color or Color(255, 255, 255, 255),
            ang = Angle()
        },
        drawFunction = "box"
    }
end


---[SHARED] Displays a solid coloured rotated box at the specified position.
---Note: This function will silently fail if the developer ConVar is set to 0
---It is not networked to clients, except for chip owner 
---@param pos Vector Position origin
---@param mins Vector Minimum bounds of the box
---@param maxs Vector Maximum bounds of the box
---@param ang Angle The angle to draw box at
---@param lifetime number Number of seconds to appear
---@param color Color The color of the box
function bdebug.boxAngles(pos, mins, maxs, ang, lifetime, color)
    if !CLIENT then return end
    bdebug.toDraw[#bdebug.toDraw+1] = {
        lifetime = timer.curtime() + (lifetime or 1),
        data = {
            pos = pos,
            mins = mins,
            maxs = maxs,
            color = color or Color(255, 255, 255, 255),
            ang = ang
        },
        drawFunction = "box"
    }
end


if OWNER and convar.getBool("developer") then
    hook.add("PostDrawTranslucentRenderables", "BDebugDraw", function()
        local newToDraw = {}
        local cur = timer.curtime()
        local startColor = Color(255, 255, 255, 255)
        local funcs = bdebug.drawFunctions
        for _, v in ipairs(bdebug.toDraw) do
            if v.lifetime > cur then
                newToDraw[#newToDraw+1] = v
            end
            render.setColor(startColor)
            funcs[v.drawFunction](v.data)
        end
        bdebug.toDraw = newToDraw
    end)
    enableHud(owner(), true)
end

return bdebug
