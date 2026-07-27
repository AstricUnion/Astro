---@class beff
local beff = beff

---@class tween
local tween = tween
local param = tween.param
local property = tween.ParamProperties

---@class Berserk: BEffect
local Berserk = {}
Berserk.Identifier = "berserk"

if CLIENT then
    local fire = material.load("sprites/glow04_noz_gmod")
    local randVector = function() return Vector(math.rand(-1, 1), math.rand(-1, 1), math.rand(-1, 1)) end
    function Berserk:init()
        local origin = self:getOrigin()
        local scale = self:getScale()
        local emm = particle.create(Vector(), false)
        local holo = hologram.create(origin, Angle(), "models/holograms/hq_icosphere.mdl", Vector(scale))
        if !holo then return end
        holo:suppressEngineLighting(true)
        -- Fires particles
        for _=1, 20 do
            if emm:getParticlesLeft() < 1 then return end
            local startSize = math.random(10, 14) * scale
            local part = emm:add(
                fire,
                origin + randVector() * 30,
                startSize, 0,
                startSize, 0,
                255, 0,
                math.random(1, 3)
            )
            if !part then return end
            part:setVelocity(randVector() * math.random(200, 300) * scale)
            part:setAirResistance(10)
            part:setRoll(math.rand(-3, 3))
            part:setGravity(Vector(0, 0, -0.01))
            part:setColor(Color(255, 50, 50))
            part:setCollide(true)
            part:setBounce(math.rand(0, 0.5))
        end
        tween.start(tween.new {
            param {0, 2, holo, property.SCALE, Vector(scale), Vector(scale * 18), math.easeOutQuart},
            param {0, 2, holo, property.COLOR, Color(200, 0, 0), Color(200, 0, 0, 0), math.easeOutQuart},
            function(process)
                if process >= 2 then
                    timer.simple(0, function()
                        holo:remove()
                    end)
                    return true
                end
            end
        })
    end
end

function Berserk:think() return false end


beff.register(Berserk)
