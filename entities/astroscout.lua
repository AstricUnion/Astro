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
    astrosound.preloadURL("dash2", sounds .. "Dash.mp3")
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
AstroScout.HeadOffset = Vector(0, 0, 68)
---@type AstroModuleCfg[]
AstroScout.Modules = { { module = "astrodash" } }
AstroScout.SeatOffset = Vector(85, 0, 0)
AstroScout.SeatVisible = true
AstroScout.Health = 6500
AstroScout.Speed = 200
AstroScout.SprintSpeed = 600
---@type table<string, fun(self: AstroScout, cur: number): boolean?>
AstroScout.actions = {}
AstroScout.Radius = 128


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
            local damage = 350 * (isBerserk and 1.5 or 1)
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
            local damage = 600 * (isBerserk and 1.5 or 1)
            astroutils.attack(
                astro.ent, astro.ent, damage,
                {{Vector(197, -21, 0), radius}},
                astro.filter, true,
                function(target)
                    astro:setHealth(math.min(astro:getHealth() + math.min(target:getHealth(), damage) * 0.15, astro.Health))
                end
            )
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
    if SERVER then
        astro.modules[1]:sendAction("dash")
    end
end


function AstroScout.actions.stopAddToDash(astro, cur)
    if SERVER then
        astro.modules[1]:sendAction("stopAddToDash")
    end
end


function AstroScout.actions.berserk(astro, cur)
    if CLIENT then
        astrosound.play {"startBerserk", nil, astro.ent, volume = 2}
        local eff = beff.create("berserk")
        eff:setEntity(astro.ent)
        eff:play()
        astro.berserkEffect = eff
        astrosound.play {"berserkLoop", nil, astro.ent, looping = true, volume = 2, callback = function(snd)
            if isValid(astro.loopSound) then astro.loopSound:stop() end
            astro.loopSound = snd
        end}
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
    if !self:isAlive() and SERVER then
        self.physobj:addVelocity(self.deathDirection * 10)
        local localAng = self.ent:worldToLocalAngles(self.deathDirection:getAngle())
        local deathAngle = Vector(10, 0, 0):getRotated(localAng)
        self.physobj:addAngleVelocity(deathAngle)
        return
    end
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
            astrosound.play {"loop2", nil, self.ent, looping = true, volume = 0.8, callback = function(snd)
                if isValid(self.loopSound) then self.loopSound:stop() end
                self.loopSound = snd
            end}
        end
    end
    if bit.band(st, STATE.Laser) == STATE.Laser then
        local eyeAng = self:getEyeAngles()
        local pos = self:getEyePos()
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
            astroutils.attack(self.ent, self.ent, 20, {{tr.HitPos, 48}}, self.filter)
            if !isBerserk then
                local fromStart = timer.curtime() - self:getLaserStartTime()
                if fromStart > self:getLaserRemain() then
                    self:sendAction("stopLaser")
                end
            end
        end
    end
end

local function dashStart(mod, astro)
    if CLIENT then
        astro.ent:setSequence("swing", 1)
        astrosound.play {"dash2", nil, astro.ent, volume = 1.5}
        local eff = beff.create("dashtrail")
        eff:setEntity(astro.ent)
        eff:play()
        astro.dashTrail = eff
        timer.simple(0.4, function()
            if !(isValid(astro) and bit.band(astro:getState(), STATE.Dashing) == STATE.Dashing) then return end
            astro.ent:setSequence(0, 1)
        end)
    else
        astro:setState(bit.bor(astro:getState(), STATE.Dashing))
        return true
    end
end

local function dashEnd(mod, astro)
    if CLIENT then
        if astro.dashTrail then astro.dashTrail:destroy() end
        return
    end
    local dir = mod:getDirection()
    if !dir then return end
    local cur = timer.curtime()
    local st = astro:getState()
    local isBerserk = bit.band(st, STATE.Berserk) == STATE.Berserk
    astro:setNextAction("block", cur + 0.5)
    astro:setNextAction("punch", cur + 0.5)
    astro:setNextAction("swing", cur + 0.5)
    astro:setVelocity(dir)
    astrosound.play {"swing", nil, astro.ent, time = 0.3}
    astro.ent:setSequence("swing", 1, 0.4)
    local radius = 160 * (isBerserk and 1.2 or 1)
    local damage = 1200 * (isBerserk and 1.5 or 1)
    astroutils.attack(astro.ent, astro.ent, damage, {{Vector(197, -21, 0), radius}}, astro.filter, true)
    astro:setState(bit.band(st, bit.bnot(STATE.Dashing)))
