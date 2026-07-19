---@class beff
local beff = beff

---@class Trail: BEffect
local Trail = {}
Trail.Identifier = "quantum_burst"

if CLIENT then
    function Trail:init()
        local trailHolo = hologram.create(Vector(), Angle(), "models/hunter/plates/plate.mdl")
        if !trailHolo then return end
        self.ent = self:getEntity()
        local length = self:getScale() * 0.5
        trailHolo:setNoDraw(true)
        trailHolo:setTrails(54, 0, length, "trails/laser", Color(255, 0, 0))
        self.length = length
        self.trailHolo = trailHolo
    end

    function Trail:think()
        if !isValid(self.ent) then
            self.ent = nil
            local cur = timer.curtime()
            if !self.removeAt then
                self.removeAt = cur + self.length
            elseif self.removeAt > cur then
                return false
            end
            return
        end
        self.trailHolo:setPos(self.ent:getPos())
    end

    function Trail:onDestroy()
        if isValid(self.trailHolo) then self.trailHolo:remove() end
    end
end


beff.register(Trail)
