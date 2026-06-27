---@name Astro Trooper Model
---@author Ratyuha
---@shared

---@class model
local model = model
local hitbox = model.hitbox
local vertex = model.vertex
local part = model.part
local holo = model.holo
local rig = model.rig

local blasterHolo = part {
    holo { Vector(-5, 0, 2), nil, "models/hunter/blocks/cube025x025x025.mdl", color = Color(255, 0, 0, 0) },
    holo { Vector(-28, 0, -2), Angle(180, 90, 90), "models/props_combine/combinethumper001a.mdl", Vector(0.08, 0.08, 0.12), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
    holo { Vector(-28, 0, 6), Angle(0, 90, 90), "models/props_combine/combinethumper001a.mdl", Vector(0.08, 0.08, 0.12), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
    holo { Vector(-28, -5, 2), Angle(-90, 90, 90), "models/props_combine/combinethumper001a.mdl", Vector(0.08, 0.08, 0.12), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
    holo { Vector(-28, 5, 2), Angle(90, 90, 90), "models/props_combine/combinethumper001a.mdl", Vector(0.08, 0.08, 0.12), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
    holo { Vector(-19, 0, 12), Angle(180, 0, 0), "models/combine_dropship_container.mdl", Vector(0.12, 0.12, 0.12), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
    holo { Vector(25, 0, 2), Angle(90, 0, 0), "models/Items/combine_rifle_ammo01.mdl", Vector(1.8, 1.8, 1.8), color = Color(255, 40, 40) },
}

local function blaster(offset)
    return function()
        local holog = blasterHolo()
        if !holog then return end
        holog:setPos(holog:getPos() + offset)
        return holog
    end
end

---@param holoFun modelfun
---@param velocity Angle
local function rotation(holoFun, velocity)
    return function()
        local holog = holoFun()
        if !holog then return end
        holog:setLocalAngularVelocity(velocity)
        return holog
    end
end

model.new("astrotrooper", part {
    hitbox {
        vertex {"cylinder", Vector(0, 0, 0), Angle(0, 0, 0), Vector(32, 32, 7)},
        vertex {"cylinder", Vector(0, 0, -10), Angle(0, 0, 0), Vector(20, 20, 8)},
        vertex {"cube", Vector(0, 0, 28), Angle(0, 0, 0), Vector(14, 14, 14)},
        material = "Metal",
        mass = 1000,
        visible = true
    },
    holo { nil, nil, "models/props_combine/combine_train02a.mdl", Vector(0.1, 0.1, 0.06), color = Color(255, 40, 40) },
    holo { Vector(32, 0, 2), Angle(15, 0, 180), "models/props_combine/combine_barricade_med01b.mdl", Vector(0.15, 0.15, 0.15), color = Color(255, 40, 40) },
    holo { Vector(29, 14, 2), Angle(15, 30, 180), "models/props_combine/combine_barricade_med01b.mdl", Vector(0.15, 0.15, 0.15), color = Color(255, 40, 40) },
    holo { Vector(29, -14, 2), Angle(15, -30, 180), "models/props_combine/combine_barricade_med01b.mdl", Vector(0.15, 0.15, 0.15), color = Color(255, 40, 40) },
    holo { Vector(-32, 0, 5), Angle(15, 180, 180), "models/props_combine/combine_barricade_med01b.mdl", Vector(0.15, 0.15, 0.2), color = Color(255, 40, 40) },
    holo { Vector(-29, 14, 2), Angle(15, 150, 180), "models/props_combine/combine_barricade_med01b.mdl", Vector(0.15, 0.15, 0.15), color = Color(255, 40, 40) },
    holo { Vector(-29, -14, 2), Angle(15, 210, 180), "models/props_combine/combine_barricade_med01b.mdl", Vector(0.15, 0.15, 0.15), color = Color(255, 40, 40) },
    holo { nil, Angle(0, 90, 0), "models/props_combine/combine_train02a.mdl", Vector(0.1, 0.1, 0.06), color = Color(255, 40, 40) },
    holo { nil, Angle(0, -90, 0), "models/props_combine/combine_train02a.mdl", Vector(0.1, 0.1, 0.06), color = Color(255, 40, 40) },
    holo { nil, Angle(0, 180, 0), "models/props_combine/combine_train02a.mdl", Vector(0.1, 0.1, 0.06), color = Color(255, 40, 40) },
    holo { Vector(0, 40, 12), Angle(-150, 90, 0), "models/props_combine/combine_barricade_med02a.mdl", Vector(0.15, 0.18, 0.18), color = Color(255, 40, 40) },
    holo { Vector(0, -40, 12), Angle(-150, -90, 0), "models/props_combine/combine_barricade_med02a.mdl", Vector(0.15, 0.18, 0.18), color = Color(255, 40, 40) },
    rotation(holo { Vector(0, 0, -11), nil, "models/props_phx/wheels/moped_tire.mdl", Vector(1.8, 1.8, 2.2), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" }, Angle(0, 200, 0)),
    rotation(holo { Vector(0, 0, -6), Angle(0, 0, 90), "models/props_wasteland/wheel03a.mdl", Vector(0.27, 0.18, 0.27), color = Color(255, 40, 40) }, Angle(0, -200, 0)),
    rotation(holo { Vector(0, 0, -10), Angle(90, 0, 0), "models/props_c17/pulleywheels_large01.mdl", Vector(1.2, 1, 1), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" }, Angle(0, 200, 0))
})
    :add("head", part {
        holo { Vector(0, 0, 25), nil, "models/hunter/misc/sphere075x075.mdl", Vector(0.75, 0.75, 0.75), noLight = true, color = Color(0, 0, 0), material = "models/debug/debugwhite" },
        holo { Vector(9, 0, 25), nil, "models/hunter/misc/sphere075x075.mdl", Vector(0.3, 0.55, 0.55), noLight = true, color = Color(255, 40, 40), material = "models/debug/debugwhite" },
        holo { Vector(12, 0, 25), nil, "models/hunter/misc/sphere075x075.mdl", Vector(0.18, 0.4, 0.4), noLight = true, color = Color(255, 255, 255), material = "models/debug/debugwhite" },
        holo { Vector(0, 0, 25), Angle(-90, 180, 0), "models/props_combine/combine_booth_short01a.mdl", Vector(0.22, 0.22, 0.16), color = Color(255, 40, 40) },
        holo { Vector(0, 0, 25), Angle(-90, 0, 0), "models/props_combine/combine_booth_short01a.mdl", Vector(0.22, 0.22, 0.16), color = Color(255, 40, 40) },
        holo { Vector(5, 0, 20), Angle(-50, 180, 0), "models/props_combine/combine_booth_short01a.mdl", Vector(0.22, 0.22, 0.16), color = Color(255, 0, 0) },
        holo { Vector(-3, 0, 31), Angle(-190, 0, 0), "models/props_combine/combine_booth_short01a.mdl", Vector(0.21, 0.21, 0.16), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
    })
    :add("leftBlaster", blaster(Vector(0, 40, 0)))
    :add("rightBlaster", blaster(Vector(0, -40, 0)))
