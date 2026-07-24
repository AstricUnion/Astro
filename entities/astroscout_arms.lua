local world = game.getWorld()

local function parentToBone(self)
    local astro = self:getAstro()
    if !astro then return end
    local offset = self:getOffset()
    local body = astro.bodyBone
    local modulePoint = self.moduleBone
    if !(body and modulePoint) then return end
    ---@cast body Hologram
    ---@cast modulePoint Hologram
    local pos, ang = localToWorld(offset, Angle(), body:getPos(), body:getAngles())
    modulePoint:setPos(pos)
    if self.Identifier == "astroscout_leftarm" then
        if self:getState() == self.STATE.Laser then
            modulePoint:setLocalAngles(Angle())
            return astro
        end
    end
    modulePoint:setAngles(ang)
    return astro
end

---@class AstroScoutLeftArm: AstroModuleBase
---@field laserEffect BEffect
local AstroScoutLeftArm = {}
AstroScoutLeftArm.Identifier = "astroscout_leftarm"
AstroScoutLeftArm.Name = "AstroScout left arm"
AstroScoutLeftArm.Model = function()
    local mdl = model.create("astroscout_leftarm")
    return mdl
end
AstroScoutLeftArm.Health = 1
AstroScoutLeftArm.hooks = {}

---@enum AstroScoutLeftArmState
AstroScoutLeftArm.STATE = {
    Idle = 0,
    Laser = 1,
    Block = 2
}

AstroScoutLeftArm.actions = {}

if SERVER then
    function AstroScoutLeftArm:moduleInitialize()
        self:setState(self.STATE.Idle)
    end

    function AstroScoutLeftArm:think()
        if self:getState() ~= self.STATE.Laser then return end
        local astro = self:getAstro()
        if !astro then return end
        local tr = astro:getEyeTrace()
        if !tr then return end
        local pos = self.ent:getPos()
        self.ent:setAngles((tr.HitPos - pos):getAngle())
        local toDamage = find.inSphere(tr.HitPos, 24)
        for _, v in ipairs(toDamage) do
            if !isValid(v) or v == world then goto cont end
            if !table.hasValue(astro.filter, v) then
                astroutils.applyDamage(v, 5, astro.ent, self.ent)
            end
            ::cont::
        end
    end

    local canAct = {
        ["startLaser"] = AstroScoutLeftArm.STATE.Idle,
        ["stopLaser"] = AstroScoutLeftArm.STATE.Laser,
        ["block"] = AstroScoutLeftArm.STATE.Idle,
        ["unblock"] = AstroScoutLeftArm.STATE.Block,
    }

    function AstroScoutLeftArm:isCanAction(action)
        local st = self:getState()
        return st == canAct[action]
    end


    AstroScoutLeftArm.onModuleDamage = onDamage
else
    function AstroScoutLeftArm:moduleInitialize()
        self.ent:setPoseParameter("rotation_multiplier", 1)
        self.ent:setSequence("idle")
    end

    function AstroScoutLeftArm:renderOffscreen()
        local astro = parentToBone(self)
        if astro and self.laserEffect then
            local pos = self.ent:getPos()
            local tr = trace.line(pos, pos + self.ent:getAngles():getForward() * 32768, astro.filter)
            if !tr then return end
            self.laserEffect:setOrigin(tr.HitPos)
        end
    end
end

function AstroScoutLeftArm.actions.startLaser(self, cur)
    if CLIENT then
        self.ent:setSequence("startLaser", 1)
        timer.simple(0.5, function()
            if !isValid(self) or self:getState() ~= self.STATE.Laser then return end
            self.ent:setSequence("laser", 2)
            self.laserEffect = beff.create("laser")
            self.laserEffect:setScale(1.8)
            self.laserEffect:setEntity(self.ent:getBoneEntity(self.ent:lookupBone("forearm")))
            self.laserEffect:setStart(Vector(0, 96, -2))
            self.laserEffect:play()
            self:renderOffscreen()
        end)
    else
        self:setNextAction("startLaser", cur + 0.5)
        self:setNextAction("block", cur + 0.5)
        self:setState(self.STATE.Laser)
    end
end


function AstroScoutLeftArm.actions.stopLaser(self, cur)
    if CLIENT then
        self.ent:setSequence(0, 2)
        self.ent:setSequence("stopLaser", 1)
        if self.laserEffect then
            self.laserEffect:destroy()
            self.laserEffect = nil
        end
    else
        self:setNextAction("block", cur + 0.5)
        self.ent:setLocalAngles(Angle())
        self:setState(self.STATE.Idle)
    end
end


function AstroScoutLeftArm.actions.block(self, cur)
    if CLIENT then
        self.ent:setSequence("block", 1)
    else
        self:setNextAction("block", cur + 0.5)
        self:setState(self.STATE.Block)
    end
end


function AstroScoutLeftArm.actions.unblock(self, cur)
    if CLIENT then
        self.ent:setSequence("unblock", 1)
    else
        self:setNextAction("block", cur + 0.5)
        timer.simple(0.5, function()
            if !(isValid(self) and self:getState() == self.STATE.Block) then return end
            self:setState(self.STATE.Idle)
        end)
    end
end


function AstroScoutLeftArm:onAction(action)
    local act = self.actions[action]
    if act then
        act(self, timer.curtime())
        return true
    end
    return false
end


ents.register(AstroScoutLeftArm, "astromodule_base")



---@class AstroScoutRightArm: AstroModuleBase
---@field dashStartTime number?
---@field dashTime number?
local AstroScoutRightArm = {}
AstroScoutRightArm.Identifier = "astroscout_rightarm"
AstroScoutRightArm.Name = "AstroScout right arm"
AstroScoutRightArm.Model = function()
    local mdl = model.create("astroscout_rightarm")
    return mdl
