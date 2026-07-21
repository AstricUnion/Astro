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
    if self.Identifier == "astroscout_leftarm" and self.laserOn then
        modulePoint:setLocalAngles(Angle())
        return astro
    elseif self.ent:getSequence(1) == 4 then
        modulePoint:setAngles(math.lerpAngle(0.3, modulePoint:getAngles(), ang))
        return astro
    end
    modulePoint:setAngles(ang)
    return astro
end

---@class AstroScoutLeftArm: AstroModuleBase
---@field laserOn boolean
---@field laserEffect BEffect
local AstroScoutLeftArm = {}
AstroScoutLeftArm.Identifier = "astroscout_leftarm"
AstroScoutLeftArm.Name = "AstroScout left arm"
AstroScoutLeftArm.Model = function()
    local mdl = model.create("astroscout_leftarm")
    return mdl
end
AstroScoutLeftArm.hooks = {}


function AstroScoutLeftArm:onAction(action)
    local cur = timer.curtime()
    if action == "startLaser" then
        if self.laserOn then return end
        if CLIENT then
            self.ent:setSequence("startLaser", 1)
            timer.simple(0.5, function()
                if !isValid(self) or !self.laserOn then return end
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
        end
        self.laserOn = true
        return true
    elseif action == "stopLaser" then
        if !self.laserOn then return end
        if CLIENT then
            self.ent:setSequence(0, 2)
            self.ent:setSequence("stopLaser", 1)
            if self.laserEffect then
                self.laserEffect:destroy()
                self.laserEffect = nil
            end
            self.moduleBone:setLocalAngles(Angle())
        else
            self.ent:setLocalAngles(Angle())
        end
        self.laserOn = false
        return true
    end
end

if SERVER then
    function AstroScoutLeftArm:think()
        if !self.laserOn then return end
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

ents.register(AstroScoutLeftArm, "astromodule_base")



---@class AstroScoutRightArm: AstroModuleBase
local AstroScoutRightArm = {}
AstroScoutRightArm.Identifier = "astroscout_rightarm"
AstroScoutRightArm.Name = "AstroScout right arm"
AstroScoutRightArm.Model = function()
    local mdl = model.create("astroscout_rightarm")
    return mdl
end
AstroScoutRightArm.hooks = {}


function AstroScoutRightArm:onAction(action)
    local cur = timer.curtime()
    if action == "punch" then
        if CLIENT then
            self.ent:setSequence("punch", 1)
        else
            self:setNextAction("punch", cur + 0.5)
            self:setNextAction("swing", cur + 0.5)
            local astro = self:getAstro()
            timer.simple(0.2, function()
                 if !(isValid(astro) and isValid(self)) then return end
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
            end)
        end
        return true
    elseif action == "swing" then
        if CLIENT then
            self.ent:setSequence("swing", 1)
        else
            self:setNextAction("swing", cur + 1)
            self:setNextAction("punch", cur + 1)
            local astro = self:getAstro()
            timer.simple(0.4, function()
                 if !(isValid(astro) and isValid(self)) then return end
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
            end)
        end
        return true
    end
end

if SERVER then
else
    function AstroScoutRightArm:moduleInitialize()
        self.ent:setSequence("idle")
    end

    AstroScoutRightArm.renderOffscreen = parentToBone
end

ents.register(AstroScoutRightArm, "astromodule_base")
