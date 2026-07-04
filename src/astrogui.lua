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

---[CLIENT] Pop mask to scissor
function astrogui.popScissorMask()
    render.setStencilEnable(false)
    render.clearStencil()
end


local mat = material.load("gui/gradient_up")

local fontArial32 = render.createFont("Arial",18,500,true,false,false,false,0,false,0)
local function progressBarOutline(x, y, w, h, leftText, rightText)
    render.setColor(Color(255, 20, 20, 200))
    render.setFont(fontArial32)
    render.drawSimpleText(x, y + 2, leftText, nil, TEXT_ALIGN.BOTTOM)
    render.drawSimpleText(x + w, y + 2, rightText, TEXT_ALIGN.RIGHT, TEXT_ALIGN.BOTTOM)
    astrogui.pushScissorMask(function()
        render.drawRectFast(x + 4, y, w - 8, h)
    end)
    render.drawRectOutline(x, y, w, h, 2)
    astrogui.popScissorMask()
end

---[CLIENT] Draw progress bar
---@param x number
---@param y number
---@param w number
---@param h number
---@param progress number
---@param leftText string?
---@param rightText string?
function astrogui.drawProgressBar(x, y, w, h, progress, leftText, rightText)
    progress = math.clamp(progress, 0, 1)
    render.setMaterial(mat)
    render.setColor(Color(255, 70, 70, 30))
    render.drawTexturedRectFast(x + 8, y + 4, w - 16, h - 8)

    local progressWidth = (w - 16) * progress
    render.setColor(Color(255, 70, 70, 50))
    render.drawRectFast(x + 8, y + 4, progressWidth, h - 8)
    render.setColor(Color(255, 20, 20, 200))
    render.setMaterial(mat)
    render.drawTexturedRectFast(x + 8, y + 4, progressWidth, h - 8)
    progressBarOutline(x, y, w, h, leftText or "", rightText or "")
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
function astrogui.drawProgressBarSections(x, y, w, h, sectionW, progress, leftText, rightText)
    progress = math.clamp(progress, 0, 1)
    local fullW = sectionW + 4
    local count = (w - 24) / fullW
    for i=0, count do
        if i < math.ceil((count + 1) * progress) then
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
    progressBarOutline(x, y, w, h, leftText or "", rightText or "")
end

return astrogui
