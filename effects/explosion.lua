---@class beff
local beff = beff

---@class tween
local tween = tween
local param = tween.param
local property = tween.ParamProperties

---@class ProjectileExplosion: BEffect
local ProjectileExplosion = {}
ProjectileExplosion.Identifier = "projectile_explosion"

if CLIENT then
    function ProjectileExplosion:init()
        local origin = self:getOrigin()
        local scale = self:getScale()
        -- local normal = self:getNormal()
        local holo = hologram.create(origin, Angle(), "models/holograms/hq_icosphere.mdl", Vector(scale))
        if !holo then return end
        holo:emitSound("npc/vort/vort_explode1.wav", 75, 150, 1.5)
        holo:suppressEngineLighting(true)
        tween.start(tween.new {
            param {0, 1, holo, property.SCALE, Vector(scale, scale, scale), Vector(scale * 18, scale * 18, scale * 18), math.easeOutQuart},
            param {0, 1, holo, property.COLOR, Color(255, 0, 0), Color(255, 0, 0, 0), math.easeOutQuart},
            function(process)
                if process >= 1 then
                    timer.simple(0, function()
                        holo:remove()
                    end)
                    return true
                end
            end
        })
    end
end

function ProjectileExplosion:think() return false end


beff.register(ProjectileExplosion)
