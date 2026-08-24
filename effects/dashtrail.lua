---@class beff
local beff = beff

---@class DashTrail: BEffect
local DashTrail = {}
DashTrail.Identifier = "dashtrail"

if CLIENT then
    local fire = material.load("sprites/glow04_noz_gmod")

    function DashTrail:init()
        self.ent = self:getEntity()
        self.emm = particle.create(Vector(), false)
    end

    function DashTrail:think()
        local ent = self.ent
        local emm = self.emm
        for _=0, 3 do
            if emm:getParticlesLeft() < 1 then return end
            local startSize = math.random(60, 68)
            local part = emm:add(
                fire, ent:localToWorld(Vector(0, math.random(-72, 72), 0)),
                startSize, 0, 0, 0, 255, 0, 1
            )
            if !part then return end
            part:setVelocity(Vector(0, 0, 70):getRotated(ent:getAngles()) + beff.randVector() * 50)
            part:setAirResistance(10)
            part:setGravity(Vector(0, 0, -0.01))
            part:setColor(Color(255, 50, 50))
        end
    end
end


beff.register(DashTrail)
