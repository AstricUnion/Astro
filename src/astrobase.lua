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
    else
        timer.simple(0, function()
            if !isValid(self) then return end
            local astro = self:getAstro()
            if !astro then return end
            astro:clientInitializeModule(self)
        end)
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


---@class AstroModuleCfg
---@field module string?
---@field offset Vector

---@class AstroBase: BModEntity
---@field SprintSpeed number Sprint speed of Astro. By default is 600
---@field Speed number Default speed of Astro. By default is 400
---@field VelocityRatio number Velocity ratio to lerp. By default is 0.05
---@field CameraOffset Vector Camera offset
---@field CameraAngle Angle Camera angles
---@field Health number Health of Astro
---@field Modules AstroModuleCfg[]
---@field SeatOffset Vector Offset of seat
---@field SeatAngle Angle Angle offset of seat
---@field SeatVisible boolean Made seat visible
---@field seat Vehicle Seat for astro driver
---@field velocity Vector Velocity of this Astro
---@field physobj PhysObj Physics object of this Astro
---@field modules AstroModuleBase[] Initialized modules of astro
---@field filter Entity[] Entities to filter (for eyeTrace)
---@field lastPos Vector Last position to calculate FOV
---@field fovOffset number Current FOV offset. Will be lerp-ed
---@field slop number Current slop offset. Will be lerp-ed
local AstroBase = {}
AstroBase.Identifier = "astrobase"
AstroBase.Name = "Base Astro"
AstroBase.Model = ""
AstroBase.hooks = {}

AstroBase.SprintSpeed = 600
AstroBase.Speed = 400
AstroBase.VelocityRatio = 0.04
AstroBase.CameraOffset = Vector()
AstroBase.CameraAngle = Angle()
AstroBase.Health = 1000
AstroBase.Modules = {}
AstroBase.SeatOffset = Vector()
AstroBase.SeatAngle = Angle(0, -90, 0)
AstroBase.SeatVisible = false


---[SHARED] Post initialize Astro
function AstroBase:astroInitialize() end


