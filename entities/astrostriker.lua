---@enum STRIKERSTATE
local STATE = {
    Idle = 0,
    Punch = 1,
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

function AstroStriker.actions.blade(astro, cur)
    if CLIENT then
        astro.ent:addGestureSequence("blade1")
    else
        astro:setState(bit.bor(astro:getState(), STATE.Punch))
        astro:setNextAction("punch", cur + 0.5)
        astro:setNextAction("swing", cur + 0.5)
        astro:setNextAction("block", cur + 0.5)
        timer.simple(0.2, function()
            local st = astro:getState()
            if !(isValid(astro) and bit.band(st, STATE.Punch) == STATE.Punch) then return end
            local radius = 160
            local damage = 350
            astroutils.attack(
                astro.ent, astro.ent, damage,
                {
                    {Vector(93, -53, 0), radius},
                    {Vector(183, -21, 0), radius}
                },
                astro.filter, true
            )
            astro:setState(bit.band(st, bit.bnot(STATE.Punch)))
        end)
        return true
    end
end

function AstroStriker.actions.startBlaster(astro, cur)
    if CLIENT then
        astro.ent:setSequence("startblaster")
        timer.simple(0.5, function()
            astro.ent:setSequence("shootblaster")
        end)
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
        ["startBlaster"] = {bit.band, STATE.Idle},
        ["stopBlaster"] = {bit.band, STATE.Idle},
    }

    local pressToAct = {
        [MOUSE.MOUSE2] = "blade",
        [MOUSE.MOUSE1] = "startBlaster",
    }

    local releaseToAct = {
        [MOUSE.MOUSE1] = "stopBlaster",
    }

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
        -- self.ent:setSequence(2)
        -- self.ent:addGestureSequence(1)
        -- self.ent:addGestureSequence(3)
        -- self.ent:manipulateBoneAngles(6, Angle(0, 90, 0))
        self.lastRenderPos = self.ent:getPos()
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

