if !CLIENT then return end

---GUI for Astro
---@class astrogui
local astrogui = {}


---[CLIENT] Push mask to scissor something at canvas
---@param mask fun()
function astrogui.pushScissorMask(mask)
    render.clearStencil()
    render.setStencilEnable(true)

    render.setStencilWriteMask(1)
    render.setStencilTestMask(1)

    render.setStencilFailOperation(STENCIL.REPLACE)
    render.setStencilPassOperation(STENCIL.ZERO)
    render.setStencilZFailOperation(STENCIL.ZERO)
    render.setStencilCompareFunction(STENCIL.NEVER)
    render.setStencilReferenceValue(1)

    mask()

    render.setStencilFailOperation(STENCIL.ZERO)
    render.setStencilPassOperation(STENCIL.REPLACE)
    render.setStencilZFailOperation(STENCIL.ZERO)
    render.setStencilCompareFunction(STENCIL.EQUAL)
    render.setStencilReferenceValue(0)
end

---[CLIENT] Push mask to select something at canvas
---@param mask fun()
function astrogui.pushSelectionMask(mask)
    render.clearStencil()
    render.setStencilEnable(true)

    render.setStencilWriteMask(1)
    render.setStencilTestMask(1)

    render.setStencilFailOperation(STENCIL.REPLACE)
    render.setStencilPassOperation(STENCIL.ZERO)
    render.setStencilZFailOperation(STENCIL.ZERO)
    render.setStencilCompareFunction(STENCIL.NEVER)
    render.setStencilReferenceValue(1)

    mask()

    render.setStencilFailOperation(STENCIL.ZERO)
    render.setStencilPassOperation(STENCIL.REPLACE)
    render.setStencilZFailOperation(STENCIL.ZERO)
    render.setStencilCompareFunction(STENCIL.EQUAL)
    render.setStencilReferenceValue(1)
end

---[CLIENT] Pop stencil mask
function astrogui.popStencilMask()
    render.setStencilEnable(false)
    render.clearStencil()
end


local mat = material.load("gui/gradient_up")

local fontArial32 = render.createFont("Arial",18,500,true,false,false,false,0,false,0)
local function progressBarOutline(x, y, w, h, leftText, rightText, textBottom)
    render.setColor(Color(255, 20, 20, 200))
    render.setFont(fontArial32)
    local vAlign = textBottom and TEXT_ALIGN.TOP or TEXT_ALIGN.BOTTOM
    local yOffset = textBottom and h - 2 or 2
    render.drawSimpleText(x, y + yOffset, leftText, nil, vAlign)
    render.drawSimpleText(x + w, y + yOffset, rightText, TEXT_ALIGN.RIGHT, vAlign)
    astrogui.pushScissorMask(function()
        render.drawRectFast(x + 4, y, w - 8, h)
    end)
    render.drawRectOutline(x, y, w, h, 2)
    astrogui.popStencilMask()
end

---[CLIENT] Draw progress bar
---@param x number
---@param y number
---@param w number
---@param h number
---@param progress number
---@param leftText string?
---@param rightText string?
---@param textBottom boolean?
---@param centerBar boolean?
function astrogui.drawProgressBar(x, y, w, h, progress, leftText, rightText, textBottom, centerBar)
    progress = math.clamp(progress, 0, 1)
    render.setMaterial(mat)
    render.setColor(Color(255, 70, 70, 30))
    render.drawTexturedRectFast(x + 8, y + 4, w - 16, h - 8)

    local progressWidth = (w - 16) * progress
    render.setColor(Color(255, 70, 70, 100))
    local offset = (centerBar and (w - 16) / 2 - progressWidth / 2 or 0) + 8
    render.drawRectFast(x + offset, y + 4, progressWidth, h - 8)
    render.setColor(Color(255, 20, 20, 200))
    render.setMaterial(mat)
    render.drawTexturedRectFast(x + offset, y + 4, progressWidth, h - 8)
    progressBarOutline(x, y, w, h, leftText or "", rightText or "", textBottom)
end

---[CLIENT] Draw sectioned progress bar
---@param x number
---@param y number
---@param w number
---@param h number
---@param sectionW number
---@param progress number
---@param leftText string?
---@param rightText string?
---@param textBottom boolean
---@param mirror boolean?
function astrogui.drawProgressBarSections(x, y, w, h, sectionW, progress, leftText, rightText, textBottom, mirror)
    progress = math.clamp(progress, 0, 1)
    progress = mirror and 1 - progress or progress
    local fullW = sectionW + 4
    local count = math.floor((w - 24) / fullW)
    for i=0, count do
        local progressCount = math.ceil((count + 1) * progress)
        if (!mirror and i < progressCount) or (mirror and i >= progressCount) then
            render.setColor(Color(255, 70, 70, 50))
            render.drawRectFast(x + 8 + i * fullW, y + 4, sectionW, h - 8)
            render.setColor(Color(255, 20, 20, 200))
            render.setMaterial(mat)
            render.drawTexturedRectFast(x + 8 + i * fullW, y + 4, sectionW, h - 8)
        else
            render.setColor(Color(255, 70, 70, 30))
            render.setMaterial(mat)
            render.drawTexturedRectFast(x + 8 + i * fullW, y + 4, sectionW, h - 8)
        end
    end
    progressBarOutline(x, y, w, h, leftText or "", rightText or "", textBottom)
end

return astrogui
