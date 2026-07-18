
---@class beff
local beff = beff

---@class Laser: BEffect
---@field emmiter ParticleEmitter Emmiter
---@field nextParticle number Next particle to spawn. Relative to CurTime
local Laser = {}
Laser.Identifier = "laser"

if CLIENT then
    -- local randVector = function() return Vector(math.rand(-1, 1), math.rand(-1, 1), math.rand(-1, 1)) end
    local fire = material.load("particle/fire")
    -- local fire = {
    --     material.load("particle/fire"),
    --     material.load("particle/warp1_warp")
    -- }
    local emm = particle.create(Vector(), false)

    function Laser:init()
        self.emmiter = emm
        self.holo = hologram.create(Vector(), Angle(), "models/holograms/hq_cylinder.mdl")
        self.holo:suppressEngineLighting(true)
        self.laserEffect = hologram.create(Vector(), Angle(), "models/holograms/hq_cylinder.mdl")
        self.laserEffect:setParent(self.holo)
        self.laserEffect:suppressEngineLighting(true)
        self.laserEffect:setMaterial("cable/redlaser")
        self.ent = self:getEntity()
        self.offset = self:getStart()
        self:render()
    end

    function Laser:render()
        local start = self.ent:localToWorld(self.offset)
        local origin = self:getOrigin()
        local scale = self:getScale()
        local size = start:getDistance(origin)
        local ang = (origin - start):getAngle()
        local newAng = ang:rotateAroundAxis(ang:getRight(), 90)
        self.holo:setAngles(newAng)
        local forward = ang:getForward()
        self.holo:setPos(start + (forward * size / 2))
        self.laserEffect:setSize(Vector(16 * scale, 16 * scale, size))
        self.holo:setSize(Vector(12 * scale, 12 * scale, size))
    end

    function Laser:onDestroy()
        if isValid(self.holo) then self.holo:remove() end
        if isValid(self.laserEffect) then self.laserEffect:remove() end
    end
end


beff.register(Laser)
