---@class beff
local beff = beff

---@class BlasterMuzzle: BEffect
---@field warpParticle Particle
---@field lightParticle Particle
---@field endAt number
local BlasterMuzzle = {}
BlasterMuzzle.Identifier = "blaster_muzzle"

if CLIENT then
    local warp = material.load("particle/warp1_warp")
    local light = material.load("sprites/glow04_noz_gmod")
    function BlasterMuzzle:init()
        local emm = particle.create(Vector(), false)
        if emm:getParticlesLeft() <= 1 then return end
        local origin = self:getOrigin()
        local ent = self:getEntity()
        if isValid(ent) then origin = ent:localToWorld(origin) end
        -- local scale = self:getScale()
        local warpParticle = emm:add(
            warp, origin, 30, 0,
            0, 0, 255, 0, 1
        )
        local lightParticle = emm:add(
            light, origin, 30, 0,
            0, 0, 255, 0, 0.5
        )
        if warpParticle and lightParticle then
            warpParticle:setGravity(Vector(0, 0, -0.01))
            lightParticle:setGravity(Vector(0, 0, -0.01))
            lightParticle:setColor(Color(255, 0, 0))
            lightParticle:setLighting(false)
            self.warpParticle = warpParticle
            self.lightParticle = lightParticle
        end
        self.endAt = timer.curtime() + 1.2
    end

    function BlasterMuzzle:think()
        if !(self.warpParticle and self.lightParticle) then return false end
        if timer.curtime() >= self.endAt then return false end
        local origin = self:getOrigin()
        local ent = self:getEntity()
        if isValid(ent) then origin = ent:localToWorld(origin) end
        self.warpParticle:setPos(origin)
        self.lightParticle:setPos(origin)
    end
end



beff.register(BlasterMuzzle)
