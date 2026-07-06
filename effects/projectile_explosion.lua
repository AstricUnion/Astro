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
    local warp = material.load("particle/warp1_warp")
    local fire = {
        material.load("sprites/glow04_noz_gmod"),
        material.load("sprites/physg_glow1")
    }
    local randVector = function() return Vector(math.rand(-1, 1), math.rand(-1, 1), math.rand(-1, 1)) end
    function ProjectileExplosion:init()
        local origin = self:getOrigin()
        local scale = self:getScale()
        local emm = particle.create(Vector(), false)
        local normal = self:getNormal()
        local holo = hologram.create(origin, Angle(), "models/holograms/hq_icosphere.mdl", Vector(scale))
        if !holo then return end
        holo:emitSound("npc/vort/vort_explode1.wav", 75, 150, 1.5)
        holo:suppressEngineLighting(true)
        for i=1, 8 do
            local size = math.rand(100, 120) * scale
            local particle = emm:add(
                warp, origin, size, 0,
                0, 0, 200, 0, 1
            )
            if particle then
                particle:setGravity(Vector(0, 0, 5))
                particle:setLighting(false)
                particle:setVelocity(randVector() * 200 * scale)
                particle:setAirResistance(50)
                particle:setColor(Color(255, 200, 200))
                particle:setCollide(false)
                particle:setRollDelta(10)
            end
        end
        -- Fires particles
        for _=1, 20 do
            if emm:getParticlesLeft() < 1 then return end
            local startSize = math.random(10, 14) * scale
            local part = emm:add(
                fire[math.random(1, #fire)],
                origin + randVector() * 30,
                startSize, 0,
                startSize, 0,
                255, 0,
                math.random(1, 3)
            )
            if !part then return end
            part:setVelocity(normal * math.random(10, 150) + randVector() * math.random(400, 500) * scale)
            part:setAirResistance(10)
            part:setRoll(math.rand(-3, 3))
            part:setGravity(Vector(0, 0, -0.01))
            part:setColor(Color(255, 50, 50))
            part:setCollide(true)
            part:setBounce(math.rand(0, 0.5))
        end
        tween.start(tween.new {
            param {0, 1, holo, property.SCALE, Vector(scale, scale, scale), Vector(scale * 18, scale * 18, scale * 18), math.easeOutQuart},
            param {0, 1, holo, property.COLOR, Color(200, 0, 0), Color(200, 0, 0, 0), math.easeOutQuart},
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