end

function AstroScout:astroModuleInitialize(mod)
    if mod.Identifier ~= "astrodash" then return end
    ---@cast mod AstroDash
    mod.AllowVarying = true
    mod.Radius = 160
    mod.Control = "G"
    mod.dashStart = dashStart
    mod.dashEnd = dashEnd
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
        ["dash"] = {bit.bor, STATE.Idle + STATE.Berserk + STATE.Dashing},
        ["stopAddToDash"] = {bit.bor, STATE.Idle + STATE.Dashing},
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
        [KEY.G] = "stopAddToDash",
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

        if button == KEY.B then
            self.ent:applyDamage(self.Health)
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
            self:setNWVar("berserkProgress", math.clamp(self:getBerserkProgress() + amount * multiplier, 0, 3200))
        end
    end

    function AstroScout:astroDeactivate(ply)
        self:sendAction("stopLaser")
    end

    local function createPart(name, ent, offset, angle, localDirection, force, torque, velocity)
        local pos, ang = localToWorld(offset, angle or Angle(), ent:getPos(), ent:getAngles())
        local part = model.create(name)
        if !part then return end
        part:setPos(pos)
        part:setAngles(ang)
        timer.simple(0, function()
            if !isValid(part) then return end
            local phys = part:getPhysicsObject()
            if !isValid(phys) then return end
            phys:addVelocity(velocity + beff.randVector(-force, force) + localDirection:getRotated(ang) * force)
            phys:applyTorque(beff.randVector(-torque, torque))
        end)
        return part
    end

    function AstroScout:onDeath()
        if self.dashTrail then self.dashTrail:destroy() end
        if self.berserkEffect then self.berserkEffect:destroy() end
        if self.laserEffect then self.laserEffect:destroy() end
        local dir = self:getDirection()
        self.deathDirection = dir and !dir:isZero() and dir or self.ent:getAngles():getForward()
        self.deathDirection:setZ(0)
        self.ent:setSequence("death")
        local seat = self:getSeat()
        if seat and isValid(seat) then
            self:seatToAstro()
            seat:ejectDriver()
            seat:setCollisionGroup(COLLISION_GROUP.IN_VEHICLE)
        end
        do
            local eff = beff.create("projectile_explosion")
            eff:setOrigin(self.ent:getPos())
            eff:setScale(3)
            eff:play()
        end
        do
            local eff = beff.create("hitsmoke")
            eff:setEntity(self.ent)
            eff:setFlags(1)
            eff:setScale(10)
            eff:play()
        end
        local leftForearm = createPart("astroscout_leftforearm", self.ent, Vector(-3, 85, 26), Angle(90, -90, 0), Vector(0, 2, 0), 500, 100, Vector())
        local rightForearm = createPart("astroscout_rightforearm", self.ent, Vector(-3, -85, 26), Angle(-90, 90, 0), Vector(0, -2, 0), 500, 100, Vector())
        timer.simple(0.1, function()
            if isValid(leftForearm) then
                local eff = beff.create("hitsmoke")
                eff:setEntity(leftForearm)
                eff:setFlags(1)
                eff:setOrigin(Vector(0, 85, 0))
                eff:setScale(6)
                eff:play()
            end

            if isValid(rightForearm) then
                local eff = beff.create("hitsmoke")
                eff:setEntity(rightForearm)
                eff:setFlags(1)
                eff:setOrigin(Vector(0, -85, 0))
                eff:setScale(6)
                eff:play()
            end
        end)
        -- astrosound.play {"death", nil, self.ent, fadeMin = 3000, fadeMax = 50000}
        self.ent:setCollisionGroup(COLLISION_GROUP.WORLD)
        ---@param col CollisionData
        self.ent:addCollisionListener(function(col)
            if !isValid(self) then return end
            local pos = self.ent:getPos()
            self:remove()
            self.ent:removeCollisionListener()
            astroutils.blastDamage(pos, 450, 60)
            do
                local eff = beff.create("projectile_explosion")
                eff:setOrigin(pos)
                eff:setScale(5)
                eff:play()
            end
            local body = createPart("astroscout_body", self.ent, Vector(), nil, Vector(), 100, 0, -col.OurOldVelocity)
            local head = createPart("astroscout_head", self.ent, Vector(0, 0, 68), nil, Vector(0, 0, -10), 200, 50, -col.OurOldVelocity)
            local leftShoulder = createPart("astroscout_leftshoulder", self.ent, Vector(), nil, Vector(0, 1, 0), 100, 100, Vector())
            local rightShoulder = createPart("astroscout_rightshoulder", self.ent, Vector(), nil, Vector(0, -1, 0), 100, 100, Vector())
            timer.simple(0.1, function()
                if isValid(body) then
                    local eff = beff.create("hitsmoke")
                    eff:setEntity(body)
                    eff:setFlags(1)
                    eff:setScale(10)
                    eff:play()
                end
                if isValid(head) then
                    local eff = beff.create("hitsmoke")
                    eff:setEntity(head)
                    eff:setFlags(1)
                    eff:setScale(5)
                    eff:play()
                end
                if isValid(leftShoulder) then
                    local eff = beff.create("hitsmoke")
                    eff:setEntity(leftShoulder)
                    eff:setFlags(1)
                    eff:setOrigin(Vector(-3, 100, 26))
                    eff:setScale(6)
                    eff:play()
                end
                if isValid(rightShoulder) then
                    local eff = beff.create("hitsmoke")
                    eff:setEntity(rightShoulder)
                    eff:setFlags(1)
                    eff:setOrigin(Vector(-3, -100, 26))
                    eff:setScale(6)
                    eff:play()
                end
            end)
        end)
        self.physobj:setAngleVelocity(Vector())
    end
