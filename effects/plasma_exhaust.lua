---@class beff
local beff = beff

---@class PlasmaExhaust: BEffect
---@field emmiter ParticleEmitter Emmiter
---@field nextParticle number Next particle to spawn. Relative to CurTime
local PlasmaExhaust = {}
PlasmaExhaust.Identifier = "plasma_exhaust"

if CLIENT then
    local randVector = function() return Vector(math.rand(-1, 1), math.rand(-1, 1), math.rand(-1, 1)) end
    local fire = {
        material.load("particle/fire"),
        material.load("particle/warp1_warp")
    }
    local emm = particle.create(Vector(), false)

    function PlasmaExhaust:init()
        self.emmiter = emm
        self.nextParticle = 0
    end

    function PlasmaExhaust:think()
        local cur = timer.curtime()
        if self.emmiter:getParticlesLeft() <= 1 or self.nextParticle >= cur then return end
        local entity = self:getEntity()
        local originStart = self:getOrigin() + randVector() * 50
        local origin = isValid(entity) and entity:localToWorld(originStart) or originStart
        local size = math.rand(80, 150)
        local particle = self.emmiter:add(
            fire[math.random(1, 2)], origin, size, 0,
            0, 0, 200, 0, 2
        )
        if particle then
            particle:setGravity(Vector(0, 0, -0.01))
            particle:setLighting(false)
            particle:setVelocity(randVector() * 200)
            particle:setAirResistance(50)
            local lumen = math.rand(30, 50)
            particle:setColor(Color(math.rand(230, 255), lumen, lumen))
            particle:setCollide(false)
            particle:setRollDelta(10)
            self.nextParticle = self.nextParticle + 0.01
        end
    end
end


beff.register(PlasmaExhaust)
