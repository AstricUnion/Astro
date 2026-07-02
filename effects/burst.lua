---@class beff
local beff = beff

---@class tween
local tween = tween
local param = tween.param
local property = tween.ParamProperties

---@class QuantumBurst: BEffect
local QuantumBurst = {}
QuantumBurst.Identifier = "quantum_burst"

if CLIENT then
    function QuantumBurst:init()
        local origin = self:getOrigin()
        local scale = self:getScale()
        local normal = self:getNormal()
        local holo = hologram.create(origin, normal:getAngle(), "models/holograms/hq_icosphere.mdl", Vector(scale))
        local holo2 = hologram.create(origin, normal:getAngle(), "models/props_combine/portalball.mdl", Vector(scale))
        if !(holo and holo2) then return end
        holo:suppressEngineLighting(true)
        tween.start(tween.new {
            param {0, 1, holo, property.SCALE, Vector(scale * 2), Vector(scale * 10), math.easeOutQuart},
            param {0, 1, holo, property.COLOR, Color(255, 0, 0), Color(255, 0, 0, 0), math.easeOutQuart},

            param {0, 2, holo2, property.SCALE, Vector(scale * 0.1), Vector(scale * 0.1, scale * 2, scale * 2), math.easeOutQuart},
            param {0, 2, holo2, property.COLOR, Color(255, 0, 0), Color(255, 0, 0, 0), math.easeOutQuart},

            function(process)
                if process >= 2 then
                    timer.simple(0, function()
                        holo:remove()
                        holo2:remove()
                    end)
                    return true
                end
            end
        })
    end
end

function QuantumBurst:think() return false end


beff.register(QuantumBurst)
