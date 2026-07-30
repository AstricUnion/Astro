if CLIENT then
    local sounds = "https://raw.githubusercontent.com/AstricUnion/Astro/refs/heads/astroscout/dev/sounds/astroscout/"
    astrosound.preloadURL("loop2", sounds .. "Idle.mp3")
    astrosound.preloadURL("punch", sounds .. "Punch.mp3")
    astrosound.preloadURL("swing", sounds .. "Claws.mp3")
    astrosound.preloadURL("startLaser", sounds .. "LaserStart.mp3")
    astrosound.preloadURL("stopLaser", sounds .. "LaserEnd.mp3")
    astrosound.preloadURL("laser", sounds .. "LaserShoot.mp3")
    astrosound.preloadURL("startBerserk", sounds .. "BerserkOn.mp3")
    astrosound.preloadURL("berserkLoop", sounds .. "BerserkLoop.mp3")
    astrosound.preloadURL("stopBerserk", sounds .. "BerserkOff.mp3")
    astrosound.preloadURL("dash", sounds .. "Dash.mp3")
end


---@enum SCOUTSTATE
local STATE = {
    Idle = 0,
    Block = 1,
    Punch = 2,
    Laser = 4,
    LaserOn = 8,
    Dashing = 16,
    Berserk = 32
}

---@class AstroScout: AstroBase
---@field laserEffect Laser [CLIENT] Effect for laser
---@field berserkEffect Berserk [CLIENT] Effect for Berserk
---@field laserStartSound Bass [CLIENT] Sound of laser start
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
AstroScout.Speed = 200
AstroScout.SprintSpeed = 600
---@type table<string, fun(self: AstroScout, cur: number): boolean?>
AstroScout.actions = {}


local world = game.getWorld()

