if CLIENT then
    local sounds = "https://raw.githubusercontent.com/AstricUnion/AstroBots/refs/heads/main/sounds/astrotrooper/"
    astrosound.preloadURL("loop", sounds .. "Idle.mp3")
    astrosound.preloadURL("dash", sounds .. "Dash.mp3")
    astrosound.preloadURL("predash", sounds .. "Prepdash.mp3")
    astrosound.preloadURL("reload", sounds .. "Reload.mp3")
    astrosound.preloadURL("blaster", sounds .. "Fire.mp3")
end


---@enum STATE
local STATE = {
    Idle = 0,
    ReadyToDash = 1,
    Dashing = 2
}

---@class AstroTrooper: AstroBase
---@field shootFrom number Shoot from module. Relative to curtime
---@field dashDirection Vector
---@field inDash boolean 
---@field lastDashEffect number Last dash effect
local AstroTrooper = {}
AstroTrooper.Identifier = "astrotrooper"
AstroTrooper.Name = "AstroTrooper"
AstroTrooper.Model = function()
    local mdl = model.create("astrotrooper")
    return mdl
end
AstroTrooper.hooks = {}
AstroTrooper.CameraOffset = Vector(9, 0, -5)
---@type AstroModuleCfg[]
AstroTrooper.Modules = {
    {offset = Vector(0, 40, 0), module = "astroblaster"},
    {offset = Vector(0, -40, 0), module = "astroblaster"},
    {offset = Vector(), module = "astrodash"}
}

if SERVER then
    function AstroTrooper:astroInitialize()
        self.ent:setSequence(1)
        self.ent:emitSound("npc/combine_gunship/dropship_engine_distant_loop1.wav", 75, 70, 1)
        self.shootFrom = 1
        self.modules[3].dashEnd = function(_)
            self.ent:setCollisionGroup(COLLISION_GROUP.NONE)
            self:setState(STATE.Idle)
            self.ent:setNoDraw(false)
            self.modules[1].ent:setNoDraw(false)
            self.modules[2].ent:setNoDraw(false)
            local eff = beff.create("quantum_burst")
            eff:setOrigin(self.ent:getPos())
            eff:setNormal(self.ent:getAngles():getForward())
            eff:setScale(3)
            eff:play()
        end
        self:setState(STATE.Idle)
    end

    function AstroTrooper:inputPressed(button)
        local state = self:getState()
        if state ~= STATE.Idle then return end
        if button == MOUSE.MOUSE1 then
            local mod = self.modules[self.shootFrom]
            mod:sendAction("shoot")
            local newId = self.shootFrom == 1 and 2 or 1
            if self.modules[newId]:isAlive() then
                self.shootFrom = newId
            end
        elseif button == MOUSE.MOUSE2 then
            if !self.modules[3]:canAction("dash") then return end
            self.ent:setCollisionGroup(COLLISION_GROUP.IN_VEHICLE)
            self.ent:setNoDraw(true)
            self.modules[1].ent:setNoDraw(true)
            self.modules[2].ent:setNoDraw(true)
            astrosound.play {"dash", nil, self.ent}
            self.modules[3]:sendAction("dash")
            self:setState(STATE.Dashing)
        end
    end

    function AstroTrooper:onDeath()
        for _, v in ipairs(self.modules) do
            v.ent:applyDamage(v:getHealth())
        end
        self:remove()
    end
else
    local l1 = light.create(Vector(), 80, 10, Color(255, 0, 0))
    local l2 = light.create(Vector(), 80, 10, Color(255, 0, 0))

    function AstroTrooper:renderOffscreen()
        if !self:getDriver() then return end
        l1:setPos(self.ent:localToWorld(Vector(0, 0, 20)))
        l2:setPos(self.ent:localToWorld(Vector(0, 0, -10)))
        l1:draw()
        l2:draw()
    end

    function AstroTrooper:think()
        local cur = timer.curtime()
        if self:getState() == STATE.Dashing and (self.lastDashEffect or 0) < cur then
            local dashMod = self.modules[3]
            local eff = beff.create("quantum_burst")
            eff:setOrigin(self.ent:getPos())
            eff:setNormal(dashMod:getDirection())
            eff:play()
            self.lastDashEffect = cur + 0.1
        end
    end
end

ents.register(AstroTrooper, "astrobase")
