
---@class beff
local beff = beff

---@class Laser: BEffect
---@field emmiter ParticleEmitter Emmiter
---@field nextParticle number Next particle to spawn. Relative to CurTime
local Laser = {}
Laser.Identifier = "laser"

if CLIENT then
    local Ply = player()
    local randVector = function() return Vector(math.rand(-1, 1), math.rand(-1, 1), math.rand(-1, 1)) end
    local fire = material.load("particle/fire")
    local warp = material.load("particle/warp1_warp")
    -- local fire = {
    --     material.load("particle/fire"),
    --     material.load("particle/warp1_warp")
    -- }
    local emm = particle.create(Vector(), false)

    function Laser:init()
        self.emmiter = emm
        self.ent = self:getEntity()
        self.offset = self:getStart()
        self.scale = self:getScale()
        self.holo = hologram.create(Vector(), Angle(), "models/holograms/hq_cylinder.mdl")
        self.holo:suppressEngineLighting(true)
        self.holo:setClip(0, true, Vector(), Vector(0, 0, -1), self.holo)
        self.laserEffect = hologram.create(Vector(), Angle(), "models/holograms/hq_cylinder.mdl")
        self.laserEffect:setParent(self.holo)
        self.laserEffect:suppressEngineLighting(true)
        self.laserEffect:setMaterial("cable/redlaser")
        self.laserEffect:setClip(0, true, Vector(), Vector(0, 0, -1), self.laserEffect)
        self.lightEffect = hologram.create(Vector(), Angle(), "models/effects/vol_light64x128.mdl", Vector(self.scale / 2.2, self.scale / 2.2, self.scale / 2.5))
        self.lightEffect:setParent(self.holo)
        self.lightEffect:setColor(Color(255, 0, 0, 60))
        self.lightEffect2 = hologram.create(Vector(), Angle(), "models/holograms/plane.mdl")
        self.lightEffect2:setParent(self.holo)
        self.lightEffect2:setMaterial("cable/redlaser")
        self.lightEffect2:setClip(0, true, Vector(), Vector(0, 0, -1), self.holo)
        self.lightEffect2:setColor(Color(255, 0, 0))
        self.impact = hologram.create(Vector(), Angle(), "models/holograms/hq_sphere.mdl")
        self.impact:suppressEngineLighting(true)
        self.impactLaserEffect = hologram.create(Vector(), Angle(), "models/holograms/hq_sphere.mdl")
        self.impactLaserEffect:suppressEngineLighting(true)
        self.impactLaserEffect:setMaterial("models/effects/vortshield")
        self.impactLaserEffect:setColor(Color(255, 50, 50))
        self.nextParticle = 0
    end

    function Laser:render()
        local start = self.ent:localToWorld(self.offset)
        local origin = self:getOrigin() + randVector() * 2
        local scale = self:getScale()
        local size = start:getDistance(origin)
        local ang = (origin - start):getAngle()
        local newAng = ang:rotateAroundAxis(ang:getRight(), 90)
        if game.getTickCount() % 5 == 0 and trace.canCreateDecal() then
            trace.decal("Dark", origin, origin + ang:getForward())
        end
        self.holo:setAngles(newAng)
        self.holo:setPos(start)
        self.holo:setSize(Vector(12 * scale, 12 * scale, size * 2))

        self.impact:setPos(origin)
        self.impact:setSize(Vector(20 * scale, 20 * scale, 48 * scale))
        self.impact:setAngles(newAng)

        self.impactLaserEffect:setPos(origin)
        self.impactLaserEffect:setSize(Vector(32 * scale, 32 * scale, 56 * scale))
        self.impactLaserEffect:setAngles(newAng:rotateAroundAxis(ang:getUp(), 180))

        ---@type ViewSetup
        local vs = render.getViewSetup(true)
        local laserEffAngle = self.holo:worldToLocalAngles((vs.origin - start):getAngle())
        self.laserEffect:setSize(Vector(16 * scale, 16 * scale, size * 2))
        self.laserEffect:setAngles(self.holo:localToWorldAngles(Angle(0, laserEffAngle.y + 90, 0)))

        self.lightEffect2:setSize(Vector(size * 2, 48 * scale, 48 * scale))
        self.lightEffect2:setAngles(self.holo:localToWorldAngles(Angle(90, laserEffAngle.y + 90, 90)))

        local cur = timer.curtime()
        if self.nextParticle > cur then return end
        if emm:getParticlesLeft() < 1 then return end
        do
            local startSize = math.random(10, 14)
            local part = emm:add(
                fire,
                origin,
                startSize, 0,
                0, 0,
                255, 0,
                1
            )
            if !part then return end
            part:setVelocity(randVector() * 50 * scale)
            part:setAirResistance(10)
            part:setRoll(math.rand(-3, 3))
            part:setGravity(Vector(0, 0, -0.01))
            part:setColor(Color(255, 50, 50))
            part:setCollide(true)
            part:setBounce(math.rand(0, 0.5))
        end
        do
            local startSize = math.random(20, 24) * scale
            local part = emm:add(
                warp,
                origin + randVector() * 6 * scale,
                startSize, startSize + 20,
                0, 0,
                255, 0,
                0.2
            )
            if !part then return end
            part:setVelocity(randVector() * 100 * scale)
            part:setAirResistance(10)
            part:setRoll(math.rand(-3, 3))
            part:setGravity(Vector(0, 0, -0.01))
            part:setCollide(true)
            part:setBounce(math.rand(0, 0.5))
        end
        self.nextParticle = cur + 0.02
    end

    function Laser:onDestroy()
        if isValid(self.holo) then self.holo:remove() end
        if isValid(self.laserEffect) then self.laserEffect:remove() end
        if isValid(self.lightEffect) then self.lightEffect:remove() end
        if isValid(self.lightEffect2) then self.lightEffect2:remove() end
        if isValid(self.impact) then self.impact:remove() end
        if isValid(self.impactLight) then self.impactLight:remove() end
        if isValid(self.impactLaserEffect) then self.impactLaserEffect:remove() end
    end
end


beff.register(Laser)
