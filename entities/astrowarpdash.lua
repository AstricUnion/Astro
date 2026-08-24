---@class AstroWarpDash: AstroDash
---@field dashEffect BEffect
local AstroWarpDash = {}
AstroWarpDash.Identifier = "astrowarpdash"
AstroWarpDash.Name = "AstroWarpDash"
AstroWarpDash.hooks = {}

---[SHARED] Hook after dash start
---@param astro AstroBase Astro this module pinned to
function AstroWarpDash:warpdashStart(astro) end

---[SHARED] Hook on dash end
---@param astro AstroBase Astro this module pinned to
---@param dir Vector Direction of dash before end
function AstroWarpDash:warpdashEnd(astro, dir) end

if SERVER then
    local world = game.getWorld()
    function AstroWarpDash:dashStart(astro)
        astro.ent:setCollisionGroup(COLLISION_GROUP.IN_VEHICLE)
        self:warpdashStart(astro)
    end

    function AstroWarpDash:dashThink(astro, dir)
        local cur = timer.curtime()
        local interval = game.getTickInterval()
        local remain = self.dashTime - (cur - self.dashStartTime)
        local remainVel = remain * 4000
        local pos = astro.ent:getPos()
        local toDamage = find.inSphere(pos, 128)
        for _, v in ipairs(toDamage) do
            if !isValid(v) or v == world then goto cont end
            if !table.hasValue(astro.filter, v) then
                astroutils.applyDamage(v, 25, astro.ent, self.ent)
            end
            ::cont::
        end
        local endPos = pos + dir * remainVel
        local tr = trace.line(pos, endPos, astro.filter, MASK_SOLID)
        local cantDash = false
        if tr.Hit then
            local canPos = tr.HitPos + dir * (math.min((interval * 4000) + 1024, remainVel))
            cantDash = !canPos:isInWorld()
        end
        return cantDash
    end

    function AstroWarpDash:dashEnd(astro, dir)
        astro.ent:setCollisionGroup(COLLISION_GROUP.NONE)
        self:warpdashEnd(astro, dir)
    end
else
    function AstroWarpDash:dashStart(astro)
        self:warpdashStart(astro)
        local eff = beff.create("plasma_exhaust")
        eff:setEntity(self.ent)
        eff:play()
        self.dashEffect = eff
        local dir = self:getDirection()
        if !dir then return end
        local eff = beff.create("quantum_burst")
        eff:setOrigin(self.ent:getPos())
        eff:setNormal(dir)
        eff:setScale(3)
        eff:play()
    end

    function AstroWarpDash:dashEnd(astro, dir)
        self:warpdashEnd(astro, dir)
        if !self.dashEffect then return end
        self.dashEffect:destroy()
        local eff = beff.create("quantum_burst")
        eff:setOrigin(self.ent:getPos())
        eff:setNormal(dir)
        eff:setScale(3)
        eff:play()
    end
end


---[SHARED] Get direction of dash
---@return Vector?
function AstroWarpDash:getDirection()
    return self:getNWVar("dashDirection")
end

ents.register(AstroWarpDash, "astrodash")
