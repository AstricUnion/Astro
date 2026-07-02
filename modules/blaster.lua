---@class AstroBlaster: AstroModuleBase
---@field ammo number
local AstroBlaster = {}
AstroBlaster.Identifier = "astroblaster"
AstroBlaster.Name = "AstroBlaster"
AstroBlaster.Health = 400
AstroBlaster.Model = function()
    local mdl = model.create("astrotrooper_blaster")
    return mdl
end
AstroBlaster.hooks = {}

local projectileModel = function()
    local mdl = model.create("astrotrooper_projectile")
    mdl:setTrails(54, 0, 0.3, "trails/laser", Color(255, 0, 0))
    return mdl
end

if SERVER then
    function AstroBlaster:moduleInitialize()
        self.ammo = 4
    end

    function AstroBlaster:onAction(action)
        if action ~= "shoot" then return end
        local cur = timer.curtime()
        local angs = self.ent:getAngles()
        local pos = self.ent:getPos()
        local function proj(filter)
            guns.createProjectile(pos, angs, projectileModel, filter or {self.ent})
            astrosound.play {"blaster", nil, self.ent}
        end
        if self:isAlive() then
            local astro = self:getAstro()
            if !astro then return end
            self:setNextAction("shoot", cur + 0.3)
            self.ent:setSequence(1)
            self.ammo = self.ammo - 1
            astro.ent:applyForceOffset(angs:getForward() * 50, astro.ent:worldToLocal(pos))
            astro:addVelocity(-angs:getForward() * 30)
            proj(astro.filter)
            if self.ammo <= 0 then
                self:setNextAction("shoot", cur + 1.3)
                astrosound.play {"reload", nil, self.ent}
                timer.simple(0.3, function()
                    self.ent:setSequence(2)
                    self.ammo = 4
                end)
            end
        else
            if self.ammo <= 0 then
                return
            end
            self:setNextAction("shoot", cur + 0.5)
            self.ammo = self.ammo - 1
            proj()
            self.ent:addVelocity(-angs:getForward() * 200)
        end
    end

    ---@param self AstroBlaster
    function AstroBlaster.hooks.PlayerUse(self, ply, ent)
        if self.ent ~= ent then return end
        if !self:isAlive() then
            self:sendAction("shoot")
        end
    end

    function AstroBlaster:think()
        if !self:isAlive() then return end
        local astro = self:getAstro()
        if !astro then return end
        local tr = astro:getEyeTrace()
        if !tr then return end
        self.ent:setAngles((tr.HitPos - self.ent:getPos()):getAngle())
    end

    local exp = effect.create()

    function AstroBlaster:onDeath()
        local astro = self:getAstro()
        if !astro then return end
        local pos = self.ent:getPos()
        self.ent:setParent(nil)
        self.ent:setPos(pos)
        local angs = self.ent:getAngles()
        local astroPos = astro.ent:getPos()
        local forceAng = (astroPos - pos):getAngle()
        astro:addVelocity(forceAng:getForward() * 300)
        astro.ent:applyForceOffset(-angs:getForward() * 500, astro.ent:worldToLocal(pos))
        self.ent:applyForceCenter(angs:getForward() * 100)
        exp:setOrigin(pos)
        exp:play("Explosion")
        astro.ent:emitSound("WaterExplosionEffect.Sound")
    end
end

ents.register(AstroBlaster, "astromodule_base")
