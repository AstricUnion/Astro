---@name Utilities
---@author AstricUnion
---@shared


---@class astroutils
local astroutils = {}


if SERVER then
    local turrets = {}

    ---[SERVER] Apply damage through turret
    ---@param ent Entity Entity to apply damage
    ---@param damage number Damage to apply
    function astroutils.applyDamage(ent, damage, attacker, inflictor, type)
        local permitted = hasPermission("entities.applyDamage", ent)
        if permitted then
            ent:applyDamage(damage, attacker, inflictor, type)
            return
        end
        if ent:getHealth() <= 0 then return end
        local turr = turrets[ent]
        local valid = isValid(turr)
        if valid and turr.damage ~= damage then
            if isValid(turr.holo) then turr.holo:remove() end
            turr:remove()
            valid = false
        end
        local holo
        if !valid then
            if !(prop.canSpawn() and hologram.canSpawn()) then return end
            local status
            status, turr = pcall(prop.createSent, Vector(), Angle(-90, 0, 0), "gmod_wire_turret", true, {
                damage = damage,
                delay = 0,
                sound = "",
                tracer = "",
                tracernum = 0
            })
            if !status then return end
            holo = hologram.create(Vector(), Angle(), "models/editor/axis_helper_thick.mdl")
            if !holo then return end
            turr:setParent(holo)
            holo:setNoDraw(true)
            holo:setAngles(Angle())
            turr:setNoDraw(true)
            turr:setCollisionGroup(COLLISION_GROUP.IN_VEHICLE)
            turr.holo = holo
            turr.damage = damage
            turrets[ent] = turr
        else
            holo = turr.holo
            holo:setParent(ent)
        end
        holo:setParent(ent)
        holo:setLocalPos(Vector())
        turr.toFire = true
        wire.triggerInput(turr, "Fire", 1)
    end

    hook.add("EntityFireBullets", "BModTurret", function(ent)
        for _, turr in pairs(turrets) do
            if turr == ent then
                wire.triggerInput(ent, "Fire", 0)
                turr.toFire = false
                return
            end
        end
    end)

    local lastDamage
    local lastRadius
    local explosive
    function astroutils.blastDamage(damageOrigin, damageRadius, damage)
        local permitted = hasPermission("game.blastDamage")
        if permitted then
            game.blastDamage(damageOrigin, damageRadius, damage)
            return
        end
        if !isValid(explosive) or damageRadius ~= lastRadius or damage ~= lastDamage then
            if isValid(explosive) then explosive:remove() end
            if !prop.canSpawn() then return end
            explosive = prop.createSent(Vector(), Angle(), "gmod_wire_explosive", true, {
                damage = damage,
                radius = damageRadius,
                invisibleatzero = true,
                coloreffect = false,
                Model = "models/hunter/plates/plate.mdl"
            })
            explosive:setCollisionGroup(COLLISION_GROUP.IN_VEHICLE)
            explosive:setColor(Color(0, 0, 0, 0))
            lastDamage = damage
            lastRadius = damageRadius
        end
        explosive:setPos(damageOrigin)
        wire.triggerInput(explosive, "Detonate", 1)
    end
end


return astroutils
