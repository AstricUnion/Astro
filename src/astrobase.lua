---@class ents
local ents = ents

---@class AstroModuleBase: BModEntity
local AstroModuleBase = {}
AstroModuleBase.Identifier = "astromodule_base"
AstroModuleBase.Name = "AstroModule base"
AstroModuleBase.Model = ""
AstroModuleBase.hooks = {}

if SERVER then
    ---[SERVER] On activate AstroModule
    ---@return boolean? activated Activate this module
    function AstroModuleBase:onActivate() end

    ---[SERVER] On deactivate AstroModule
    function AstroModuleBase:onDeactivate() end

    ---[SERVER] Try to activate module
    function AstroModuleBase:activate()
        local activate = self:onActivate()
        if !activate then return end
        self:setNWVar("isActive", activate and true or false)
    end

    ---[SERVER] Deactivate module
    function AstroModuleBase:deactivate()
        self:onDeactivate()
        self:setNWVar("isActive", false)
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

---[SHARED] Is module active
---@return Player?
function AstroModuleBase:isActive()
    return self:getNWVar("isActive", false)
end

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

ents.register(AstroModuleBase)



---@class AstroModuleCfg
---@field offset Vector Offset of this module
---@field module string Module name
---@field binds table<number, string>? Binds for module

---@class AstroBase: BModEntity
---@field SprintSpeed number Sprint speed of Astro. By default is 600
---@field Speed number Default speed of Astro. By default is 400
---@field VelocityRatio number Velocity ratio to lerp. By default is 0.05
---@field CameraOffset Vector Camera offset
---@field CameraAngle Angle Camera angles
---@field Modules AstroModuleCfg[]
---@field protected seat Vehicle Seat for astro driver
---@field protected driver Player Driver of this Astro
---@field protected velocity Vector Velocity of this Astro
---@field protected physobj PhysObj Physics object of this Astro
---@field protected modules AstroModuleBase[] Initialized modules of astro
---@field protected filter Entity[] Entities to filter (for eyeTrace)
local AstroBase = {}
AstroBase.Identifier = "astrobase"
AstroBase.Name = "Base Astro"
AstroBase.Model = ""
AstroBase.hooks = {}

AstroBase.SprintSpeed = 600
AstroBase.Speed = 400
AstroBase.VelocityRatio = 0.05
AstroBase.CameraOffset = Vector()
AstroBase.CameraAngle = Angle()
AstroBase.Modules = {}


---[SHARED] Post initialize Astro
function AstroBase:astroInitialize() end


function AstroBase:initialize()
    self.filter = {self.ent}
    local modules = {}
    if SERVER then
        local seat = prop.createSeat(self.ent:getPos(), Angle(), "models/nova/airboat_seat.mdl", true)
        self.seat = seat
        self.physobj = self.ent:getPhysicsObject()
        self.velocity = Vector()
        local pos, ang = self.ent:getPos(), self.ent:getAngles()
        for i, v in ipairs(self.Modules) do
            local ent = ents.create(v.module)
            local localPos, localAng = localToWorld(v.offset, Angle(), pos, ang)
            ent:spawn(localPos, localAng, true)
            ---@cast ent AstroModuleBase
            ent.ent:setParent(self.ent)
            ent:setAstro(self, i)
            modules[i] = ent
            self.filter[#self.filter+1] = ent.ent
        end
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
    ---@param ply Player
    ---@param vehicle Vehicle
    function AstroBase.hooks:PlayerEnteredVehicle(ply, vehicle)
        if vehicle == self.seat then
            self:setNWVar("AstroDriver", ply:getUserID())
            self.physobj:enableGravity(false)
            enableHud(ply, true)
            ply:setViewEntity(self.ent)
        end
    end

    ---@param ply Player
    ---@param vehicle Vehicle
    function AstroBase.hooks:PlayerLeaveVehicle(ply, vehicle)
        if vehicle == self.seat then
            self:setNWVar("AstroDriver", nil)
            self.physobj:enableGravity(true)
            ply:setViewEntity(nil)
            enableHud(ply, false)
        end
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

    ---[INTERNAL] [SERVER] Astrobot physics
    function AstroBase.hooks:Think()
        local frametime = game.getTickInterval()
        local dr = self:getDriver()
        if dr and isValid(dr) then
            local eyeangles = dr:getEyeAngles()
            local dir = getDirection(dr, eyeangles)
            local speed = dr:keyDown(IN_KEY.DUCK) and self.SprintSpeed or self.Speed
            self.velocity = math.lerpVector(self.VelocityRatio, self.velocity, dir * speed * 100 * frametime)
            self.physobj:setVelocity(self.velocity)
            local ang = self.ent:worldToLocalAngles(eyeangles)
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
        ---@cast astro AstroBase
        if astro.inputPressed and astro:getDriver() == ply then
            astro:inputPressed(net.readUInt(32))
        end
    end)

    net.receive("AstroInputReleased", function(_, ply)
        local ent = net.readEntity()
        local astro = ents.inited[ent:entIndex()]
        ---@cast astro AstroBase
        if astro.inputReleased and astro:getDriver() == ply then
            astro:inputReleased(net.readUInt(32))
        end
    end)
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
        return {
            origin = pos,
            angles = ang,
            fov = 120
        }
    end

    ---[CLIENT] Effects for head for astro
    function AstroBase.hooks:RenderOffscreen()
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
        if self:getDriver() == Ply then
            self:inputPressed(button)
            net.start("AstroInputPressed")
                net.writeEntity(self.ent)
                net.writeUInt(button, 32)
            net.send()
        end
    end

    ---[INTERNAL] [CLIENT] Astrobot input released
    function AstroBase.hooks:InputReleased(button)
        if self:getDriver() == Ply then
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


---[SHARED] Get Astro eye trace
---@return TraceResult? trace
function AstroBase:getEyeTrace()
    local dr = self:getDriver()
    if !dr then return end
    local pos = self.ent:getPos()
    local ang = dr:getEyeAngles()
    return trace.line(pos, pos + ang:getForward() * 32768, self.filter)
end


ents.register(AstroBase)
