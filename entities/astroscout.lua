-- if CLIENT then
    -- local sounds = "https://raw.githubusercontent.com/AstricUnion/Astro/refs/heads/main/sounds/astroscout/"
    -- astrosound.preloadURL("loop", sounds .. "Idle.mp")
-- end


---@enum SCOUTSTATE
local STATE = {
    Idle = 0,
    Dashing = 1
}

---@class AstroScout: AstroBase
local AstroScout = {}
AstroScout.Identifier = "astroscout"
AstroScout.Name = "AstroScout"
AstroScout.Model = function()
    local mdl = model.create("astroscout")
    return mdl
end
AstroScout.hooks = {}
AstroScout.CameraOffset = Vector(19, 0, -14)
---@type AstroModuleCfg[]
AstroScout.Modules = {
    {offset = Vector(-3, -85, 26), module = "astroscout_rightarm"},
    {offset = Vector(-3, 85, 26), module = "astroscout_leftarm"}
}
AstroScout.SeatOffset = Vector(85, 0, 0)
AstroScout.SeatVisible = true

if SERVER then
    function AstroScout:astroInitialize()
        self:setState(STATE.Idle)
    end

    function AstroScout:inputPressed(button)
        if button == MOUSE.MOUSE1 then
            self.ent:setSequence(self.ent:lookupSequence("attack1"))
            self.modules[1]:sendAction("attack")
        end
    end

    function AstroScout:fly(dr)
    end

    function AstroScout:think()
    end

    function AstroScout:onDeath()
    end

    function AstroScout:onModuleDeath(mod)
    end
else
    function AstroScout:astroInitialize()
        self.ent:setSequence(1)
        -- timer.simple(3, function()
            -- self.ent:setSequence(1)
        --     local mod = self.modules[2]
        --     mod.ent:setSequence(2)
        --     timer.simple(1, function()
        --         self.ent:setSequence(2)
        --         mod.ent:setSequence(3)
        --     end)
        -- end)
    end
    -- local l1 = light.create(Vector(), 80, 10, Color(255, 0, 0))
    -- local l2 = light.create(Vector(), 80, 10, Color(255, 0, 0))

    -- function AstroScout:astroInitialize()
    --     astrosound.play {"loop", nil, self.ent, looping = true}
    -- end

    -- function AstroScout.hooks:AstroSoundPreloaded(identifier)
    --     if identifier == "loop" then astrosound.play {identifier, nil, self.ent, looping = true} end
    -- end

    -- function AstroScout:renderOffscreen()
    --     if !self:getDriver() then return end
    --     l1:setPos(self.ent:localToWorld(Vector(0, 0, 20)))
    --     l2:setPos(self.ent:localToWorld(Vector(0, 0, -10)))
    --     l1:draw()
    --     l2:draw()
    -- end
end

ents.register(AstroScout, "astrobase")
