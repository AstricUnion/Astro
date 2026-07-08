if SERVER then
    ---@class AstroProjectile: ProjectileBase
    local AstroProjectile = {}
    AstroProjectile.Identifier = "astroprojectile"
    AstroProjectile.Model = function()
        local trailHolo = hologram.create(Vector(), Angle(), "models/hunter/plates/plate.mdl")
        if !trailHolo then return end
        trailHolo:setNoDraw(true)
        -- TODO: made trail lib or something, to made slow-delete trails
        trailHolo:setTrails(54, 0, 0.3, "trails/laser", Color(255, 0, 0))
        local mdl = model.create("astrotrooper_projectile")
        mdl.trailHolo = trailHolo
        return mdl
    end

    function AstroProjectile:think()
        local trailHolo = self.ent.trailHolo
        if isValid(trailHolo) then
            trailHolo:setPos(self.ent:getPos())
        end
    end

    function AstroProjectile:onHit(tr)
        astroutils.blastDamage(tr.HitPos, 200, 60)
        local eff = beff.create("projectile_explosion")
        eff:setOrigin(tr.HitPos)
        eff:setScale(1)
        eff:play()
        local trailHolo = self.ent.trailHolo
        if isValid(trailHolo) then
            timer.simple(0.5, function()
                if !isValid(trailHolo) then return end
                trailHolo:remove()
            end)
        end
    end

    projectile.register(AstroProjectile)
end


---@class AstroBlaster: AstroModuleBase
---@field modulePoint Entity
---@field astroBody Entity
local AstroBlaster = {}
AstroBlaster.Identifier = "astroblaster"
AstroBlaster.Name = "AstroBlaster"
AstroBlaster.Health = 400
AstroBlaster.Model = function()
    local mdl = model.create("astrotrooper_blaster")
    return mdl
end
AstroBlaster.hooks = {}


function AstroBlaster:onAction(action)
    if action ~= "shoot" then return end
    local cur = timer.curtime()
    local angs = self.ent:getAngles()
    local pos = self.ent:getPos()
    local function proj(filter)
        projectile.create("astroprojectile", pos, angs, filter or {self.ent})
    end
    local ammo = self:getAmmo()
    if self:isAlive() then
        local astro = self:getAstro()
        if !astro then return end
        if SERVER then
            self:setNextAction("shoot", cur + 0.3)
            self:setAmmo(ammo - 1)
            local forward = angs:getForward()
            astro.ent:applyForceOffset(forward * 50, astro.ent:worldToLocal(pos))
            astro:addVelocity(-forward * 30)
            proj(astro.filter)
        end
        ammo = ammo - 1
        if ammo <= 0 then
            if SERVER then
                self:setNextAction("shoot", cur + 1.3)
                timer.simple(0.8, function()
                    self:setAmmo(4)
                end)
            else
                self.ent:setSequence(2)
            end
        else
            if CLIENT then self.ent:setSequence(1) end
        end
        return true
    else
        if SERVER then
            if ammo <= 0 then return end
            self:setNextAction("shoot", cur + 0.5)
            self:setAmmo(ammo - 1)
            proj()
            astrosound.play {"blaster", nil, self.ent}
            self.ent:addVelocity(-angs:getForward() * 200)
        end
    end
end


if SERVER then
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
        self.ent:applyForceCenter(astro.velocity + angs:getForward() * 100)
        exp:setOrigin(pos)
        exp:play("Explosion")
        astro.ent:emitSound("WaterExplosionEffect.Sound")
    end
else
    function AstroBlaster:moduleInitialize()
        local astro = self:getAstro()
        if !astro then return end
        self.astroBody = astro.ent:getBoneEntity(astro.ent:lookupBone("body"))
        self.modulePoint = self.ent:getBoneEntity(self.ent:lookupBone("module"))
    end

    function AstroBlaster:renderOffscreen()
        if !self:isAlive() then return end
        local offset = self:getOffset()
        if !(self.astroBody and self.modulePoint and offset) then return end
        self.modulePoint:setPos(self.astroBody:localToWorld(offset))
    end

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
