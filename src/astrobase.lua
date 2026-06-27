---@class ents
local ents = ents


---@class AstroBase: BModEntity
---@field SprintSpeed number Sprint speed of Astro. By default is 600
---@field Speed number Default speed of Astro. By default is 400
---@field VelocityRatio number Velocity ratio to lerp. By default is 0.05
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


if SERVER then
    function AstroBase:initialize()
        local seat = prop.createSeat(self.ent:getPos(), Angle(), "models/nova/airboat_seat.mdl", true)
        self.seat = seat
        self.physobj = self.ent:getPhysicsObject()
        self.velocity = Vector()
    end

    ---@param ply Player
    ---@param vehicle Vehicle
    function AstroBase.hooks:PlayerEnteredVehicle(ply, vehicle)
        if vehicle == self.seat then
            self.driver = ply
        end
    end

    ---@param ply Player
    ---@param vehicle Vehicle
    function AstroBase.hooks:PlayerLeaveVehicle(ply, vehicle)
        if vehicle == self.seat then
            self.driver = nil
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
    ---@return Vector? direction Returns direction Astro moving in
    function AstroBase:getDirection()
        if !self.driver then return end
        local eyeangles = self.driver:getEyeAngles():setR(0)
        local dir = Vector(
            getKeyDirection(self.driver, IN_KEY.BACK, IN_KEY.FORWARD),
            getKeyDirection(self.driver, IN_KEY.MOVERIGHT, IN_KEY.MOVELEFT),
            0
        ):getRotated(eyeangles)
        dir.z = math.clamp(dir.z + getKeyDirection(self.driver, IN_KEY.SPEED, IN_KEY.JUMP), -1, 1)
        return dir
    end

    ---[SERVER] Think hook for Astro
    function AstroBase:think() end

    ---[INTERNAL] [SERVER] Astrobot physics
    function AstroBase.hooks:Think()
        local frametime = game.getTickInterval()
        if isValid(self.driver) then
            local dir = self:getDirection()
            local speed = self.driver:keyDown(IN_KEY.DUCK) and self.SprintSpeed or self.Speed
            self.velocity = math.lerpVector(self.VelocityRatio, self.velocity, dir * speed * 100 * frametime)
            self.physobj:setVelocity(self.velocity)
            local eyeangles = self.driver:getEyeAngles()
            local ang = self.ent:worldToLocalAngles(eyeangles)
            local angvel = ang:getQuaternion():getRotationVector() - self.ent:getAngleVelocity() / 5
            self.physobj:addAngleVelocity(angvel)
        end
        self.seat:setAngles(Angle())
    end
end




ents.register(AstroBase)
