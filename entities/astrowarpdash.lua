---@class AstroWarpDash: AstroModuleBase
---@field dashStartTime number?
---@field dashTime number?
---@field dashEffect BEffect
local AstroWarpDash = {}
AstroWarpDash.Identifier = "astrowarpdash"
AstroWarpDash.Name = "AstroWarpDash"
AstroWarpDash.hooks = {}

if SERVER then
    function AstroWarpDash:onAction(action)
        if action == "dash" then
            local astro = self:getAstro()
            if !astro then return end
            local dir = astro:getDirection()
            if !dir then return end
            astro.ent:setCollisionGroup(COLLISION_GROUP.IN_VEHICLE)
            self.dashStartTime = timer.curtime()
            self.dashTime = 1
            self:setNWVar("dashDirection", !dir:isZero() and dir or self.ent:getAngles():getForward())
            return true
        elseif action == "addToDash" and self.dashTime then
            self.dashTime = self.dashTime + game.getTickInterval() / 3
        end
    end

    local world = game.getWorld()
    function AstroWarpDash:think()
        local dir = self:getDirection()
        if dir then
            local astro = self:getAstro()
            if !astro then return end
            astro:setVelocity(dir * 4000)
            local pos = astro.ent:getPos()
            local toDamage = find.inSphere(pos, 128)
            for _, v in ipairs(toDamage) do
                if !isValid(v) or v == world then goto cont end
                local permitted, _ = hasPermission("entities.applyDamage", v)
                if permitted and !table.hasValue(astro.filter, v) then
                    v:applyDamage(25, astro.ent, self.ent)
                end
                ::cont::
            end
            local cur = timer.curtime()
            local interval = game.getTickInterval()
            local remain = self.dashTime - (cur - self.dashStartTime)
            local remainVel = remain * 4000
            local endPos = pos + dir * remainVel
            local tr = trace.line(pos, endPos, astro.filter, MASK_SOLID)
            local cantDash = false
            if tr.Hit then
                local canPos = tr.HitPos + dir * (math.min((interval * 4000) + 1024, remainVel))
                cantDash = !canPos:isInWorld()
            end
            if remain <= 0 or cantDash then
                self:setNextAction("dash", cur + 3)
                astro.ent:setCollisionGroup(COLLISION_GROUP.NONE)
                self:dashEnd()
                self:setNWVar("dashDirection", nil)
            end
        end
    end

    ---[SERVER] Hook on dash end
    function AstroWarpDash:dashEnd() end
else
    function AstroWarpDash:drawHUD(x, y)
        local dir = self:getDirection()
        local percent = !dir and (1 - (math.clamp(self:getNextAction("dash") - timer.curtime(), 0, 3) / 3)) or 0
        astrogui.drawProgressBar(x - 85, y, 170, 20, percent, "DASH_MOD", (math.ceil(percent * 100)) .. "%", true, true)
    end

    function AstroWarpDash:networkVariablesUpdate(old, new)
        if old.dashDirection and !new.dashDirection then
            self.dashEffect:destroy()
        elseif !old.dashDirection and new.dashDirection then
            local eff = beff.create("plasma_exhaust")
            eff:setEntity(self.ent)
            eff:play()
            self.dashEffect = eff
        end
    end
end


---[SHARED] Get direction of dash
---@return Vector?
function AstroWarpDash:getDirection()
    return self:getNWVar("dashDirection")
end

ents.register(AstroWarpDash, "astromodule_base")
