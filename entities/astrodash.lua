---@class AstroDash: AstroModuleBase
---@field Speed number Speed of dash
---@field DashTime number Duration of dash
---@field Cooldown number Cooldown of dash
---@field AllowVarying boolean Allow dash varying by press duration. By default is true
---@field VaryingDelta number Delta of varying. WARNING: will be multiplied by tick interval
---@field Radius number Radius for dash. Will be added to Astro radius to stop dash
---@field dashStartTime number?
---@field dashTime number?
local AstroDash = {}
AstroDash.Identifier = "astrodash"
AstroDash.Name = "AstroDash"
AstroDash.hooks = {}
AstroDash.Speed = 4000
AstroDash.DashTime = 1
AstroDash.Cooldown = 3
AstroDash.AllowVarying = true
AstroDash.VaryingDelta = 0.5
AstroDash.Radius = 0
AstroDash.Control = "G"

---[SHARED] Hook after dash start
---@param astro AstroBase Astro this module pinned to
function AstroDash:dashStart(astro) end

---[SERVER] Hook on dash end
---@param astro AstroBase Astro this module pinned to
---@param dir Vector Direction of dash before end
function AstroDash:dashEnd(astro, dir) end

function AstroDash:onAction(action)
    local dir = self:getDirection()
    if !dir then
        if action == "dash" then
            local astro = self:getAstro()
            if !isValid(astro) then return end
            if SERVER then
                local dir = self:calcDirection(astro)
                if !dir then return end
                self.dashStartTime = timer.curtime()
                self.dashTime = self.DashTime
                self.startedVarying = self.AllowVarying
                self:setNWVar("dashDirection", dir)
                self:dashStart(astro)
                return true
            else
                self:dashStart(astro)
            end
        end
    else
        if SERVER and self.dashTime and self.AllowVarying then
            if action == "dash"  then
                self.startedVarying = true
            elseif action == "stopAddToDash" then
                self.startedVarying = nil
            end
        end
    end
end

if SERVER then
    ---[SERVER] Check next Astro position by trace
    ---@param astro AstroBase Astro to get position
    ---@param dir Vector Direction to dash
    ---@param speed number Speed to get position
    ---@param offset Vector? Offset of trace
    function AstroDash:checkByTrace(astro, dir, speed, offset)
        local pos = offset == nil and astro.ent:getPos() or astro.ent:getPos() + offset
        local interval = game.physicsFrameTime()
        local endPos = pos + dir * (interval * speed)
        local canPos = trace.hull(pos, endPos, Vector(-40), Vector(40), astro.filter)
        return canPos.Hit
    end

    ---[SERVER] Calculate dash direction. You can override this method, if you want
    ---@return Vector? direction If nil, then there is not driver
    function AstroDash:calcDirection(astro)
        local dir = astro:getDirection()
        if !dir then return end
        return !dir:isZero() and dir or astro.ent:getAngles():getForward()
    end

    ---[SERVER] Is Astro can dash
    function AstroDash:canDash()
        local astro = self:getAstro()
        if !isValid(astro) then return end
        local dir = self:calcDirection(astro)
        if !dir then return end
        return !self:checkByTrace(astro, dir, self.Speed * 2, dir * (astro.Radius + self.Radius))
    end

    ---[SERVER] Is Astro can action
    function AstroDash:isCanAction(action)
        if action == "dash" then
            return self:canDash()
        end
        return true
    end

    ---[SERVER] Think when dashing. By default this hook made check by trace
    ---@param astro AstroBase Astro this module pinned to
    ---@param dir Vector Direction of dash
    ---@return boolean? endDash End a dash
    function AstroDash:dashThink(astro, dir)
        return self:checkByTrace(astro, dir, self.Speed, dir * (astro.Radius + self.Radius))
    end

    function AstroDash:think()
        local dir = self:getDirection()
        if dir then
            local astro = self:getAstro()
            if !isValid(astro) then return end
            astro:setVelocity(dir * self.Speed)
            if self.startedVarying then
                self.dashTime = self.dashTime + game.getTickInterval() * self.VaryingDelta
            end
            local cur = timer.curtime()
            local function endDash()
                self:setNextAction("dash", cur + self.Cooldown)
                self:dashEnd(astro, dir)
                self:setNWVar("dashDirection", nil)
            end
            local remain = self.dashTime - (cur - self.dashStartTime)
            if remain <= 0 or !isValid(astro.driver) or self:dashThink(astro, dir) == true then
                endDash()
                return
            end
        end
    end
else
    function AstroDash:networkVariablesUpdate(oldVars, vars)
        if oldVars.dashDirection ~= false and vars.dashDirection == false then
            local astro = self:getAstro()
            if !isValid(astro) then return end
            self:dashEnd(astro, oldVars.dashDirection or Angle():getForward())
        end
    end

    function AstroDash:drawHUD(x, y)
        local dir = self:getDirection()
        local percent = !dir and (1 - (math.clamp((self:getNextAction("dash") - timer.curtime()) / self.Cooldown, 0, 1))) or 0
        astrogui.drawProgressBar(x - 85, y, 170, 20, percent, "DASH_MOD", (math.ceil(percent * 100)) .. "%", true, true)
        astrogui.control(x + 101, y + 10, self.Control, !((self.AllowVarying and dir ~= nil) or percent == 1))
    end
end

---[SHARED] Get direction of dash
---@return Vector?
function AstroDash:getDirection()
    return self:getNWVar("dashDirection")
end

ents.register(AstroDash, "astromodule_base")
