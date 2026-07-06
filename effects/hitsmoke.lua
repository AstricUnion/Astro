---@class beff
local beff = beff

---@class HitSmoke: BEffect
---@field emmiter ParticleEmitter Emmiter
---@field nextParticle number Next particle to spawn. Relative to CurTime
---@field endAt number End this effect at
local HitSmoke = {}
HitSmoke.Identifier = "hitsmoke"

if CLIENT then
    local smokes = {
        material.load("particle/smokestack"),
        material.load("particles/smokey"),
        material.load("particle/particle_smokegrenade"),
    }
    local fires = {
        material.load("particles/flamelet1"),
        material.load("particles/flamelet2"),
        material.load("particles/flamelet3"),
        material.load("particles/flamelet4"),
        material.load("particles/flamelet5")
    }
    local emm = particle.create(Vector(), false)
    local randVector = function() return Vector(math.rand(-1, 1), math.rand(-1, 1), math.rand(-1, 1)) end

    function HitSmoke:init()
        self.emmiter = emm
        self.nextParticle = 0
        self.endAt = timer.curtime() + math.rand(8, 12)
    end

    function HitSmoke:think()
        local cur = timer.curtime()
        if cur > self.endAt then
            return false
        end
        if self.emmiter:getParticlesLeft() <= 1 or self.nextParticle >= cur then return end
        local ent = self:getEntity()
        if !ent then return false end
        local originStart = self:getOrigin()
        local origin = isValid(ent) and ent:localToWorld(originStart) or originStart
        local scale = self:getScale()
        local flags = self:getFlags()
        local sprite
        local len = #smokes
        local smIndex = math.random(1, len)
        sprite = smokes[smIndex]
        local size = math.rand(10, 20) * scale
        if flags == 1 then
            local particle = self.emmiter:add(
                fires[math.random(1, #fires)], origin + randVector() * scale, 5, size + 5,
                0, 0, 255, 0, 0.3
            )
            if particle then
                local vel = randVector() * 10 * scale * Vector(1, 1, 10)
                particle:setVelocity(vel:setZ(math.abs(vel.z)))
                particle:setLighting(true)
                particle:setCollide(true)
            end
        end
        local particle = self.emmiter:add(
            sprite, origin + randVector() * scale, 5, size + 5,
            0, 0, 255, 0, 1
        )
        if particle then
            particle:setGravity(Vector(0, 0, 200))
            particle:setVelocity(randVector() * 30 * scale)
            particle:setLighting(true)
            local darg = math.rand(50, 100)
            particle:setColor(Color(darg, darg, darg))
            particle:setCollide(true)
        end
    end
end


beff.register(HitSmoke)
