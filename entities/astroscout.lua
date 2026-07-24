-- if CLIENT then
    -- local sounds = "https://raw.githubusercontent.com/AstricUnion/Astro/refs/heads/main/sounds/astroscout/"
    -- astrosound.preloadURL("loop", sounds .. "Idle.mp")
-- end


---@enum SCOUTSTATE
local STATE = {
    Idle = 0,
    Block = 1,
    Punch = 2,
    Laser = 4,
    Dashing = 8
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
AstroScout.Modules = {}
AstroScout.SeatOffset = Vector(85, 0, 0)
AstroScout.SeatVisible = true
AstroScout.Health = 6500
---@type table<string, fun(self: AstroScout, cur: number): boolean?>
AstroScout.actions = {}


local world = game.getWorld()

function AstroScout.actions.punch(astro, cur)
    if CLIENT then
        astro.ent:setSequence("punch", 1)
    else
        astro:setState(bit.bor(astro:getState(), STATE.Punch))
        astro:setNextAction("punch", cur + 0.5)
        astro:setNextAction("swing", cur + 0.5)
        astro:setNextAction("block", cur + 0.5)
        timer.simple(0.2, function()
            local st = astro:getState()
            if !(isValid(astro) and bit.band(st, STATE.Punch) == STATE.Punch) then return end
            local radius = 160
            local spheres = {
                astro.ent:localToWorld(Vector(93, -53, 0)),
                astro.ent:localToWorld(Vector(183, -21, 0))
            }
            bdebug.sphere(spheres[1], radius, 1, Color(255, 0, 0, 0))
            bdebug.sphere(spheres[2], radius, 1, Color(255, 0, 0, 0))
            local found = {
                find.inSphere(spheres[1], radius),
                find.inSphere(spheres[2], radius)
            }
            local alreadyDamaged = {}
            for _, v in ipairs(found) do
                for _, target in ipairs(v) do
                    if !isValid(target) or alreadyDamaged[target] or target == world then goto cont end
                    if !table.hasValue(astro.filter, target) then
                        astroutils.applyDamage(target, 350, astro.ent, astro.ent)
                        alreadyDamaged[target] = true
                    end
                    ::cont::
                end
            end
            astro:setState(st - STATE.Punch)
        end)
        return true
    end
end

function AstroScout.actions.swing(astro, cur)
    if CLIENT then
        astro.ent:setSequence("swing", 1)
    else
        astro:setState(bit.bor(astro:getState(), STATE.Punch))
        astro:setNextAction("swing", cur + 1)
        astro:setNextAction("punch", cur + 1)
        astro:setNextAction("block", cur + 1)
        timer.simple(0.5, function()
            local st = astro:getState()
            if !(isValid(astro) and bit.band(st, STATE.Punch) == STATE.Punch) then return end
            local radius = 160
            local pos = astro.ent:localToWorld(Vector(197, -21, 0))
            bdebug.sphere(pos, radius, 1, Color(255, 0, 0, 0))
            local targets = find.inSphere(pos, radius)
            local damage = 0
            for _, target in ipairs(targets) do
                if !isValid(target) or target == world then goto cont end
                if !table.hasValue(astro.filter, target) then
                    damage = damage + math.min(target:getHealth(), 600)
                    astroutils.applyDamage(target, 600, astro.ent, astro.ent)
                end
                ::cont::
            end
            astro:setHealth(math.min(astro:getHealth() + damage * 0.15, astro.Health))
            astro:setState(bit.band(st, bit.bnot(STATE.Punch)))
        end)
        return true
    end
end

function AstroScout.actions.block(astro, cur)
    if CLIENT then
        astro.ent:setSequence("block", 1)
    else
        astro:setNextAction("block", cur + 0.5)
        astro:setState(bit.bor(astro:getState(), STATE.Block))
        return true
    end
end

function AstroScout.actions.unblock(astro, cur)
    if CLIENT then
        astro.ent:setSequence("unblock", 1)
    else
        astro:setNextAction("unblock", cur + 0.5)
        timer.simple(0.5, function()
            local st = astro:getState()
            if !(isValid(astro) and bit.band(st, STATE.Block) == STATE.Block) then return end
            astro:setState(bit.band(astro:getState(), bit.bnot(STATE.Block)))
        end)
        return true
    end
end

function AstroScout.actions.startLaser(astro, cur)
    if CLIENT then
        astro.ent:setSequence("startLaser", 1)
        timer.simple(0.5, function()
            if !isValid(astro) or astro:getState() ~= astro.STATE.Laser then return end
            astro.ent:setSequence("laser", 2)
            astro.laserEffect = beff.create("laser")
            astro.laserEffect:setScale(1.8)
            astro.laserEffect:setEntity(astro.ent:getBoneEntity(astro.ent:lookupBone("forearm")))
            astro.laserEffect:setStart(Vector(0, 96, -2))
            astro.laserEffect:play()
            astro:renderOffscreen()
        end)
    else
        astro:setNextAction("startLaser", cur + 0.5)
        astro:setNextAction("block", cur + 0.5)
        astro:setState(astro.STATE.Laser)
    end
end

function AstroScout.actions.stopLaser(astro, cur)
    if CLIENT then
        astro.ent:setSequence(0, 2)
        astro.ent:setSequence("stopLaser", 1)
        if astro.laserEffect then
            astro.laserEffect:destroy()
            astro.laserEffect = nil
        end
    else
        astro:setNextAction("block", cur + 0.5)
        astro.ent:setLocalAngles(Angle())
        astro:setState(astro.STATE.Idle)
    end
end



if SERVER then
    function AstroScout:astroInitialize()
        self:setState(STATE.Idle)
    end

    local canAct = {
        ["punch"] = STATE.Idle + STATE.Laser,
        ["swing"] = STATE.Idle + STATE.Laser,
        ["block"] = STATE.Idle,
        ["unblock"] = STATE.Block,
        ["startLaser"] = STATE.Idle + STATE.Punch,
        ["stopLaser"] = STATE.Laser,
    }

    local pressToAct = {
        [MOUSE.MOUSE1] = "punch",
        [MOUSE.MOUSE2] = "swing",
        [MOUSE.MIDDLE] = "block",
        [KEY.R] = "startLaser",
        [KEY.G] = "dash",
    }

    local releaseToAct = {
        [MOUSE.MIDDLE] = "unblock",
        [KEY.R] = "stopLaser",
    }

    function AstroScout:isCanAction(action)
        local st = self:getState()
        local states = canAct[action]
        return bit.bor(st, states) == states
    end

    function AstroScout:inputPressed(button)
        local act = pressToAct[button]
        if act then
            self:sendAction(act)
        end
    end

    function AstroScout:inputReleased(button)
        local act = releaseToAct[button]
        if act then
            self:sendAction(act)
        end
    end

    function AstroScout:onDamage(_, _, amount)
        if bit.band(self:getState(), STATE.Block) == STATE.Block then
            self:setHealth(self:getHealth() + amount * 0.4)
        end
    end

    function AstroScout:think()
    end
else
    function AstroScout:astroInitialize()
        self.ent:setSequence("idle")
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
