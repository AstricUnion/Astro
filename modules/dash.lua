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
        self:setNWVar("dashDirection", !dir:isZero() and dir or self.ent:getAngles():getForward())
    end

    function AstroDash:think()
        local dir = self:getDirection()
        if dir then
            local astro = self:getAstro()
            if !astro then return end
            astro:setVelocity(dir * 4000)
            local cur = timer.curtime()
            if cur - self.dashStartTime >= 1 then
                self:setNWVar("dashDirection", nil)
                self:setNextAction("dash", cur + 3)
                self:dashEnd()
            end
        end
    end

    ---[SERVER] Hook on dash end
    function AstroDash:dashEnd() end
end


---[SHARED] Get direction of dash
---@return Vector?
function AstroDash:getDirection()
    return self:getNWVar("dashDirection")
end

ents.register(AstroDash, "astromodule_base")
