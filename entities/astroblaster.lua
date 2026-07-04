---@class AstroBlaster: AstroModuleBase
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
    function AstroBlaster:onAction(action)
        if action ~= "shoot" then return end
        local cur = timer.curtime()
        local angs = self.ent:getAngles()
        local pos = self.ent:getPos()
        local function proj(filter)
            guns.createProjectile(pos, angs, projectileModel, filter or {self.ent})
            astrosound.play {"blaster", nil, self.ent}
        end
        local ammo = self:getAmmo()
        if self:isAlive() then
            local astro = self:getAstro()
            if !astro then return end
            self:setNextAction("shoot", cur + 0.3)
            self.ent:setSequence(1)
            self:setAmmo(ammo - 1)
            ammo = ammo - 1
            astro.ent:applyForceOffset(angs:getForward() * 50, astro.ent:worldToLocal(pos))
            astro:addVelocity(-angs:getForward() * 30)
            proj(astro.filter)
            if ammo <= 0 then
                self:setNextAction("shoot", cur + 1.3)
                astrosound.play {"reload", nil, self.ent}
                timer.simple(0.3, function()
                    self.ent:setSequence(2)
                    timer.simple(0.5, function()
                        self:setAmmo(4)
                    end)
                end)
            end
        else
            if ammo <= 0 then
                return
            end
            self:setNextAction("shoot", cur + 0.5)
            self:setAmmo(ammo - 1)
            proj()
            self.ent:addVelocity(-angs:getForward() * 200)
        end
    end

    ---[SERVER] Set ammo of blaster
    ---@param ammo number
    function AstroBlaster:setAmmo(ammo)
        self:setNWVar("Ammo", ammo)
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
        self.ent:setFrozen(false)
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
else
    function AstroBlaster:drawHUD(x, y)
        if !self:isAlive() then return end
        local sw, sh = render.getGameResolution()
        local hp = self:getHealth()
        local moduleId = self:getModuleID()
        local ammo = self:getAmmo()
        local isRight = x > sw / 2
        astrogui.drawProgressBarSections(x - 46, y, 92, 40, 16, ammo / 4, !isRight and "AMMO" or "", isRight and "AMMO" or "", true, isRight)
        local text = "BLASTER_" .. moduleId
        local hpText = string.format("%s/%s", hp, self.Health)
        astrogui.drawProgressBar(x - 82 + 32 * (isRight and 1 or -1), y - 28, 164, 24, hp / self.Health, !isRight and text or hpText, isRight and text or hpText)
    end
end

---[SHARED] Get ammo of blaster
---@return number ammo
function AstroBlaster:getAmmo()
    return self:getNWVar("Ammo", 4)
end

ents.register(AstroBlaster, "astromodule_base")
