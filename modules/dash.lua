---@class AstroDash: AstroModuleBase
---@field dashDirection Vector
---@field dashStartTime number
local AstroDash = {}
AstroDash.Identifier = "astrodash"
AstroDash.Name = "AstroDash"
AstroDash.hooks = {}

if SERVER then
    function AstroDash:onAction(action)
        if action ~= "dash" then return end
        local astro = self:getAstro()
        if !astro then return end
        local dir = astro:getDirection()
        if !dir then return end
        self.dashStartTime = timer.curtime()
        self.dashDirection = !dir:isZero() and dir or self.ent:getAngles():getForward()
    end

    function AstroDash:think()
        if self.dashDirection then
            local astro = self:getAstro()
            if !astro then return end
            astro:setVelocity(self.dashDirection * 4000)
            local cur = timer.curtime()
            if cur - self.dashStartTime >= 1.4 then
                self.dashDirection = nil
                self:setNextAction("dash", cur + 3)
                self:dashEnd()
            end
        end
    end

    ---[SERVER] Hook on dash end
    function AstroDash:dashEnd() end
end

ents.register(AstroDash, "astromodule_base")
