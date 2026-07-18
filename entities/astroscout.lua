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
            if !self.modules[1]:canAction("punch") then return end
            self.ent:setSequence(self.ent:lookupSequence("punch"), 1)
            self.modules[1]:sendAction("punch")
        elseif button == MOUSE.MOUSE2 then
            if !self.modules[1]:canAction("swing") then return end
            self.ent:setSequence(self.ent:lookupSequence("swing"), 1)
            self.modules[1]:sendAction("swing")
        elseif button == KEY.R then
            if !self.modules[2]:canAction("startLaser") then return end
            self.ent:setSequence(self.ent:lookupSequence("startLaser"), 2)
            timer.simple(0.5, function()
                if !isValid(self) or !self.modules[2].laserOn then return end
                self.ent:setSequence(self.ent:lookupSequence("laser"), 2)
            end)
            self.modules[2]:sendAction("startLaser")
        end
    end

    function AstroScout:inputReleased(button)
        if button == KEY.R then
            if !self.modules[2]:canAction("stopLaser") then return end
            self.ent:setSequence(self.ent:lookupSequence("stopLaser"), 2)
            self.modules[2]:sendAction("stopLaser")
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
    end
    local l1 = light.create(Vector(), 80, 10, Color(255, 0, 0))

    -- function AstroScout:astroInitialize()
    --     astrosound.play {"loop", nil, self.ent, looping = true}
    -- end

    -- function AstroScout.hooks:AstroSoundPreloaded(identifier)
    --     if identifier == "loop" then astrosound.play {identifier, nil, self.ent, looping = true} end
    -- end

    function AstroScout:renderOffscreen()
        l1:setPos(self.ent:localToWorld(Vector(0, 0, 30)))
        l1:draw()
    end
end

ents.register(AstroScout, "astrobase")
