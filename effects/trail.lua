
---@class beff
local beff = beff

---@class Trail: BEffect
---@field emmiter ParticleEmitter Emmiter
---@field nextParticle number Next particle to spawn. Relative to CurTime
local Trail = {}
Trail.Identifier = "trail"

if CLIENT then
    local Ply = player()
    local randVector = function() return Vector(math.rand(-1, 1), math.rand(-1, 1), math.rand(-1, 1)) end
    local fires = {
        material.load("effects/yellowflare"),
        material.load("effects/fluttercore_gmod"),
        material.load("effects/ar2_altfire1b"),
    }
    local emm = particle.create(Vector(), false)

    function Trail:init()
        self.ent = self:getEntity()
        self.origin = self:getOrigin()
        self.lastPos = self.ent:localToWorld(self.origin)
    end

    function Trail:render()
        local pos = self.ent:localToWorld(self.origin)
        local diff = (pos - self.lastPos)
        local frac = diff / 8
        for i=1, 8 do
            local startSize = math.random(20, 34)
            local part = emm:add(
                fires[math.random(1, #fires)],
                pos + frac * -i + randVector() * 5,
                startSize, 0,
                0, 0,
                255, 0,
                1
            )
            if !part then return end
            part:setGravity(Vector(0, 0, -0.01))
            part:setAirResistance(10)
            local col = math.rand(30, 70)
            part:setColor(Color(255, col, col))
            part:setRollDelta(math.rand(3, 5))
            part:setVelocity(randVector() * 50 + diff)
        end
        self.lastPos = pos
    end

    -- local laser = material.load("trails/laser")
    -- local emm = particle.create(Vector(), true)
    -- function Trail:init()
    --     self.ent = self:getEntity()
    --     self.origin = self:getOrigin()
    --     self.lastPos = self.ent:localToWorld(self.origin)
    -- end
    --
    -- function Trail:render()
    --     local pos = self.ent:localToWorld(self.origin)
    --     local ang = (self.lastPos - pos):getAngle() + Angle(90, 0, 90)
    --     local dist = pos:getDistance(self.lastPos)
    --     local part = emm:add(laser, self.lastPos - ang:getForward() * dist / 2, dist / 2, dist / 2, 0, 0, 255, 255, 1)
    --     if !part then return end
    --     part:setAngles(ang)
    --     self.lastPos = pos
    -- end
end


beff.register(Trail)
