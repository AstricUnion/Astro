
---@class beff
local beff = beff

---@class Laser: BEffect
---@field emmiter ParticleEmitter Emmiter
---@field nextParticle number Next particle to spawn. Relative to CurTime
local Laser = {}
Laser.Identifier = "laser"

if CLIENT then
    local randVector = function() return Vector(math.rand(-1, 1), math.rand(-1, 1), math.rand(-1, 1)) end
    local fire = material.load("particle/fire")
    local warp = material.load("particle/warp1_warp")
    -- local fire = {
    --     material.load("particle/fire"),
    --     material.load("particle/warp1_warp")
    -- }
    local emm = particle.create(Vector(), false)

    local zeroVector = Vector()
    local zeroAngle = Angle()

    function Laser:init()
        self.emmiter = emm
        local ent = self:getEntity()
        local offset = self:getStart()
        local scale = self:getScale()

        local holo = hologram.create(zeroVector, zeroAngle, "models/holograms/hq_cylinder.mdl")
        if !holo then return end
        holo:suppressEngineLighting(true)
        holo:setClip(0, true, zeroVector, Vector(0, 0, -1), holo)

        local laserEffect = hologram.create(zeroVector, zeroAngle, "models/holograms/hq_cylinder.mdl")
        if !laserEffect then return end
        laserEffect:setParent(holo)
        laserEffect:suppressEngineLighting(true)
        laserEffect:setMaterial("cable/redlaser")
        laserEffect:setClip(0, true, zeroVector, Vector(0, 0, -1), laserEffect)

        local lightEffect = hologram.create(zeroVector, zeroAngle, "models/effects/vol_light64x128.mdl", Vector(scale / 2.2, scale / 2.2, scale / 2.5))
        if !lightEffect then return end
        lightEffect:setParent(holo)
        lightEffect:setColor(Color(255, 0, 0, 60))

        local lightEffect2 = hologram.create(zeroVector, zeroAngle, "models/holograms/plane.mdl")
        if !lightEffect2 then return end
        lightEffect2:setParent(holo)
        lightEffect2:setMaterial("cable/redlaser")
        lightEffect2:setClip(0, true, zeroVector, Vector(0, 0, -1), holo)
        lightEffect2:setColor(Color(255, 0, 0))

        local impact = hologram.create(zeroVector, zeroAngle, "models/holograms/hq_sphere.mdl")
        if !impact then return end
        impact:suppressEngineLighting(true)

        local impactLaserEffect = hologram.create(zeroVector, zeroAngle, "models/holograms/hq_sphere.mdl")
        if !impactLaserEffect then return end
        impactLaserEffect:suppressEngineLighting(true)
        impactLaserEffect:setMaterial("models/effects/vortshield")
        impactLaserEffect:setColor(Color(255, 50, 50))

        astrosound.play {"laser", looping = true, callback = function(snd)
            self.sound = snd
        end}

        self.ent = ent
        self.offset = offset
        self.scale = scale
        self.holo = holo
        self.laserEffect = laserEffect
        self.lightEffect = lightEffect
        self.lightEffect2 = lightEffect2
        self.impact = impact
        self.impactLaserEffect = impactLaserEffect
        self.nextParticle = 0
        self.add = false
    end

    function Laser:think()
        if !isValid(self.ent) then return false end
    end

    function Laser:render()
        local ent = self.ent
        if !isValid(self.ent) then return false end
        local holo = self.holo
        local impact = self.impact
        local impactLaserEffect = self.impactLaserEffect
        local laserEffect = self.laserEffect
        local lightEffect2 = self.lightEffect2
        local snd = self.sound
        local start = ent:localToWorld(self.offset)
        local origin = self:getOrigin() + randVector() * 2
        local scale = self:getScale()
        local size = start:getDistance(origin)
        local ang = (origin - start):getAngle()
        local newAng = ang:rotateAroundAxis(ang:getRight(), 90)
        holo:setAngles(newAng)
        holo:setPos(start)
        holo:setSize(Vector(12 * scale, 12 * scale, size * 2))

        impact:setPos(origin)
        impact:setSize(Vector(20 * scale, 20 * scale, 48 * scale))
        impact:setAngles(newAng)

        impactLaserEffect:setPos(origin)
        impactLaserEffect:setSize(Vector(32 * scale, 32 * scale, 56 * scale))
        impactLaserEffect:setAngles(newAng:rotateAroundAxis(ang:getUp(), 180))

        ---@type ViewSetup
        local vs = render.getViewSetup(true)
        local laserEffAngle = holo:worldToLocalAngles((vs.origin - start):getAngle())
        laserEffect:setSize(Vector(16 * scale, 16 * scale, size * 2))
        laserEffect:setAngles(holo:localToWorldAngles(Angle(0, laserEffAngle.y + 90, 0)))

        lightEffect2:setSize(Vector(size * 2, 48 * scale, 48 * scale))
        lightEffect2:setAngles(holo:localToWorldAngles(Angle(90, laserEffAngle.y + 90, 90)))

        if snd then
            local localEyePos = holo:worldToLocal(vs.origin)
            local sndPos = holo:localToWorld(Vector(0, 0, math.clamp(localEyePos.z, -size, 0)))
            snd:setPos(sndPos)
        end

        local cur = timer.curtime()
        if self.nextParticle > cur then return end
        if emm:getParticlesLeft() < 1 then return end
        do
            local startSize = math.random(10, 14)
            local part = emm:add(fire, origin, startSize, 0, 0, 0, 255, 0, 1)
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
            local part = emm:add(warp, origin + randVector() * 6 * scale, startSize, startSize + 20, 0, 0, 255, 0, 0.2)
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
        if isValid(self.impactLaserEffect) then self.impactLaserEffect:remove() end
        if isValid(self.sound) then self.sound:stop() end
    end
end


beff.register(Laser)
