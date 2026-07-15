local function parentToBone(self)
    local astro = self:getAstro()
    if !astro then return end
    local offset = self:getOffset()
    local body = astro.ent:getBoneEntity(astro.ent:lookupBone("body"))
    local modulePoint = self.ent:getBoneEntity(self.ent:lookupBone("module"))
    if !(body and modulePoint) then return end
    ---@cast body Hologram
    ---@cast modulePoint Hologram
    local pos, ang = localToWorld(offset, Angle(), body:getPos(), body:getAngles())
    modulePoint:setPos(pos)
    modulePoint:setAngles(ang)
end

---@class AstroScoutLeftArm: AstroModuleBase
local AstroScoutLeftArm = {}
AstroScoutLeftArm.Identifier = "astroscout_leftarm"
AstroScoutLeftArm.Name = "AstroScout left arm"
AstroScoutLeftArm.Model = function()
    local mdl = model.create("astroscout_leftarm")
    return mdl
end
AstroScoutLeftArm.hooks = {}


function AstroScoutLeftArm:onAction(action)
end

if SERVER then
else
    function AstroScoutLeftArm:moduleInitialize()
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
    if action == "attack1" then
        if CLIENT then
            self.ent:setSequence(self.ent:lookupSequence("attack1"), 1)
        else
            self:setNextAction(timer.curtime() + 0.5)
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