function AstroBase:initialize()
    self.filter = {self.ent}
    local modules = {}
    if SERVER then
        self.ent:setHealth(self.Health)
        self.ent:setMaxHealth(self.Health)
        local seat = prop.createSeat(Vector(), Angle(), "models/nova/airboat_seat.mdl", true)
        seat:setNoDraw(!self.SeatVisible)
        self.seat = seat
        self:seatToAstro()
        self.physobj = self.ent:getPhysicsObject()
        self.velocity = Vector()
        local pos, ang = self.ent:getPos(), self.ent:getAngles()
        for i, v in ipairs(self.Modules) do
            local ent = ents.create(v.module)
            ---@cast ent AstroModuleBase
            local localPos, localAng = localToWorld(v.offset, Angle(), pos, ang)
            ent:setAstro(self, i)
            ent:spawn(localPos, localAng, false)
            ent.ent:setParent(self.ent)
            modules[i] = ent
            self.filter[#self.filter+1] = ent.ent
        end
    else
        self.lastPos = self.ent:getPos()
        self.fovOffset = 0
        self.slop = 0
    end
    self.modules = modules
    self:astroInitialize()
end

---[SHARED] Think hook for Astro
function AstroBase:think() end

---[SHARED] On input pressed
---@param button KEY Key enum
function AstroBase:inputPressed(button, bind) end

---[SHARED] On input released
---@param button KEY Key enum
function AstroBase:inputReleased(button, bind) end



if SERVER then
    local seatPinPoint = hologram.create(Vector(), Angle(), "models/editor/axis_helper_thick.mdl")
    if !seatPinPoint then return end
    seatPinPoint:setLocalAngularVelocity(Angle(500, 500, 500))

    function AstroBase:seatToAstro()
        self.seat:setParent(nil)
        self.seat:setPos(self.ent:localToWorld(Vector(50, 0, 0)))
        self.seat:setAngles(self.ent:localToWorldAngles(Angle(0, -90, 0)))
        self.seat:setParent(self.ent)
    end

    ---@param self AstroBase
    ---@param ply Player
    ---@param key IN
    function AstroBase.hooks.KeyPress(self, ply, key)
        if key ~= IN_KEY.USE or ply ~= self:getDriver() then return end
        self:seatToAstro()
    end

    ---@param self AstroBase
    ---@param ply Player
    ---@param vehicle Vehicle
    function AstroBase.hooks.PlayerEnteredVehicle(self, ply, vehicle)
        if vehicle ~= self.seat then return end
        self:setNWVar("AstroDriver", ply:getUserID())
        self.physobj:enableGravity(false)
        self.seat:setPos(seatPinPoint:localToWorld(Vector(16384, 0, 0)))
        self.seat:setAngles(Angle())
        self.seat:setParent(seatPinPoint)
        enableHud(ply, true)
        ply:setViewEntity(self.ent)
    end

    ---@param self AstroBase
    ---@param ply Player
    ---@param vehicle Vehicle
    function AstroBase.hooks.PlayerLeaveVehicle(self, ply, vehicle)
        if vehicle ~= self.seat then return end
        self:setNWVar("AstroDriver", nil)
        self.physobj:enableGravity(true)
        ply:setViewEntity(nil)
        enableHud(ply, false)
    end

    ---[SERVER] Get fly velocity of Astro
    ---@return Vector velocity
    function AstroBase:getVelocity()
        return self.velocity
    end

    ---[SERVER] Add vector to fly velocity
    ---@param vel Vector
    function AstroBase:addVelocity(vel)
        self.velocity = self.velocity + vel
    end

    ---[SERVER] Add vector to fly velocity
    ---@param vel Vector
    function AstroBase:setVelocity(vel)
        self.velocity = vel
    end

    ---[SERVER] Set Astro's state
    ---@param state number
    function AstroBase:setState(state)
        self:setNWVar("state", state)
    end

    ---Gets key direction of player.
    ---@param ply Player
    ---@param negative_key number See IN_KEY enum
    ---@param positive_key number See IN_KEY enum
    ---@return number from -1 to 1
    local function getKeyDirection(ply, negative_key, positive_key)
        return (ply:keyDown(positive_key) and 1 or 0) - (ply:keyDown(negative_key) and 1 or 0)
    end

    ---Gets direction of the driver
    ---@param ply Player Driver
    ---@param rotation Angle Rotation of direction
    ---@return Vector? direction Returns direction Astro moving in
    local function getDirection(ply, rotation)
        local dir = Vector(
            getKeyDirection(ply, IN_KEY.BACK, IN_KEY.FORWARD),
            getKeyDirection(ply, IN_KEY.MOVERIGHT, IN_KEY.MOVELEFT),
            0
        ):getRotated(rotation)
        dir.z = math.clamp(dir.z + getKeyDirection(ply, IN_KEY.SPEED, IN_KEY.JUMP), -1, 1)
        return dir
    end

    ---[SERVER] Gets direction of Astro
    ---@return Vector? direction
    function AstroBase:getDirection()
        local dr = self:getDriver()
        if !dr then return end
        local angs = self.seat:worldToLocalAngles(dr:getEyeAngles())
        return getDirection(dr, angs)
    end

    ---[INTERNAL] [SERVER] Astrobot physics
    function AstroBase.hooks:Think()
        local frametime = game.getTickInterval()
        local dr = self:getDriver()
        if dr and isValid(dr) then
            self:think()
            local eyeangles = self.seat:worldToLocalAngles(dr:getEyeAngles())
            local dir = getDirection(dr, eyeangles)
            local speed = dr:keyDown(IN_KEY.DUCK) and self.SprintSpeed or self.Speed
            self.velocity = math.lerpVector(self.VelocityRatio, self.velocity, dir * speed * 100 * frametime)
            self.physobj:setVelocity(self.velocity)
            local localVel = self.physobj:getLocalVelocity()
            local ang = self.ent:worldToLocalAngles(Angle(eyeangles.p, eyeangles.y, (localVel.y / -speed) * 2))
            local angvel = ang:getQuaternion():getRotationVector() - self.ent:getAngleVelocity() / 5
            self.physobj:addAngleVelocity(angvel)
            for _, v in ipairs(self.modules) do
                v:think()
            end
        end
    end

    net.receive("AstroInputPressed", function(_, ply)
        local ent = net.readEntity()
        local astro = ents.inited[ent:entIndex()]
        if !astro then return end
        ---@cast astro AstroBase
        if astro.inputPressed and astro:getDriver() == ply then
            local key = net.readUInt(32)
            astro:inputPressed(key)
        end
    end)

    net.receive("AstroInputReleased", function(_, ply)
        local ent = net.readEntity()
        local astro = ents.inited[ent:entIndex()]
        if !astro then return end
        ---@cast astro AstroBase
        if astro.inputReleased and astro:getDriver() == ply then
            local key = net.readUInt(32)
            astro:inputReleased(key)
        end
    end)

    ---[SERVER] When Astro got damaged
    function AstroBase:onDamage(attacker, inflictor, amount, type, pos, force) end

    ---[SERVER] On Astro death
    function AstroBase:onDeath() end

    ---[SERVER] Damage mechanics
    ---@param self AstroBase
    ---@param target Entity
    function AstroBase.hooks.PostEntityTakeDamage(self, target, attacker, inflictor, amount, type, pos, force)
        if target ~= self.ent then return end
        local current = self.ent:getHealth() - amount
        self.ent:setHealth(current)
        self.ent:applyForceOffset(force, pos)
        self:onDamage(attacker, inflictor, amount, type, pos, force)
        if current <= 0 then
            self:onDeath()
        end
    end

    ---[SERVER] On remove (to remove seat)
    function AstroBase:onRemove()
        if isValid(self.seat) then
            self:seatToAstro()
            self.seat:remove()
        end
    end

    ---[SERVER] On remove chip, to teleport seat
    function AstroBase.hooks.Removed(self)
        self:seatToAstro()
    end
else
    local Ply = player()

    ---[CLIENT] Calc view for Astro
    function AstroBase.hooks:CalcView(pos, ang)
        local dr = self:getDriver()
        if dr ~= Ply then return end
        local cameraId = self.ent:lookupBone("camera")
        if !cameraId then return end
        local camera = self.ent:getBoneEntity(cameraId)
        if !camera then return end
        local eyeAngles = dr:getEyeAngles()
        camera:setAngles(eyeAngles)
        pos, ang = localToWorld(self.CameraOffset, self.CameraAngle, camera:getPos(), eyeAngles)
        local velocity = self.ent:worldToLocalVector(self.lastPos - pos)
        self.lastPos = pos
        self.fovOffset = math.lerp(0.1, self.fovOffset, velocity:getLength() / 10)
        self.slop = math.lerp(0.2, self.slop, velocity.y / 20)
        return {
            origin = pos,
            angles = ang:setR(self.slop),
            fov = 120 + self.fovOffset
        }
    end
    --
    -- local drawElements = {
    --     ["CHudChat"] = true,
    --     ["CHudMessage"] = true
    -- }
    --
    -- ---[CLIENT] Draw HUD or not
    -- ---@param element string
    -- function AstroBase.hooks:HUDShouldDraw(element)
    --     local dr = self:getDriver()
    --     if dr ~= Ply then return end
    --     return drawElements[element] or false
    -- end

    local function pushMask(mask)
        render.clearStencil()
        render.setStencilEnable(true)

        render.setStencilWriteMask(1)
        render.setStencilTestMask(1)

        render.setStencilFailOperation(STENCIL.REPLACE)
        render.setStencilPassOperation(STENCIL.ZERO)
        render.setStencilZFailOperation(STENCIL.ZERO)
        render.setStencilCompareFunction(STENCIL.NEVER)
        render.setStencilReferenceValue(1)

        mask()

        render.setStencilFailOperation(STENCIL.ZERO)
        render.setStencilPassOperation(STENCIL.REPLACE)
        render.setStencilZFailOperation(STENCIL.ZERO)
        render.setStencilCompareFunction(STENCIL.EQUAL)
        render.setStencilReferenceValue(0)
    end

    local function popMask()
        render.setStencilEnable(false)
        render.clearStencil()
    end

    ---[CLIENT] Draw HUD for Astro
    function AstroBase.hooks:PostDrawHUD()
        local dr = self:getDriver()
        if dr ~= Ply then return end
        -- local sw, sh = render.getGameResolution()
        -- render.drawRect(sw / 2 - 1, sh / 2 - 1, 2, 2)
        pushMask(function()
            render.drawTriangle(18, 3, 33, 29, 3, 29)
            render.drawTriangle(0, 11, 36, 11, 18, 42)
        end)
        render.drawTriangle(18, 0, 36, 31, 0, 31)
    end

    ---[CLIENT] Hook on render offscreen
    function AstroBase:renderOffscreen() end

    ---[CLIENT] Effects for head for astro
    function AstroBase.hooks:RenderOffscreen()
        self:renderOffscreen()
        local dr = self:getDriver()
        if !dr or dr == Ply then return end
        local cameraId = self.ent:lookupBone("camera")
        if !cameraId then return end
        local camera = self.ent:getBoneEntity(cameraId)
        if !camera then return end
        camera:setAngles(dr:getEyeAngles())
    end

    ---[INTERNAL] [CLIENT] Astrobot think for client
    function AstroBase.hooks:Think()
        self:think()
        for _, v in ipairs(self.modules) do
            v:think()
        end
    end

    ---[INTERNAL] [CLIENT] Astrobot input pressed
    function AstroBase.hooks:InputPressed(button)
        if self:getDriver() == Ply and !input.getCursorVisible() then
            self:inputPressed(button)
            net.start("AstroInputPressed")
                net.writeEntity(self.ent)
                net.writeUInt(button, 32)
            net.send()
        end
    end

    ---[INTERNAL] [CLIENT] Astrobot input released
    function AstroBase.hooks:InputReleased(button)
        if self:getDriver() == Ply and !input.getCursorVisible() then
            self:inputReleased(button)
            net.start("AstroInputReleased")
                net.writeEntity(self.ent)
                net.writeUInt(button, 32)
            net.send()
        end
    end

    ---[INTERNAL] [CLIENT] Client initialize for module
    ---@param module AstroModuleBase
    function AstroBase:clientInitializeModule(module)
        self.modules[module:getModuleID()] = module
        self.filter[#self.filter+1] = module.ent
    end
end

---[SHARED] Get driver
---@return Player?
function AstroBase:getDriver()
    local userId = self:getNWVar("AstroDriver")
    return userId and player(userId) or nil
end

---[SHARED] Get astro eyes angles
---@return Angle?
function AstroBase:getEyeAngles()
    local dr = self:getDriver()
    if !dr then return end
    return self.seat:worldToLocalAngles(dr:getEyeAngles())
end

---[SHARED] Get Astro eye trace
---@return TraceResult? trace
function AstroBase:getEyeTrace()
    local ang = self:getEyeAngles()
    if !ang then return end
    local pos = self.ent:getPos()
    return trace.line(pos, pos + ang:getForward() * 32768, self.filter)
end

---[SHARED] Get Astro's health
---@return number health
function AstroBase:getHealth()
    return self.ent:getHealth()
end

---[SHARED] Is Astro alive
---@return boolean isAlive
function AstroBase:isAlive()
    return self.ent:getHealth() > 0
end

---[SHARED] Get Astro state
---@return number state
function AstroBase:getState()
    return self:getNWVar("state", nil)
end


ents.register(AstroBase)
