---@class AstroDash: AstroModuleBase
---@field dashStartTime number?
---@field dashTime number?
local AstroDash = {}
AstroDash.Identifier = "astrodash"
AstroDash.Name = "AstroDash"
AstroDash.hooks = {}

if SERVER then
    function AstroDash:onAction(action)
        if action == "dash" then
            local astro = self:getAstro()
            if !astro then return end
            local dir = astro:getDirection()
            if !dir then return end
            self.dashStartTime = timer.curtime()
            self.dashTime = 1
            self:setNWVar("dashDirection", !dir:isZero() and dir or self.ent:getAngles():getForward())
        elseif action == "addToDash" and self.dashTime then
            self.dashTime = self.dashTime + game.getTickInterval() / 2
        end
    end

    local world = game.getWorld()
    function AstroDash:think()
        local dir = self:getDirection()
        if dir then
            local astro = self:getAstro()
            if !astro then return end
            astro:setVelocity(dir * 4000)
            local pos = astro.ent:getPos()
            local toDamage = find.inSphere(pos, 128)
            for _, v in ipairs(toDamage) do
                local permitted, _ = hasPermission("entities.applyDamage", v)
                if permitted and v ~= world and !table.hasValue(astro.filter, v) then
                    v:applyDamage(25, astro.ent, self.ent)
                end
            end
            local cur = timer.curtime()
            local interval = game.getTickInterval()
            local remain = self.dashTime - (cur - self.dashStartTime)
            local remainVel = remain * 4000
            local endPos = pos + dir * remainVel
            local tr = trace.line(pos, endPos, astro.filter)
            local cantDash = false
            if tr.Hit then
                local canPos = tr.HitPos + dir * (interval * math.min(4000 + 1024, remainVel))
                cantDash = !canPos:isInWorld()
            end
            if remain <= 0 or cantDash then
                self:setNWVar("dashDirection", nil)
                self:setNextAction("dash", cur + 3)
                self:setNWVar("nextDash", cur + 3)
                self:dashEnd()
            end
        end
    end

    ---[SERVER] Hook on dash end
    function AstroDash:dashEnd() end
else
    function AstroDash:drawHUD(x, y)
        local dir = self:getDirection()
        local percent = !dir and (1 - (math.clamp(self:getNextDash() - timer.curtime(), 0, 3) / 3)) or 0
        astrogui.drawProgressBar(x - 85, y, 170, 20, percent, "DASH_MOD", (math.ceil(percent * 100)) .. "%", true, true)
    end
end


---[SHARED] Get direction of dash
---@return Vector?
function AstroDash:getDirection()
    return self:getNWVar("dashDirection")
end

---[SHARED] Get next time to dash
---@return Vector?
function AstroDash:getNextDash()
    return self:getNWVar("nextDash", 0)
end

ents.register(AstroDash, "astromodule_base")
