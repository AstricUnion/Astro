---Lib to create Astro's modules
---@class astromodule
local astromodule = {}

---@class ents
local ents = ents

---Astro module - module with physics body, like guns or arms
---@class AstroModuleBase: BModEntity
---@field Health number Health of module
---@field protected nextAction table<string, number>
local AstroModuleBase = {}
AstroModuleBase.Identifier = "astromodule_base"
AstroModuleBase.Name = "AstroModule base"
AstroModuleBase.Model = function()
    local holo = hologram.create(Vector(), Angle(), "models/editor/axis_helper_thick.mdl")
    if !holo then return end
    holo:setNoDraw(true)
    return holo
end
AstroModuleBase.hooks = {}
AstroModuleBase.Health = -1

---[SHARED] Initialize module hook
function AstroModuleBase:moduleInitialize() end

---[SHARED] Initialize module
function AstroModuleBase:initialize()
    if SERVER then
        self.ent:setHealth(self.Health)
        self.ent:setMaxHealth(self.Health)
        self.nextAction = {}
    end
    self:moduleInitialize()
end

if SERVER then
    ---[SERVER] On action
    ---@param action string
    function AstroModuleBase:onAction(action) end

    ---[SERVER] Send action to module
    ---@param action string
    function AstroModuleBase:sendAction(action)
        if (self.nextAction[action] or 0) > timer.curtime() then return end
        self:onAction(action)
    end

    ---[SERVER] Set next cooldown for action
    function AstroModuleBase:setNextAction(action, nextAction)
        self.nextAction[action] = nextAction
    end

    ---[SERVER] Set next cooldown for action
    function AstroModuleBase:getNextAction(action)
        return self.nextAction[action] or 0
    end

    ---[SERVER] Can this module made action
    function AstroModuleBase:canAction(action)
        return (self.nextAction[action] or 0) <= timer.curtime()
    end

    ---[SERVER] When module damaged
    function AstroModuleBase:onDamage(attacker, inflictor, amount, type, pos, force) end

    ---[SERVER] On module death
    function AstroModuleBase:onDeath() end

    ---[SERVER] Damage mechanics
    ---@param self AstroModuleBase
    ---@param target Entity
    function AstroModuleBase.hooks.PostEntityTakeDamage(self, target, attacker, inflictor, amount, type, pos, force)
        if target ~= self.ent or self.Health <= 0 then return end
        local current = self.ent:getHealth() - amount
        self.ent:setHealth(current)
        self.ent:applyForceOffset(force, pos)
        self:onDamage(attacker, inflictor, amount, type, pos, force)
        if current <= 0 then
            self:onDeath()
        end
    end

    ---[INTERNAL] [SERVER] Set Astro for this module
    ---@param astro AstroBase
    ---@param id number ID of module in astro
    function AstroModuleBase:setAstro(astro, id)
        self:setNWVar("LinkedAstro", astro.ent:entIndex())
        self:setNWVar("ModuleID", id)
    end
else
    function AstroModuleBase:networkVariablesUpdate(old, new)
        if !old.LinkedAstro and new.LinkedAstro then
            local astro = self:getAstro()
            if !astro then return end
            astro:clientInitializeModule(self)
        end
    end
end

---[SHARED] Think hook
function AstroModuleBase:think() end

---[SHARED] Get Astro
---@return AstroBase?
function AstroModuleBase:getAstro()
    local entId = self:getNWVar("LinkedAstro")
    local ent = entId and ents.inited[entId] or nil
    ---@cast ent AstroBase
    return ent
end

---[SHARED] Get module ID
---@return number?
function AstroModuleBase:getModuleID()
    return self:getNWVar("ModuleID")
end

---[SHARED] Get module's health
---@return number health
function AstroModuleBase:getHealth()
    return self.ent:getHealth()
end

---[SHARED] Is Astro alive
---@return boolean isAlive
function AstroModuleBase:isAlive()
    return self.ent:getHealth() > 0
end

ents.register(AstroModuleBase)

