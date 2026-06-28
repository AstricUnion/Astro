---@name Guns and effects
---@author AstricUnion

---@class Projectile
---@field ent Entity
---@field velocity Vector
---@field ignore Entity[]
---@field damage number
---@field radius number
---@field effect fun(pos: Vector)
---@field startedAt number
---@field timeout number

---@class guns
---@field projectiles Projectile[]
local guns = {}
guns.projectiles = {}


if SERVER then
    ---[SERVER] Create new projectile
    function guns.createProjectile(position, angle, mdl, ignore, damage, radius, startVelocity, timeout)
        startVelocity = startVelocity or 5000
        mdl = isstring(mdl) and hologram.create(Vector(), Angle(), mdl) or mdl()
        mdl:setPos(position)
        mdl:setAngles(angle)
        local data = {
            ent = mdl,
            velocity = angle:getForward() * startVelocity,
            ignore = ignore,
            damage = damage or 60,
            radius = radius or 80,
            timeout = timeout or 3,
            startedAt = timer.curtime()
        }
        mdl:setVelocity(data.velocity)
        guns.projectiles[#guns.projectiles+1] = data
    end

    hook.add("Think", "GunsProjectiles", function()
        local tick = game.getTickInterval()
        local cur = timer.curtime()
        for i, v in pairs(guns.projectiles) do
            local pos = v.ent:getPos()
            local trace_result = trace.line(pos, pos + v.velocity * tick, v.ignore, MASK.SHOT_HULL)
            if trace_result.Hit or cur - v.startedAt > v.timeout then
                v.ent:setPos(trace_result.HitPos)
                v.ent:setNoDraw(true)
                guns.projectiles[i] = nil
                if !trace_result.HitSky then
                    game.blastDamage(trace_result.HitPos, v.radius, v.damage)
                    timer.simple(5, function()
                        v.ent:remove()
                    end)
                    local eff = beff.create("projectile_explosion")
                    eff:setOrigin(pos)
                    eff:setNormal(v.velocity:getNormalized())
                    eff:setScale(1)
                    eff:play()
                end
            end
        end
    end)
end

return guns

