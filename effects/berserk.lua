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
        local ent = self:getEntity()
        local origin = ent:getPos()
        local emm = particle.create(Vector(), false)
        local holo = hologram.create(origin, Angle(), "models/holograms/hq_icosphere.mdl", Vector(3))
        if !holo then return end
        holo:setParent(ent)
        holo:suppressEngineLighting(true)
        for _=1, 20 do
            if emm:getParticlesLeft() < 1 then return end
            local startSize = math.random(30, 42)
            local part = emm:add(
                fire,
                origin + randVector() * 30,
                startSize, 0,
                startSize, 0,
                255, 0,
                math.random(1, 3)
            )
            if !part then return end
            part:setVelocity(randVector() * math.random(600, 900))
            part:setAirResistance(10)
            part:setGravity(Vector(0, 0, -0.01))
            part:setColor(Color(255, 50, 50))
            part:setCollide(true)
            part:setBounce(math.rand(0, 0.5))
        end
        tween.start(tween.new {
            param {0, 2, holo, property.SCALE, Vector(3), Vector(54), math.easeOutQuart},
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
        self.ent = ent
        self.emm = emm
        self.process = 0
    end

    local processAng = (math.pi / 64)
    function Berserk:think()
        local ent = self.ent
        local emm = self.emm
        for _=0, 3 do
            self.process = self.process + processAng
            if emm:getParticlesLeft() < 1 then return end
            local startSize = math.random(28, 30)
            local part = emm:add(
                fire,
                ent:localToWorld(Vector(math.sin(self.process), math.cos(self.process), 0.3) * 72),
                startSize, 0,
                0, 0,
                255, 0,
                1
            )
            if !part then return end
            part:setVelocity(Vector(0, 0, 70):getRotated(ent:getAngles()))
            part:setAirResistance(10)
            part:setGravity(Vector(0, 0, -0.01))
            part:setColor(Color(255, 50, 50))
        end
    end
end


beff.register(Berserk)
