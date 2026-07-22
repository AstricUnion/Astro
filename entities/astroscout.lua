-- if CLIENT then
    -- local sounds = "https://raw.githubusercontent.com/AstricUnion/Astro/refs/heads/main/sounds/astroscout/"
    -- astrosound.preloadURL("loop", sounds .. "Idle.mp")
-- end


---@enum SCOUTSTATE
local STATE = {
    Idle = 0,
    Block = 1,
    Dashing = 2
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
AstroScout.Health = 6500

if SERVER then
    function AstroScout:astroInitialize()
        self:setState(STATE.Idle)
    end

    function AstroScout:inputPressed(button)
        if button == MOUSE.MOUSE1 then
            if self.modules[1]:sendAction("punch") then
                self.ent:setSequence("punch", 1)
            end
        elseif button == MOUSE.MOUSE2 then
            if self.modules[1]:sendAction("swing") then
                self.ent:setSequence("swing", 1)
            end
        elseif button == KEY.R then
            if self.modules[2]:sendAction("startLaser") then
                self.ent:setSequence("startLaser", 2)
                timer.simple(0.5, function()
                    if !isValid(self) or !self.modules[2].laserOn then return end
                    self.ent:setSequence("laser", 2)
                end)
            end
        elseif button == MOUSE.MIDDLE then
            if !(self.modules[1]:canAction("block") and self.modules[2]:canAction("block")) then return end
            self:setState(STATE.Block)
            self.ent:setSequence("block", 2)
            self.modules[1]:sendAction("block")
            self.modules[2]:sendAction("block")
        end
    end

    function AstroScout:inputReleased(button)
        if button == KEY.R then
            if self.modules[2]:sendAction("stopLaser") then
                self.ent:setSequence("stopLaser", 2)
                self.modules[2]:sendAction("stopLaser")
            end
        elseif button == MOUSE.MIDDLE then
            if !(self.modules[1]:canAction("unblock") and self.modules[2]:canAction("unblock")) then return end
            self:setState(STATE.Idle)
            self.ent:setSequence("unblock", 2)
            self.modules[1]:sendAction("unblock")
            self.modules[2]:sendAction("unblock")
        end
    end

    function AstroScout:onDamage(_, _, amount)
        if self:getState() == STATE.Block then
            self:setHealth(self:getHealth() + amount * 0.4)
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
