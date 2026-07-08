---@name Guns
---@author AstricUnion


if !SERVER then return end

---@class guns
---@field inited ProjectileBase[]
---@field registered table<string, ProjectileBase>
local projectile = {}
projectile.inited = {}
projectile.registered = {}

---@class ProjectileBase
---@field Identifier string Identifier of projectile
---@field Model string|fun() Function to create projectile
---@field Velocity number Velocity of projectile
---@field Timeout number Timeout of projectile
---@field id number
---@field ent Entity
---@field velocity Vector
---@field ignore Entity[]
---@field startedAt number
local ProjectileBase = {}
ProjectileBase.__index = ProjectileBase
ProjectileBase.Identifier = "base"
ProjectileBase.Velocity = 5000
ProjectileBase.Timeout = 3


---[SERVER] Hook on hit
---@param tr TraceResult
function ProjectileBase:onHit(tr) end

---[SERVER] Hook on think
function ProjectileBase:think() end

---[INTERNAL] [SERVER] Hook on think
function ProjectileBase:internalThink(cur, delta)
    local pos = self.ent:getPos()
    local newIgnore = {}
    for _, ent in ipairs(self.ignore) do
        if isValid(ent) then newIgnore[#newIgnore+1] = ent end
    end
    self.ignore = newIgnore
    self:think()
    local trace_result = trace.line(pos, pos + self.velocity * delta, self.ignore, MASK.SHOT_HULL)
    if trace_result.Hit or cur - self.startedAt > self.Timeout then
        self.ent:remove()
        projectile.inited[self.id] = nil
        if !trace_result.HitSky then
            self:onHit(trace_result)
        end
        setmetatable(self, nil)
    end
end

projectile.registered["base"] = ProjectileBase

---[SHARED] Register new projectile to use it after
---@param class table Table with info about this entity
function projectile.register(class)
    local id = class.Identifier
    if !id then
        throw("This class has no identifier")
        return
    end
    local inheritedClass = setmetatable(class, ProjectileBase)
    inheritedClass.__index = class
    projectile.registered[id] = class
end

---[SERVER] Create new projectile
function projectile.create(className, position, angle, ignore)
    local class = projectile.registered[className]
    ---@cast class ProjectileBase
    local mdl = class.Model
    mdl = isstring(mdl) and hologram.create(Vector(), Angle(), mdl) or mdl()
    mdl:setPos(position)
    mdl:setAngles(angle)
    local id = #projectile.inited+1
    local vel = angle:getForward() * class.Velocity
    local tbl = {
        ent = mdl,
        id = id,
        velocity = vel,
        ignore = ignore,
        startedAt = timer.curtime()
    }
    local obj = setmetatable(tbl, class)
    mdl:setVelocity(vel)
    projectile.inited[id] = obj
end

hook.add("Think", "GunsProjectiles", function()
    local delta = game.getTickInterval()
    local cur = timer.curtime()
    for _, v in pairs(projectile.inited) do
        v:internalThink(cur, delta)
    end
end)

return projectile

