---@enum STRIKERSTATE
local STATE = {
    Idle = 0,
}

---@class AstroStriker: AstroBase
local AstroStriker = {}
AstroStriker.Identifier = "astrostriker"
AstroStriker.Name = "AstroStriker"
AstroStriker.Model = function()
    local mdl = model.create("astrostriker")
    return mdl
end
AstroStriker.hooks = {}
AstroStriker.CameraOffset = Vector(22, 0, -16)
AstroStriker.HeadOffset = Vector(0, 0, 55)
---@type AstroModuleCfg[]
AstroStriker.Modules = {}
AstroStriker.SeatOffset = Vector(95, 0, 0)
AstroStriker.SeatVisible = true
AstroStriker.Health = 4200
AstroStriker.Speed = 180
AstroStriker.SprintSpeed = 550
---@type table<string, fun(self: AstroStriker, cur: number): boolean?>
AstroStriker.actions = {}
AstroStriker.Radius = 86

function AstroStriker.actions.blade(astro)
    if CLIENT then
        astro.ent:setSequence("blade1", 1)
    else
        return true
    end
end


if SERVER then
    function AstroStriker:astroInitialize()
        self:setState(STATE.Idle)
    end

    local canAct = {
        ["blade"] = {bit.band, STATE.Idle},
    }

    local pressToAct = {
        [MOUSE.MOUSE1] = "blade",
    }

    local releaseToAct = {}

    function AstroStriker:isCanAction(action)
        local st = self:getState()
        local states = canAct[action]
        return states[1](st, states[2]) == states[2]
    end

    function AstroStriker:inputPressed(button)
        local act = pressToAct[button]
        if act then
            self:sendAction(act)
        end
    end

    function AstroStriker:inputReleased(button)
        local act = releaseToAct[button]
        if act then
            self:sendAction(act)
        end
    end
else
    local l1 = light.create(Vector(), 80, 10, Color(255, 0, 0))

    function AstroStriker:astroInitialize()
        self.ent:setSequence(2)
        -- self.ent:addGestureSequence(1)
        -- self.ent:addGestureSequence(3)
    end

    function AstroStriker:colorChanged(_, newColor)
        l1:setColor(newColor)
    end

    function AstroStriker:renderOffscreen()
        l1:setPos(self.ent:localToWorld(Vector(0, 0, 20)))
        l1:draw()
    end
end

ents.register(AstroStriker, "astrobase")

