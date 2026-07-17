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
    if self.Identifier == "astroscout_leftarm" and self.laserOn then return end
    modulePoint:setAngles(ang)
end

---@class AstroScoutLeftArm: AstroModuleBase
---@field laserOn boolean
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
        if CLIENT then
            self.ent:setSequence(2, 1)
            timer.simple(0.5, function()
                self.ent:setSequence(3, 2)
            end)
        else
            self:setNextAction("startLaser", cur + 0.5)
        end
        self.laserOn = true
        return true
    end
end

if SERVER then
    function AstroScoutLeftArm:think()
        local astro = self:getAstro()
        if !astro then return end
        local tr = astro:getEyeTrace()
        if !tr then return end
        self.ent:setAngles((tr.HitPos - self.ent:getPos()):getAngle())
    end
else
    function AstroScoutLeftArm:moduleInitialize()
        self.ent:setPoseParameter("rotation_multiplier", 1)
        self.ent:setSequence(1)
    end

    AstroScoutLeftArm.renderOffscreen = parentToBone
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
            self.ent:setSequence(self.ent:lookupSequence("punch"), 1)
        else
            self:setNextAction("punch", cur + 0.5)
            self:setNextAction("swing", cur + 0.5)
        end
        return true
    elseif action == "swing" then
        if CLIENT then
            self.ent:setSequence(self.ent:lookupSequence("swing"), 1)
        else
            self:setNextAction("swing", cur + 1)
            self:setNextAction("punch", cur + 1)
        end
        return true
    end
end

if SERVER then
else
    function AstroScoutRightArm:moduleInitialize()
        self.ent:setSequence(1)
    end

    AstroScoutRightArm.renderOffscreen = parentToBone
end

ents.register(AstroScoutRightArm, "astromodule_base")