end
AstroScoutRightArm.Health = 1
AstroScoutRightArm.hooks = {}
AstroScoutRightArm.STATE = {
    Idle = 0,
    Punching = 1,
    Dashing = 2,
    Block = 3
}
AstroScoutRightArm.actions = {}

if SERVER then
    function AstroScoutRightArm:moduleInitialize()
        self:setState(self.STATE.Idle)
    end

    local canAct = {
        ["punch"] = AstroScoutRightArm.STATE.Idle,
        ["swing"] = AstroScoutRightArm.STATE.Idle,
        ["block"] = AstroScoutRightArm.STATE.Idle,
        ["dash"] = AstroScoutRightArm.STATE.Idle,
        ["unblock"] = AstroScoutRightArm.STATE.Block,
    }

    function AstroScoutRightArm:isCanAction(action)
        local st = self:getState()
        return st == canAct[action]
    end

    function AstroScoutRightArm:think()
        if self:getState() ~= self.STATE.Dashing then return end
        local dir = self:getDirection()
        if dir then
            local astro = self:getAstro()
            if !astro then return end
            astro:setVelocity(dir * 4000)
            local pos = astro.ent:getPos()
            local cur = timer.curtime()
            local remain = self.dashTime - (cur - self.dashStartTime)
            local interval = game.getTickInterval()
            local canPos = pos + dir * (interval * 4000 + 1024)
            if remain <= 0 or !canPos:isInWorld() then
                self:setNextAction("dash", cur + 3)
                self:setNWVar("dashDirection", nil)
                self.ent:setSequence("swing", 1, 0.5)
            end
        end
    end

    AstroScoutRightArm.onModuleDamage = onDamage
else
    function AstroScoutRightArm:moduleInitialize()
        self.ent:setSequence("idle")
    end

    AstroScoutRightArm.renderOffscreen = parentToBone
end


function AstroScoutRightArm.actions.punch(self, cur)
    if CLIENT then
        self.ent:setSequence("punch", 1)
    else
        self:setState(self.STATE.Punching)
        self:setNextAction("punch", cur + 0.5)
        self:setNextAction("swing", cur + 0.5)
        local astro = self:getAstro()
        timer.simple(0.2, function()
             if !(isValid(astro) and isValid(self) and self:getState() == self.STATE.Punching) then return end
            local radius = 160
            local spheres = {
                self.ent:localToWorld(Vector(96, 32, 0)),
                self.ent:localToWorld(Vector(186, 64, 0))
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
                        astroutils.applyDamage(target, 350, astro.ent, self.ent)
                        alreadyDamaged[target] = true
                    end
                    ::cont::
                end
            end
            self:setState(self.STATE.Idle)
        end)
    end
end

function AstroScoutRightArm.actions.swing(self, cur)
    if CLIENT then
        self.ent:setSequence("swing", 1)
    else
        self:setState(self.STATE.Punching)
        self:setNextAction("swing", cur + 1)
        self:setNextAction("punch", cur + 1)
        local astro = self:getAstro()
        timer.simple(0.5, function()
             if !(isValid(astro) and isValid(self) and self:getState() == self.STATE.Punching) then return end
            local radius = 160
            local pos = self.ent:localToWorld(Vector(200, 64, 0))
            bdebug.sphere(pos, radius, 1, Color(255, 0, 0, 0))
            local targets = find.inSphere(pos, radius)
            local damage = 0
            for _, target in ipairs(targets) do
                if !isValid(target) or target == world then goto cont end
                if !table.hasValue(astro.filter, target) then
                    damage = damage + math.min(target:getHealth(), 600)
                    astroutils.applyDamage(target, 600, astro.ent, self.ent)
                end
                ::cont::
            end
            astro:setHealth(math.min(astro:getHealth() + damage * 0.15, astro.Health))
            self:setState(self.STATE.Idle)
        end)
    end
end

function AstroScoutRightArm.actions.dash(self, cur)
    if CLIENT then
        self.ent:setSequence("swing", 1)
        timer.simple(0.4, function()
            self.ent:setSequence(0, 1)
        end)
    else
        self:setState(self.STATE.Dashing)
        local astro = self:getAstro()
        if !astro then return end
        local dir = astro:getDirection()
        if !dir then return end
        self.dashStartTime = timer.curtime()
        self.dashTime = 1
        self:setNWVar("dashDirection", !dir:isZero() and dir or self.ent:getAngles():getForward())
        timer.simple(1.8, function()
             if !(isValid(astro) and isValid(self) and self:getState() == self.STATE.Dashing) then return end
            self:setState(self.STATE.Idle)
        end)
    end
end


function AstroScoutRightArm.actions.block(self, cur)
    if CLIENT then
        self.ent:setSequence("block", 1)
    else
        self:setNextAction("block", cur + 0.5)
        self:setState(self.STATE.Block)
    end
end


function AstroScoutRightArm.actions.unblock(self, cur)
    if CLIENT then
        self.ent:setSequence("unblock", 1)
    else
        self:setNextAction("block", cur + 0.5)
        timer.simple(0.5, function()
            if !(isValid(self) and self:getState() == self.STATE.Block) then return end
            self:setState(self.STATE.Idle)
        end)
    end
end


function AstroScoutRightArm:onAction(action)
    local act = self.actions[action]
    if act then
        act(self, timer.curtime())
        return true
    end
    return false
end

---[SHARED] Get direction of dash
---@return Vector?
function AstroScoutRightArm:getDirection()
    return self:getNWVar("dashDirection")
end


ents.register(AstroScoutRightArm, "astromodule_base")
