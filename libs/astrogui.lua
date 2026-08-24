if !CLIENT then return end

---GUI for Astro
---@class astrogui
local astrogui = {}
astrogui.colors = {
   main = Color(255, 20, 20, 200),
   mainMouse = Color(255, 100, 100, 200),
   overlay = Color(255, 70, 70, 100),
   overlay1 = Color(255, 70, 70, 30),
   overlay1Mouse = Color(255, 120, 120, 40),
}


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
    render.setColor(astrogui.colors.main)
    render.setFont(fontArial32)
    local vAlign = textBottom and TEXT_ALIGN.TOP or TEXT_ALIGN.BOTTOM
    local yOffset = textBottom and h - 2 or 2
    render.drawSimpleText(x, y + yOffset, leftText, nil, vAlign)
    render.drawSimpleText(x + w, y + yOffset, rightText, TEXT_ALIGN.RIGHT, vAlign)
    astrogui.pushScissorMask(function()
        render.drawRect(x + 4, y, w - 8, h)
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
    render.setMaterial(mat)
    render.setColor(astrogui.colors.overlay1)
    render.drawTexturedRect(x + 8, y + 4, w - 16, h - 8)

    local progressWidth = (w - 16) * progress
    render.setColor(astrogui.colors.overlay)
    local offset = (centerBar and (w - 16) / 2 - progressWidth / 2 or 0) + 8
    render.drawRect(x + offset, y + 4, progressWidth, h - 8)
    render.setColor(astrogui.colors.main)
    render.setMaterial(mat)
    render.drawTexturedRect(x + offset, y + 4, progressWidth, h - 8)
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
    local fullW = sectionW + 4
    local count = math.floor((w - 24) / fullW)
    astrogui.pushSelectionMask(function()
        for i=0, count do
            render.drawRectFast(x + 8 + i * fullW, y + 4, sectionW, h - 8)
        end
    end)
    render.setMaterial(mat)
    render.setColor(astrogui.colors.overlay1)
    render.drawTexturedRect(x + 8, y + 4, w - 16, h - 8)
    local progressWidth = (w - 16) * progress
    render.setColor(astrogui.colors.overlay)
    local offset = mirror and w - 8 - progressWidth or 8
    render.drawRect(x + offset, y + 4, progressWidth, h - 8)
    render.setColor(astrogui.colors.main)
    render.setMaterial(mat)
    render.drawTexturedRect(x + offset, y + 4, progressWidth, h - 8)
    progressBarOutline(x, y, w, h, leftText or "", rightText or "", textBottom)
    astrogui.popStencilMask()
end

local mouseIcon = {
    [MOUSE.MOUSE1] = material.createFromImage("gui/lmb.png", ""),
    [MOUSE.MOUSE2] = material.createFromImage("gui/rmb.png", ""),
    [MOUSE.MOUSE3] = material.createFromImage("gui/mwheel.png", "")
}

function astrogui.control(x, y, control, disabled)
    local colors = astrogui.colors
    local col = disabled and colors.overlay1 or colors.main
    local col1 = disabled and colors.overlay1 or colors.overlay
    local key = KEY[control]
    local mouse = MOUSE[control]
    local isControl = !disabled and ((mouse and input.isMouseDown(mouse)) or (key and input.isKeyDown(key)))
    render.setMaterial(mat)
    render.setColor(isControl and col1 or colors.overlay1)
    render.drawTexturedRect(x - 10, y - 10, 20, 20)
    render.setColor(isControl and col or col1)
    render.drawRectOutline(x - 9, y - 9, 18, 18)
    render.drawRectOutline(x - 10, y - 10, 20, 20)
    local icon = mouse and mouseIcon[mouse]
    if icon then
        local iconCol = disabled and colors.overlay1Mouse or colors.mainMouse
        render.setColor(iconCol)
        render.setMaterial(icon)
        render.drawTexturedRect(x - 9, y - 9, 18, 18)
    else
        render.setColor(col)
        render.drawSimpleText(x, y, control, TEXT_ALIGN.CENTER, TEXT_ALIGN.CENTER)
    end
end

return astrogui