function AstroScout.actions.punch(astro, cur)
    if CLIENT then
        astro.ent:setSequence("punch", 1)
        astrosound.play {"punch", nil, astro.ent, volume = 2}
    else
        astro:setState(bit.bor(astro:getState(), STATE.Punch))
        astro:setNextAction("punch", cur + 0.5)
        astro:setNextAction("swing", cur + 0.5)
        astro:setNextAction("block", cur + 0.5)
        timer.simple(0.2, function()
            local st = astro:getState()
            if !(isValid(astro) and bit.band(st, STATE.Punch) == STATE.Punch) then return end
            local isBerserk = bit.band(st, STATE.Berserk) == STATE.Berserk
            local radius = 160 * (isBerserk and 1.2 or 1)
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
                        astroutils.applyDamage(target, 350 * (isBerserk and 1.5 or 1), astro.ent, astro.ent)
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
        astrosound.play {"swing", nil, astro.ent}
    else
        astro:setState(bit.bor(astro:getState(), STATE.Punch))
        astro:setNextAction("swing", cur + 1)
        astro:setNextAction("punch", cur + 1)
        astro:setNextAction("block", cur + 1)
        astro:setNextAction("dash", cur + 1)
        timer.simple(0.5, function()
            local st = astro:getState()
            if !(isValid(astro) and bit.band(st, STATE.Punch) == STATE.Punch) then return end
            local isBerserk = bit.band(st, STATE.Berserk) == STATE.Berserk
            local radius = 160 * (isBerserk and 1.2 or 1)
            local pos = astro.ent:localToWorld(Vector(197, -21, 0))
            bdebug.sphere(pos, radius, 1, Color(255, 0, 0, 0))
            local targets = find.inSphere(pos, radius)
            local damage = 0
            for _, target in ipairs(targets) do
                if !isValid(target) or target == world then goto cont end
                if !table.hasValue(astro.filter, target) then
                    local dam = 600 * (isBerserk and 1.5 or 1)
                    damage = damage + math.min(target:getHealth(), dam)
                    astroutils.applyDamage(target, dam, astro.ent, astro.ent)
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
            astro:setState(bit.band(st, bit.bnot(STATE.Block)))
        end)
        return true
    end
end

function AstroScout.actions.startLaser(astro, cur)
    if CLIENT then
        astro.ent:setSequence("startLaser", 2)
        astrosound.play {"startLaser", nil, astro.ent, volume = 1.5, callback = function(snd)
            astro.laserStartSound = snd
        end}
        timer.simple(0.5, function()
            if !(isValid(astro) and bit.band(astro:getState(), STATE.Laser) == STATE.Laser) then return end
            astro.ent:setSequence("laser", 2)
            local eff = beff.create("laser")
            eff:setScale(1.8)
            eff:setEntity(astro.ent:getBoneEntity(astro.ent:lookupBone("left_forearm")))
            eff:setStart(Vector(0, 96, -2))
            eff:play()
            astro.laserEffect = eff
            astro:think()
        end)
    else
        astro:setNextAction("startLaser", cur + 0.5)
        astro:setNextAction("block", cur + 0.5)
        astro:setState(bit.bor(astro:getState(), STATE.Laser))
        timer.simple(0.5, function()
            local st = astro:getState()
            if !(isValid(astro) and bit.band(st, STATE.Laser) == STATE.Laser) then return end
            cur = cur + 0.5
            local remain = math.min(cur - astro:getLaserEndTime(), 6)
            astro:setNWVar("laserRemain", remain)
            astro:setNWVar("laserStartTime", cur)
            astro:setState(bit.bor(st, STATE.LaserOn))
        end)
        return true
    end
end

function AstroScout.actions.stopLaser(astro, cur)
    if CLIENT then
        astro.ent:setSequence("stopLaser", 2)
        if astro.laserEffect then
            astro.laserEffect:destroy()
            astro.laserEffect = nil
        end
        if isValid(astro.laserStartSound) then
            astro.laserStartSound:stop()
            astro.laserStartSound = nil
        end
        astrosound.play {"stopLaser", nil, astro.ent, volume = 1.5}
    else
        astro:setNextAction("block", cur + 0.5)
        local st = astro:getState()
        if bit.band(st, STATE.LaserOn) == STATE.LaserOn then
            astro:setNWVar("laserEndTime", cur - (astro:getLaserRemain() - (cur - astro:getLaserStartTime())))
        end
        astro:setState(bit.band(st, bit.bnot(STATE.Laser + STATE.LaserOn)))
        return true
    end
end

function AstroScout.actions.dash(astro, cur)
    if CLIENT then
        astro.ent:setSequence("swing", 1)
        astrosound.play {"dash", nil, astro.ent, volume = 1.5}
        timer.simple(0.4, function()
            if !(isValid(astro) and bit.band(astro:getState(), STATE.Dashing) == STATE.Dashing) then return end
            astro.ent:setSequence(0, 1)
        end)
    else
        local dir = astro:getDirection()
        if !dir then return end
        dir = !dir:isZero() and dir or astro.ent:getAngles():getForward()
        local pos = astro.ent:getPos()
        local interval = game.getTickInterval()
        local endPos = pos + dir * (interval * 16000)
        local canPos = trace.hull(pos, endPos, Vector(-40), Vector(40), astro.filter)
        if canPos.Hit then return end
        astro:setState(bit.bor(astro:getState(), STATE.Dashing))
        astro.dashStartTime = cur
        astro:setNWVar("dashDirection", dir)
        return true
    end
end

function AstroScout.actions.berserk(astro, cur)
    if CLIENT then
        astrosound.play {"startBerserk", nil, astro.ent, volume = 2}
        local eff = beff.create("berserk")
        eff:setEntity(astro.ent)
        eff:play()
        astro.berserkEffect = eff
    else
        if astro:getBerserkProgress() < 3200 then return end
        astro:setState(bit.bor(astro:getState(), STATE.Berserk))
        astro:setNWVar("berserkProgress", 0)
        astro:setNWVar("berserkStartTime", cur)
        astro.Speed = astro.Speed * 1.2
        astro.SprintSpeed = astro.SprintSpeed * 1.2
        return true
    end
end


function AstroScout:think()
    local st = self:getState()
    local cur = timer.curtime()
    local isBerserk = bit.band(st, STATE.Berserk) == STATE.Berserk
    if isBerserk and cur - self:getBerserkStartTime() > 12 then
        st = bit.band(st, bit.bnot(STATE.Berserk))
        isBerserk = false
        if SERVER then
            self:setState(st)
            self:setNWVar("laserStartTime", cur)
            self:setNWVar("laserEndTime", 0)
            self.Speed = self.Speed / 1.2
            self.SprintSpeed = self.SprintSpeed / 1.2
        else
            if self.berserkEffect then
                self.berserkEffect:destroy()
                self.berserkEffect = nil
            end
            astrosound.play {"stopBerserk", nil, self.ent, volume = 2}
        end
    end
    local band = bit.band(st, STATE.Laser + STATE.Dashing)
    local byStates = {
        [STATE.Laser] = function()
            local eyeAng = self:getEyeAngles()
            if !eyeAng then return end
            local pos = self.ent:getPos()
            local tr = trace.hull(pos, pos + eyeAng:getForward() * 32768, Vector(-16), Vector(16), self.filter)
            if CLIENT then
                local module = self.ent:getBoneEntity(self.ent:lookupBone("left_shoulder"))
                local ang = (tr.HitPos - module:getPos()):getAngle()
                ang = ang:rotateAroundAxis(ang:getUp(), -90)
                self.ent:setPoseParameter("laser_rotation_p", ang.p)
                self.ent:setPoseParameter("laser_rotation_y", ang.y)
                self.ent:setPoseParameter("laser_rotation_r", ang.r)
                if self.laserEffect then
                    self.laserEffect:setOrigin(tr.HitPos)
                end
            else
                if bit.band(st, STATE.LaserOn) ~= STATE.LaserOn then return end
                local toDamage = find.inSphere(tr.HitPos, 48)
                for _, v in ipairs(toDamage) do
                    if !isValid(v) or v == world then goto cont end
                    if !table.hasValue(self.filter, v) then
                        astroutils.applyDamage(v, 20, self.ent, self.ent)
                    end
                    ::cont::
                end
                if !isBerserk then
                    local fromStart = timer.curtime() - self:getLaserStartTime()
                    if fromStart > self:getLaserRemain() then
                        self:sendAction("stopLaser")
                    end
                end
            end
        end,
        [STATE.Dashing] = function()
            local dir = self:getDashDirection()
            if dir then
                if SERVER then
                    self:setVelocity(dir * 4000)
                    local pos = self.ent:getPos()
                    local remain = 1.8 - (cur - self.dashStartTime)
                    local interval = game.getTickInterval()
                    local endPos = pos + dir * (interval * 16000)
                    local canPos = trace.hull(pos, endPos, Vector(-40), Vector(40), self.filter)
                    if remain <= 0 or canPos.Hit then
                        self:setVelocity(dir)
                        self:setNextAction("dash", cur + 3)
                        self:setNextAction("block", cur + 0.5)
                        self:setNextAction("punch", cur + 0.5)
                        self:setNextAction("swing", cur + 0.5)
                        self:setNWVar("dashDirection", nil)
                        astrosound.play {"swing", nil, self.ent, time = 0.3}
                        self.ent:setSequence("swing", 1, 0.4)
                        local radius = 160 * (isBerserk and 1.2 or 1)
                        local hitPos = self.ent:localToWorld(Vector(197, -21, 0))
                        bdebug.sphere(hitPos, radius, 1, Color(255, 0, 0, 0))
                        local targets = find.inSphere(hitPos, radius)
                        for _, target in ipairs(targets) do
                            if !isValid(target) or target == world then goto cont end
                            if !table.hasValue(self.filter, target) then
                                astroutils.applyDamage(target, 1200 * (isBerserk and 1.5 or 1), self.ent, self.ent)
                            end
                            ::cont::
                        end
                        self:setState(bit.band(st, bit.bnot(STATE.Dashing)))
                    end
                end
            end
        end
    }
    local fun = byStates[band]
    if fun then fun() end
end

if SERVER then
    function AstroScout:astroInitialize()
        self:setState(STATE.Idle)
        self:setNWVar("berserkProgress", 3200)
    end

    local canAct = {
        ["punch"] = {bit.bor, STATE.Idle + STATE.Laser + STATE.LaserOn + STATE.Berserk},
        ["swing"] = {bit.bor, STATE.Idle + STATE.Laser + STATE.LaserOn + STATE.Berserk},
        ["block"] = {bit.bor, STATE.Idle + STATE.Berserk},
        ["unblock"] = {bit.band, STATE.Block},
        ["startLaser"] = {bit.bor, STATE.Idle + STATE.Punch + STATE.Berserk},
        ["stopLaser"] = {bit.band, STATE.Laser},
        ["dash"] = {bit.bor, STATE.Idle + STATE.Berserk},
        ["berserk"] = {bit.band, STATE.Idle}
    }

    local pressToAct = {
        [MOUSE.MOUSE1] = "punch",
        [MOUSE.MOUSE2] = "swing",
        [MOUSE.MIDDLE] = "block",
        [KEY.R] = "startLaser",
        [KEY.G] = "dash",
        [KEY.F] = "berserk",
    }

    local releaseToAct = {
        [MOUSE.MIDDLE] = "unblock",
        [KEY.R] = "stopLaser",
    }

    function AstroScout:isCanAction(action)
        local st = self:getState()
        local states = canAct[action]
        return states[1](st, states[2]) == states[2]
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
        local multiplier = 1
        local st = self:getState()
        if bit.band(st, STATE.Block) == STATE.Block then
            self:setHealth(self:getHealth() + amount * 0.4)
            multiplier = 1.2
        end
        if bit.band(st, STATE.Berserk) ~= STATE.Berserk then
            self:setNWVar("berserkProgress", self:getBerserkProgress() + amount * multiplier)
        end
    end
else
    local l1 = light.create(Vector(), 80, 10, Color(255, 0, 0))

    function AstroScout:astroInitialize()
        self.ent:setSequence("idle")
        astrosound.play {"loop2", nil, self.ent, looping = true, volume = 0.8}
    end

    function AstroScout.hooks:AstroSoundPreloaded(identifier)
        if identifier == "loop2" then
            astrosound.play {identifier, nil, self.ent, looping = true, volume = 0.8}
        end
    end

    function AstroScout:renderOffscreen()
        l1:setPos(self.ent:localToWorld(Vector(0, 0, 30)))
        l1:draw()
    end

    function AstroScout:onDrawHUD(sw, sh)
        local x, y = sw / 2, sh / 2
        local st = self:getState()
        local isBerserk = bit.band(st, STATE.Berserk) == STATE.Berserk
        local cur = timer.curtime()
        do
            local text = "LASER_1"
            local percent
            if isBerserk then
                percent = 1
            else
                local laserRemain
                if bit.band(self:getState(), STATE.LaserOn) == STATE.LaserOn then
                    laserRemain = self:getLaserRemain() - math.min(cur - self:getLaserStartTime(), 6)
                else
                    laserRemain = math.min(cur - self:getLaserEndTime(), 6)
                end
                percent = laserRemain / 6
            end
            local laserProgressPosition = x - 128
            astrogui.drawProgressBar(laserProgressPosition - 164 , y - 12, 164, 24, percent, text, isBerserk and "" or (math.floor(percent * 100) .. "%"))
            astrogui.control(laserProgressPosition + 16, y, "R")
        end

        do
            local dir = self:getDashDirection()
            local percent = !dir and (1 - (math.clamp(self:getNextAction("dash") - cur, 0, 3) / 3)) or 0
            astrogui.drawProgressBar(x - 85, y + 128, 170, 20, percent, "DASH_MOD", (math.ceil(percent * 100)) .. "%", true, true)
            astrogui.control(x + 101, y + 138, "G", percent < 1)
        end

        do
            local percent = math.clamp(isBerserk and (12 - (cur - self:getBerserkStartTime())) / 12 or self:getBerserkProgress() / 3200, 0, 1)
            astrogui.drawProgressBar(x - 85, y - 86, 170, 20, percent, "BERSERK_MOD", (math.ceil(percent * 100)) .. "%", false, true)
            astrogui.control(x + 101, y - 76, "F", isBerserk or percent < 1)
        end
    end
end

---[SHARED] Get direction of dash
---@return Vector?
function AstroScout:getDashDirection()
    return self:getNWVar("dashDirection")
end

---[SHARED] Get laser start time
---@return Vector?
function AstroScout:getLaserStartTime()
    return self:getNWVar("laserStartTime", 0)
end

---[SHARED] Get laser end time
---@return Vector?
function AstroScout:getLaserEndTime()
    return self:getNWVar("laserEndTime", 0)
end

---[SHARED] Get laser remain
---@return Vector?
function AstroScout:getLaserRemain()
    return self:getNWVar("laserRemain", 6)
end

---[SHARED] Get berserk mode progress
---@return number?
function AstroScout:getBerserkProgress()
    return self:getNWVar("berserkProgress", 0)
end

---[SHARED] Get berserk start time
---@return Vector?
function AstroScout:getBerserkStartTime()
    return self:getNWVar("berserkStartTime", 0)
end

ents.register(AstroScout, "astrobase")