else
    local l1 = light.create(Vector(), 80, 10, Color(255, 0, 0))

    function AstroScout:astroInitialize()
        self.ent:setSequence("idle")
        astrosound.play {"loop2", nil, self.ent, looping = true, volume = 0.8, callback = function(snd)
            self.loopSound = snd
        end}
    end

    function AstroScout.hooks:AstroSoundPreloaded(identifier)
        local isBerserk = bit.band(self:getState(), STATE.Berserk) == STATE.Berserk
        if (isBerserk and identifier == "berserkLoop") or (!isBerserk and identifier == "loop2") then
            astrosound.play {identifier, nil, self.ent, looping = true, volume = 0.8, callback = function(snd)
                self.loopSound = snd
            end}
        end
    end

    function AstroScout:renderOffscreen()
        l1:setPos(self.ent:localToWorld(Vector(0, 0, 30)))
        l1:draw()
    end

    local upGrad = material.load("vgui/gradient_up")
    local downGrad = material.load("vgui/gradient_down")
    local leftGrad = material.load("vgui/gradient-l")
    local rightGrad = material.load("vgui/gradient-r")
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
            self.modules[1]:drawHUD(x, y + 128)
        end

        do
            local percent = math.clamp(isBerserk and (12 - (cur - self:getBerserkStartTime())) / 12 or self:getBerserkProgress() / 3200, 0, 1)
            astrogui.drawProgressBar(x - 85, y - 86, 170, 20, percent, "BERSERK_MOD", (math.ceil(percent * 100)) .. "%", false, true)
            astrogui.control(x + 101, y - 76, "F", isBerserk or percent < 1)
            if isBerserk then
                render.setColor(Color(255, 20, 20, 150 - math.sin(game.getTickCount() / 36) * 80))
                local width, height = sw / 4, sh / 4
                render.setMaterial(downGrad)
                render.drawTexturedRect(0, 0, sw, height)
                render.setMaterial(upGrad)
                render.drawTexturedRect(0, sh - height, sw, height)
                render.setMaterial(leftGrad)
                render.drawTexturedRect(0, 0, width, sh)
                render.setMaterial(rightGrad)
                render.drawTexturedRect(sw - width, 0, width, sh)
                render.setMaterial()
            end
        end
    end
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
