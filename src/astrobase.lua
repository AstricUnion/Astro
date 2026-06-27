---@class ents
local ents = ents


---@class AstroBase: BModEntity
---@field SprintSpeed number Sprint speed of Astro. By default is 600
---@field Speed number Default speed of Astro. By default is 400
---@field VelocityRatio number Velocity ratio to lerp. By default is 0.05
---@field CameraOffset Vector Camera offset
---@field CameraAngle Angle Camera angles
---@field private seat Vehicle Seat for astro driver
---@field private driver Player Driver of this Astro
---@field private velocity Vector Velocity of this Astro
---@field private physobj PhysObj Physics object of this Astro
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


if SERVER then
    function AstroBase:initialize()
        local seat = prop.createSeat(self.ent:getPos(), Angle(), "models/nova/airboat_seat.mdl", true)
        self.seat = seat
        self.physobj = self.ent:getPhysicsObject()
        self.velocity = Vector()
    end

    ---[SERVER] Set driver to this astro or nil, to remove it
    ---@param driver Player? Player to set or nil to reset
    function AstroBase:setDriver(driver)
        self:setNWVar("AstroDriver", driver and driver:getUserID() or nil)
    end

    ---@param ply Player
    ---@param vehicle Vehicle
    function AstroBase.hooks:PlayerEnteredVehicle(ply, vehicle)
        if vehicle == self.seat then
            self:setDriver(ply)
            self.physobj:enableGravity(false)
            enableHud(ply, true)
            ply:setViewEntity(self.ent)
        end
    end

    ---@param ply Player
    ---@param vehicle Vehicle
    function AstroBase.hooks:PlayerLeaveVehicle(ply, vehicle)
        if vehicle == self.seat then
            self:setDriver(nil)
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

    ---[SERVER] Think hook for Astro
    function AstroBase:think() end

    ---[INTERNAL] [SERVER] Astrobot physics
    function AstroBase.hooks:Think()
        local frametime = game.getTickInterval()
        local dr = self:getDriver()
        if isValid(dr) then
            local eyeangles = dr:getEyeAngles()
            local dir = getDirection(dr, eyeangles)
            local speed = dr:keyDown(IN_KEY.DUCK) and self.SprintSpeed or self.Speed
            self.velocity = math.lerpVector(self.VelocityRatio, self.velocity, dir * speed * 100 * frametime)
            self.physobj:setVelocity(self.velocity)
            local ang = self.ent:worldToLocalAngles(eyeangles)
            local angvel = ang:getQuaternion():getRotationVector() - self.ent:getAngleVelocity() / 5
            self.physobj:addAngleVelocity(angvel)
        end
    end
else
    ---[CLIENT] Calc view for Astro
    function AstroBase.hooks:CalcView(pos, ang)
        local dr = self:getDriver()
        if !dr then return end
        local headId = self.ent:lookupBone("head")
        if !headId then return end
        local head = self.ent:getBoneEntity(headId)
        if !head then return end
        pos, ang = localToWorld(self.CameraOffset, self.CameraAngle, head:getPos(), head:getAngles())
        return {
            origin = pos,
            angles = ang,
            fov = 120
        }
    end


    ---[CLIENT] Effects for head for astro
    function AstroBase.hooks:RenderOffscreen()
        local dr = self:getDriver()
        if !dr then return end
        local headId = self.ent:lookupBone("head")
        if !headId then return end
        local head = self.ent:getBoneEntity(headId)
        if !head then return end
        head:setAngles(dr:getEyeAngles())
    end
end


---[SHARED] Get driver
---@return Player?
function AstroBase:getDriver()
    local userId = self:getNWVar("AstroDriver")
    return userId and player(userId) or nil
end




ents.register(AstroBase)
