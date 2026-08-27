local tween = tween
local param = tween.param
local fcurveParam = tween.fcurveParam

local model = model
local hitbox = model.hitbox
local vertex = model.vertex
local part = model.part
local holo = model.holo
local rig = model.rig

local function circleProperty(radiusX, radiusY, layer)
    radiusY = radiusY or radiusX
    return {
        set = function(ent, toSet)
            if toSet == 1 then
                toSet = 0
            end
            local process = toSet * math.pi * 2
            local sin, cos = math.sin(process), math.cos(process)
            ent:setLocalPosLayer(layer, Vector(sin * radiusX, 0, cos * radiusY))
            ent.circleAng = toSet
        end,
        get = function(ent)
            return ent.circleAng or 0
        end
    }
end


-- local col = Color(255, 40, 40)
-- local col1 = Color(185, 30, 30)

local col = Color(255, 255, 255)
local col1 = Color(191, 191, 191)

local metGibMat = {[0] = "models/gibs/metalgibs/metal_gibs", [1] = "models/gibs/metalgibs/metal_gibs", [2] = "models/gibs/metalgibs/metal_gibs"}
-- вот тут надо очень постараться с оптимизацией. каждая лишняя холка умножается на 4
-- я немношка убрал, но надо посмотреть со стороны именно дизайна, а не только оптимизации. строки можешь раскомментить по желанию
local blasterHolos = part {
    rig(),
    -- holo { Vector(0, 153, 2), Angle(0, 180, 180), "models/props_combine/combine_train02b.mdl", Vector(0.1, 0.145, 0.05), color = col },
    -- holo { Vector(0, 153, 2), Angle(0, 0, 180), "models/props_combine/combine_train02b.mdl", Vector(0.1, 0.145, 0.05), color = col },
    holo { Vector(-8.5, 136, 13), Angle(0, 270, -90), "models/combine_dropship_container.mdl", Vector(0.285, 0.15, 0.06), color = col },
    holo { Vector(8.5, 136, 13), Angle(0, 270, 90), "models/combine_dropship_container.mdl", Vector(0.285, 0.15, 0.06), color = col },
    holo { Vector(0, 136, 0), Angle(0, 270, 0), "models/combine_dropship_container.mdl", Vector(0.285, 0.15, 0.05), color = col },
    holo { Vector(0, 136, 21), Angle(0, 270, 180), "models/combine_dropship_container.mdl", Vector(0.285, 0.15, 0.05), color = col },
    holo { Vector(0, 195, 13), Angle(90, 90, 0), "models/Items/combine_rifle_ammo01.mdl", Vector(2, 2, 2), color = col },
    holo { Vector(0, 210, 13), Angle(90, 90, 0), "models/props_phx/wheels/magnetic_large.mdl", Vector(0.2, 0.2, 0.75), color = col, material = metGibMat },
    holo { Vector(0, 210, 13), Angle(90, 90, 0), "models/props_phx/wheels/magnetic_large.mdl", Vector(0.245, 0.245, 1.1), color = col, material = metGibMat },
    holo { Vector(0, 221, 13), Angle(90, 90, 0), "models/mechanics/wheels/wheel_speed_72.mdl", Vector(0.15, 0.15, 0.1), color = Color(0, 0, 0), material = metGibMat },
    holo { Vector(0, 221.5, 13), Angle(90, 90, 0), "models/hunter/tubes/circle2x2.mdl", Vector(0.15, 0.15, 0.1), noLight = true, color = Color(255, 0, 0), material = "models/effects/vortshield" },
    holo { Vector(0, 140, 13), Angle(0, 90, 0), "models/xqm/jetengine.mdl", Vector(0.5, 1, 1), color = col, material = metGibMat },
    -- holo { Vector(0, 145, 17), Angle(0, 180, 90), "models/props_combine/combine_mine01.mdl", Vector(0.7, 0.7, 5.1), color = col },
    -- holo { Vector(0, 145, 17), Angle(-45, 180, 90), "models/props_combine/combine_mine01.mdl", Vector(0.7, 0.7, 5.1), color = col },
    -- holo { Vector(0, 145, 17), Angle(45, 180, 90), "models/props_combine/combine_mine01.mdl", Vector(0.7, 0.7, 5.1), color = col },
    holo { Vector(34, 95, 2.3), Angle(0, 5, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.29), color = col1, material = "models/props_canal/metalwall005b" },
    -- holo { Vector(0, 60, 0), Angle(-22.5, 180, 90), "models/props_combine/combine_mine01.mdl", Vector(1.5, 1.5, 5.1), color = col },
    holo { Vector(0, 215, 0), Angle(90, 270, 0), "models/props_combine/combine_mortar01b.mdl", Vector(0.75, 0.75, 2.5), color = col1 }
}

local function blasterCluster(offset, angle)
    local rigFun = rig(offset, angle)
    local frac = 360 / 4

    return function()
        local rg = rigFun()
        if !rg then return end
        local baseAngle = rg:getAngles()
        for i = 0, 3 do
            local ang = i * frac
            rg:setLocalAngles(baseAngle + Angle(ang, 0, 0))
            local mdl = blasterHolos()
            if mdl then
                mdl:setParent(rg)
            end
        end
        return rg
    end
end


local body = part {
    rig(),
    holo { Vector(0, 75, -35), Angle(0, 90, 0), "models/props_combine/combine_bridge.mdl", Vector(0.4, 0.4, 0.25), color = col, material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(0, -75, -35), Angle(0, -90, 0), "models/props_combine/combine_bridge.mdl", Vector(0.4, 0.4, 0.25), color = col, material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(-75, 0, -35), Angle(0, 180, 0), "models/props_combine/combine_bridge.mdl", Vector(0.4, 0.4, 0.25), color = col, material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(-50, 50, -35), Angle(0, 135, 0), "models/props_combine/combine_bridge.mdl", Vector(0.4, 0.4, 0.25), color = col, material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(-50, -50, -35), Angle(0, -135, 0), "models/props_combine/combine_bridge.mdl", Vector(0.4, 0.4, 0.25), color = col, material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(0, -70, 40), Angle(0, 0, -20), "models/props_combine/combine_train02b.mdl", Vector(0.4, 0.1, 0.15), color = col },
    holo { Vector(0, -70, 40), Angle(0, 180, 20), "models/props_combine/combine_train02b.mdl", Vector(0.4, 0.1, 0.15), color = col },
    holo { Vector(0, 70, 40), Angle(0, 0, 20), "models/props_combine/combine_train02b.mdl", Vector(0.4, 0.1, 0.15), color = col },
    holo { Vector(0, 70, 40), Angle(0, 180, -20), "models/props_combine/combine_train02b.mdl", Vector(0.4, 0.1, 0.15), color = col },
    holo { Vector(-35, -40, 28), Angle(0, 50, 0), "models/props_combine/combineinnerwallcluster1024_002a.mdl", Vector(0.1, 0.1, 0.045), color = col },
    holo { Vector(-35, 40, 28), Angle(0, -50, 0), "models/props_combine/combineinnerwallcluster1024_002a.mdl", Vector(0.1, 0.1, 0.045), color = col },
    holo { Vector(-25, -35, 28), Angle(0, 50, 0), "models/props_combine/combineinnerwallcluster1024_002a.mdl", Vector(0.09, 0.09, 0.045), color = col },
    holo { Vector(-25, 35, 28), Angle(0, -50, 0), "models/props_combine/combineinnerwallcluster1024_002a.mdl", Vector(0.09, 0.09, 0.045), color = col },
    holo { Vector(25, 25, -30), Angle(30, 45, 0), "models/props_combine/combine_barricade_med01a.mdl", Vector(0.125, 0.35, 0.35), color = col },
    holo { Vector(25, -25, -30), Angle(30, -45, 0), "models/props_combine/combine_barricade_med01a.mdl", Vector(0.125, 0.35, 0.35), color = col },
    holo { Vector(-25, 25, -30), Angle(30, 135, 0), "models/props_combine/combine_barricade_med01a.mdl", Vector(0.125, 0.35, 0.35), color = col },
    holo { Vector(-25, -25, -30), Angle(30, -135, 0), "models/props_combine/combine_barricade_med01a.mdl", Vector(0.125, 0.35, 0.35), color = col },
    holo { Vector(40, 0, -30), Angle(30, 0, 0), "models/props_combine/combine_barricade_med01a.mdl", Vector(0.125, 0.35, 0.35), color = col },
    holo { Vector(-40, 0, -30), Angle(30, 180, 0), "models/props_combine/combine_barricade_med01a.mdl", Vector(0.125, 0.35, 0.35), color = col },
    holo { Vector(0, 40, -30), Angle(30, 90, 0), "models/props_combine/combine_barricade_med01a.mdl", Vector(0.125, 0.35, 0.35), color = col },
    holo { Vector(0, -40, -30), Angle(30, -90, 0), "models/props_combine/combine_barricade_med01a.mdl", Vector(0.125, 0.35, 0.35), color = col },
    holo { Vector(0, -65, 42), Angle(160, -90, 0), "models/combine_dropship_container.mdl", Vector(0.15, 0.5, 0.25), color = col },
    holo { Vector(0, 65, 42), Angle(160, 90, 0), "models/combine_dropship_container.mdl", Vector(0.15, 0.5, 0.25), color = col },
    holo { nil, Angle(180, 0, 0), "models/mechanics/wheels/wheel_speed_72.mdl", Vector(1.5, 1.5, 0.5), color = col, material = "models/gibs/metalgibs/metal_gibs" },
    holo { nil, Angle(0, 90, 90), "models/props_wasteland/wheel02a.mdl", Vector(0.575, 0.5, 0.575), color = col, material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(0, 0, -15), Angle(180, -75, 0), "models/mechanics/wheels/wheel_extruded_48.mdl", Vector(2.45, 2.45, 1.35), color = col, material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(0, 0, -15), Angle(180, 0, 0), "models/mechanics/wheels/wheel_extruded_48.mdl", Vector(2.45, 2.45, 1.35), color = col, material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(-45, -45, -15), Angle(-70, -135, 0), "models/combine_dropship_container.mdl", Vector(0.125, 0.15, 0.15), color = col },
    holo { Vector(-45, 45, -15), Angle(-70, 135, 0), "models/combine_dropship_container.mdl", Vector(0.125, 0.15, 0.15), color = col },
    holo { Vector(45, -45, -15), Angle(-70, -45, 0), "models/combine_dropship_container.mdl", Vector(0.125, 0.15, 0.15), color = col },
    holo { Vector(45, 45, -15), Angle(-70, 45, 0), "models/combine_dropship_container.mdl", Vector(0.125, 0.15, 0.15), color = col },
    holo { Vector(-50, 0, -25), Angle(155, 0, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.045, 0.025, 0.045), color = col },
    holo { Vector(50, 0, -25), Angle(155, 180, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.045, 0.025, 0.045), color = col },
    holo { Vector(0, 50, -25), Angle(155, -90, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.045, 0.025, 0.045), color = col },
    holo { Vector(0, -50, -25), Angle(155, 90, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.045, 0.025, 0.045), color = col },
    holo { Vector(0, 0, 22), Angle(180, 0, 0), "models/props_phx/wheels/moped_tire.mdl", Vector(3.5, 3.5, 4), color = col, material = metGibMat },
    holo { Vector(0, 0, 14), Angle(180, 0, 0), "models/props_phx/wheels/moped_tire.mdl", Vector(3.75, 3.75, 2), color = col, material = metGibMat },
}
 
local rotor1 = part {
    rig (),
    holo { Vector(0, 0, -30), Angle(90, 0, 0), "models/props_c17/pulleywheels_large01.mdl", Vector(1, 2, 2), color = col, material = metGibMat },
    holo { nil, nil, "models/props_combine/combine_train02a.mdl", Vector(0.15, 0.175, 0.075), color = col, material = "models/gibs/metalgibs/metal_gibs" },
    holo { nil, Angle(0, 180, 0), "models/props_combine/combine_train02a.mdl", Vector(0.15, 0.175, 0.075), color = col, material = "models/gibs/metalgibs/metal_gibs" },
    holo { nil, Angle(0, 90, 0), "models/props_combine/combine_train02a.mdl", Vector(0.15, 0.175, 0.075), color = col, material = "models/gibs/metalgibs/metal_gibs" },
    holo { nil, Angle(0, -90, 0), "models/props_combine/combine_train02a.mdl", Vector(0.15, 0.175, 0.075), color = col, material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(0, 0, -20), Angle(180, 0, 0), "models/hunter/tubes/tube2x2x025d.mdl", Vector(1.1, 1.1, 0.2), color = col, material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(1.25, -1.25, -20), Angle(180, 0, 0), "models/hunter/tubes/tube2x2x025d.mdl", Vector(1.075, 1.075, 0.15), noLight = true, color = col, material = "models/debug/debugwhite" },
    holo { Vector(0, 0, -20), Angle(180, 180, 0), "models/hunter/tubes/tube2x2x025d.mdl", Vector(1.1, 1.1, 0.2), color = col, material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(-1.25, 1.25, -20), Angle(180, 180, 0), "models/hunter/tubes/tube2x2x025d.mdl", Vector(1.075, 1.075, 0.15), noLight = true, color = col, material = "models/debug/debugwhite" },
    holo { Vector(0, 0, -4), Angle(0, 90, 180), "models/props_combine/combine_mine01.mdl", Vector(2.75, 2.75, 2.7), color = col },
    holo { nil, Angle(0, 90, 180), "models/Items/combine_rifle_ammo01.mdl", Vector(11.15, 11.15, 4.25), color = col },
}
 
local rotor2 = part {
    rig (Vector(0, 0, -28)),
    holo { Vector(0, 0, 0), Angle(180, 0, 0), "models/hunter/tubes/tube2x2x025d.mdl", Vector(0.8, 0.8, 0.2), color = col, material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(1.25, -1.25, 0), Angle(180, 0, 0), "models/hunter/tubes/tube2x2x025d.mdl", Vector(0.775, 0.775, 0.15), noLight = true, color = col, material = "models/debug/debugwhite" },
    holo { Vector(0, 0, 0), Angle(180, 180, 0), "models/hunter/tubes/tube2x2x025d.mdl", Vector(0.8, 0.8, 0.2), color = col, material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(-1.25, 1.25, 0), Angle(180, 180, 0), "models/hunter/tubes/tube2x2x025d.mdl", Vector(0.775, 0.775, 0.15), noLight = true, color = col, material = "models/debug/debugwhite" },
    holo { Vector(0, 0, 8), Angle(90, 0, 0), "models/props_c17/pulleywheels_large01.mdl", Vector(1, 2.5, 2.5), color = col, material = metGibMat },
    holo { Vector(0, 0, 13), Angle(0, 90, 180), "models/props_combine/combine_mine01.mdl", Vector(2.5, 2.5, 2.8), color = col },
    holo { Vector(45, 0, 27), Angle(0, -90, 0), "models/combine_apc_wheelcollision.mdl", Vector(0.25, 0.2, 0.1), color = col },
    holo { Vector(-45, 0, 27), Angle(0, 90, 0), "models/combine_apc_wheelcollision.mdl", Vector(0.25, 0.2, 0.1), color = col },
    holo { Vector(0, 45, 27), nil, "models/combine_apc_wheelcollision.mdl", Vector(0.25, 0.2, 0.1), color = col },
    holo { Vector(0, -45, 27), Angle(0, 180, 0), "models/combine_apc_wheelcollision.mdl", Vector(0.25, 0.2, 0.1), color = col },
    holo { Vector(-10, 0, 27), Angle(0, -90, 0), "models/combine_apc_wheelcollision.mdl", Vector(0.25, 0.2, 0.1), color = col },
    holo { Vector(10, 0, 27), Angle(0, 90, 0), "models/combine_apc_wheelcollision.mdl", Vector(0.25, 0.2, 0.1), color = col },
    holo { Vector(0, -10, 27), nil, "models/combine_apc_wheelcollision.mdl", Vector(0.25, 0.2, 0.1), color = col },
    holo { Vector(0, 10, 27), Angle(0, 180, 0), "models/combine_apc_wheelcollision.mdl", Vector(0.25, 0.2, 0.1), color = col },
}
 
local head = part {
    rig(),
    holo { Vector(1.68, 0, -1), Angle(-110, 0, 0), "models/props_combine/combine_booth_short01a.mdl", Vector(0.3528, 0.42, 0.294), color = col },
    holo { Vector(1.68, 0, -1), Angle(-110, 180, 0), "models/props_combine/combine_booth_short01a.mdl", Vector(0.3528, 0.42, 0.294), color = col },
    holo { Vector(16.8, 0, -5.25), Angle(0, 180, 180), "models/props_combine/combine_booth_short01a.mdl", Vector(0.672, 0.4368, 0.294), color = col },
    holo { Vector(16.8, 0, -21.4), Angle(90, 0, 0), "models/props_combine/combine_booth_short01a.mdl", Vector(0.168, 0.42, 0.084), color = col },
    holo { Vector(16.8, 15.12, -13), Angle(0, 90, 90), "models/props_combine/combine_booth_short01a.mdl", Vector(0.168, 0.168, 0.084), color = col },
    holo { Vector(16.8, -15.12, -13), Angle(180, 90, 90), "models/props_combine/combine_booth_short01a.mdl", Vector(0.168, 0.168, 0.084), color = col },
    holo { Vector(-16.8, 0, 14), Angle(180, 180, 0), "models/combine_dropship_container.mdl", Vector(0.21, 0.462, 0.168), color = col },
    holo { Vector(-16.8, 0, -12.3), nil, "models/combine_dropship_container.mdl", Vector(0.21, 0.462, 0.336), color = col },
    holo { Vector(-15.12, 0, 14), Angle(0, 90, 0), "models/props_combine/combine_train02b.mdl", Vector(0.336, 0.1512, 0.084), color = col },
    holo { Vector(-15.12, 20.16, 6.5), Angle(90, 90, 0), "models/props_combine/combine_train02b.mdl", Vector(0.084, 0.1512, 0.084), color = col },
    holo { Vector(-15.12, -20.16, 6.5), Angle(-90, 90, 0), "models/props_combine/combine_train02b.mdl", Vector(0.084, 0.1512, 0.084), color = col },
    holo { Vector(22, 0, -10), Angle(90, 0, 0), "models/holograms/hq_torus.mdl", Vector(2.1), noLight = true, color = Color(0, 0, 0) },
    holo { Vector(18, 0, -10), Angle(90, 0, 0), "models/holograms/hq_torus_thin.mdl", Vector(2.8), noLight = true, color = col },
    holo { Vector(0, 0, -10), nil, "models/holograms/hq_sphere.mdl", Vector(4.125), noLight = true, color = Color(0, 0, 0), material = "models/debug/debugwhite" },
    holo { Vector(15.05, 0, -10), Angle(90, 0, 0), "models/holograms/hq_sphere.mdl", Vector(2.9, 2.9, 1.75), noLight = true, color = col, material = "models/props_lab/cornerunit_cloud" },
    holo { Vector(16.5, 0, -10), Angle(90, 0, 0), "models/holograms/hq_sphere.mdl", Vector(2.5, 2.5, 1.75), noLight = true, color = col },
    holo { Vector(22.45, 0, -10), Angle(90, 0, 0), "models/holograms/hq_sphere.mdl", Vector(1.7, 0.96, 0.85), noLight = true, color = Color(0, 0, 0) },
    holo { Vector(23.35, 0, -10), Angle(90, 0, 0), "models/holograms/hq_sphere.mdl", Vector(1.5, 0.5, 0.75), noLight = true, noColorize =  true },
}
 
local leftShoulder = part {
    rig(Vector(0, 75, 25)),
    holo { Vector(-30, -15, -1), Angle(180, 0, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = col1, },
    holo { Vector(30, -15, -1), Angle(0, 0, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(165, 20, 20) },
    holo { Vector(0, -15, 29), Angle(-90, 0, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(165, 20, 20) },
    holo { Vector(0, -15, -25), Angle(90, 0, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(165, 20, 20) },
    holo { Vector(30, 125, -1), Angle(180, 180, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = col1, },
    holo { Vector(-30, 125, -1), Angle(0, 180, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(165, 20, 20) },
    holo { Vector(0, 125, 29), Angle(-90, 180, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(165, 20, 20) },
    holo { Vector(0, 125, -25), Angle(90, 180, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(165, 20, 20) },
    holo { Vector(0, 50, 2), nil, "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.175, 0.125), color = col },
    holo { Vector(0, 45, 0), Angle(0, 90, 0), "models/props_wasteland/laundry_washer003.mdl", Vector(1.1, 0.85, 0.75 ), color = col, material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(0, 20, 25), Angle(270, -90, 0), "models/props_combine/combine_dispenser.mdl", Vector(1.3), color = col }
}
 
local rightShoulder = part {
    rig(Vector(0, -75, 25)),
    holo { Vector(0, -40, 2), nil, "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.15, 0.175), color = col },
    holo { Vector(0, -40, 2), Angle(180, 0, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.15, 0.175), color = col },
    holo { Vector(0, -40, 2), Angle(-90, 0, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.15, 0.175), color = col },
    holo { Vector(0, -40, 2), Angle(90, 0, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.15, 0.175), color = col },
    holo { Vector(0, -40, 2), Angle(0, 180, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.15, 0.175), color = col },
    holo { Vector(0, -40, 2), Angle(180, 180, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.15, 0.175), color = col },
    holo { Vector(0, -40, 2), Angle(-90, 180, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.15, 0.175), color = col },
    holo { Vector(0, -40, 2), Angle(90, 180, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.15, 0.175), color = col },
    holo { Vector(21, -25, 23), Angle(180, -90, 45), "models/combine_dropship_container.mdl", Vector(0.25, 0.15, 0.1), color = col },
    holo { Vector(-21, -25, 23), Angle(180, -90, -45), "models/combine_dropship_container.mdl", Vector(0.25, 0.15, 0.1), color = col },
    holo { Vector(21, -25, -19), Angle(180, -90, 135), "models/combine_dropship_container.mdl", Vector(0.25, 0.15, 0.1), color = col },
    holo { Vector(-21, -25, -19), Angle(180, -90, -135), "models/combine_dropship_container.mdl", Vector(0.25, 0.15, 0.1), color = col },
    holo { Vector(20, -14, 2), Angle(0, 0, 90), "models/props_combine/combine_barricade_med01b.mdl", Vector(0.15, 0.25, 0.5), color = col },
    holo { Vector(-20, -14, 2), Angle(180, 0, 90), "models/props_combine/combine_barricade_med01b.mdl", Vector(0.15, 0.25, 0.5), color = col },
    holo { Vector(0, -14, 22), Angle(-90, -90, 180), "models/props_combine/combine_barricade_med01b.mdl", Vector(0.15, 0.25, 0.5), color = col },
    holo { Vector(0, -14, -18), Angle(90, 90, 180), "models/props_combine/combine_barricade_med01b.mdl", Vector(0.15, 0.25, 0.5), color = col },
}
 
local rightForearm = part {
    rig(Vector(-4, -80, 2)),
    holo { Vector(4, -5, -12), nil, "models/props_rooftop/dome004.mdl", Vector(0.215, 0.215, 0.215), color = col, material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(4, -4.5, -27), Angle(0, 0, -90), "models/props_rooftop/dome005.mdl", Vector(0.105, 0.105, 0.15), color = col, material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(4, 45, -44), Angle(90, 90, 180), "models/props_combine/combine_barricade_med01b.mdl", Vector(0.15, 0.25, 0.5), color = col },
    holo { Vector(4, 20, -27), Angle(180, 180, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.15, 0.175), color = col },
    holo { Vector(4, 20, -27), Angle(180, 0, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.15, 0.175), color = col },
    holo { Vector(4, 6.5, -29), Angle(0, -90, 0), "models/combine_dropship_container_static.mdl", Vector(0.25, 0.4, 0.35), color = col },
    holo { Vector(4, -30, -27), Angle(0, 180, 0), "models/props_combine/combine_generator01.mdl", Vector(0.5, 1.25, 0.25), color = col },
    holo { Vector(4, -30, -27), Angle(180, 180, 0), "models/props_combine/combine_generator01.mdl", Vector(0.5, 1.25, 0.25), color = col },
    holo { Vector(-6, -30, -27), Angle(0, 180, 0), "models/props_combine/combine_generator01.mdl", Vector(0.5, 1.25, 0.25), color = col },
    holo { Vector(14, -30, -27), Angle(180, 180, 0), "models/props_combine/combine_generator01.mdl", Vector(0.5, 1.25, 0.25), color = col },
    holo { Vector(4, -30, -27), Angle(90, 180, 0), "models/props_combine/combine_generator01.mdl", Vector(0.5, 1.25, 0.25), color = col },
    holo { Vector(4, -30, -27), Angle(-90, 180, 0), "models/props_combine/combine_generator01.mdl", Vector(0.5, 1.25, 0.25), color = col },
    holo { Vector(4, -30, -37), Angle(90, 180, 0), "models/props_combine/combine_generator01.mdl", Vector(0.5, 1.25, 0.25), color = col },
    holo { Vector(4, -30, -17), Angle(-90, 180, 0), "models/props_combine/combine_generator01.mdl", Vector(0.5, 1.25, 0.25), color = col },
    holo { Vector(4, -105, -29), Angle(93, -90, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.025, 0.005, 0.2), noLight = true, color = col, material = "models/debug/debugwhite" },
    holo { Vector(4, -110, -34), Angle(90, -90, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.055, 0.005, 0.2), noLight = true, color = col, material = "models/debug/debugwhite" },
    holo { Vector(4, -105, -19), Angle(-93, -90, 180), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.025, 0.0025, 0.15), noLight = true, color = col, material = "models/debug/debugwhite" },
    holo { Vector(4, -115, -14), Angle(-90, -90, 180), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.055, 0.0025, 0.15), noLight = true, color = col, material = "models/debug/debugwhite" },
    holo { Vector(4, -80, -37), Angle(180, 0, 0), "models/props_combine/combine_train02a.mdl", Vector(0.075, 0.15, 0.05), color = col },
    holo { Vector(4, -80, -37), Angle(180, 180, 0), "models/props_combine/combine_train02a.mdl", Vector(0.075, 0.15, 0.05), color = col },
}
 
model.new("astrostriker", hitbox {
    vertex {"cube", Vector(0, 0, 0), Angle(0, 0, 0), Vector(75, 75, 45)},
    material = "Metal",
    mass = 1500,
})
    :add("body", body)
    :add("body", "rotor1", rotor1)
    :add("body", "rotor2", rotor2)
    :add("camera", rig(Vector(0, 0, 55)))
    :add("camera", "head", head)
    :add("body", "left_shoulder", leftShoulder)
    :add("left_shoulder", "left_forearm", blasterCluster(Vector(0, 75, 2), Angle(90, 0, 0)))
    :add("body", "right_shoulder", rightShoulder)
    :add("right_shoulder", "right_forearm", rightForearm)
    :addSequence("idle", 0, function(ent, layer)
        local body = ent:getBoneEntity(ent:lookupBone("body"))
        local head = ent:getBoneEntity(ent:lookupBone("head"))
        local rotor1 = ent:getBoneEntity(ent:lookupBone("rotor1"))
        local rotor2 = ent:getBoneEntity(ent:lookupBone("rotor2"))
        local rightShoulder = ent:getBoneEntity(ent:lookupBone("right_shoulder"))
        local rightForearm = ent:getBoneEntity(ent:lookupBone("right_forearm"))
        local leftShoulder = ent:getBoneEntity(ent:lookupBone("left_shoulder"))
        local leftForearm = ent:getBoneEntity(ent:lookupBone("left_forearm"))
        local _, rightShoulderAng = rightShoulder:getPropertyForLayer(layer)
        local _, rightForearmAng = rightForearm:getPropertyForLayer(layer)
        local _, leftShoulderAng = leftShoulder:getPropertyForLayer(layer)
        local _, leftForearmAng = leftForearm:getPropertyForLayer(layer)
        local _, bodyAng = body:getPropertyForLayer(layer)
        local _, headAng = head:getPropertyForLayer(layer)

        rightShoulder:setLocalAnglesLayer(layer + 1, tween.blenderRotation(100.272, -33.6441, 61.8868))
        rightForearm:setLocalAnglesLayer(layer + 1, tween.blenderRotation(-14.9618, -19.6032, -105.524))
        leftShoulder:setLocalAnglesLayer(layer + 2, tween.blenderRotation(100.272, 33.6441, -61.8868))
        leftForearm:setLocalAnglesLayer(layer + 2, tween.blenderRotation(-14.9618, 19.6032, 105.524))

        return tween.new {
            function(process)
                if !(isValid(rotor1) and isValid(rotor2)) then return true end
                local delta = timer.frametime()
                rotor1:setLocalAngles(rotor1:getLocalAngles() + Angle(0, 300 * delta, 0))
                rotor2:setLocalAngles(rotor2:getLocalAngles() + Angle(0, -150 * delta, 0))
                if process > 4 then return true end
            end,
            param { 0, 4, leftShoulder, circleProperty(2, nil, layer), nil, 1},
            param { 0, 2, leftShoulder, leftShoulderAng, Angle(-5, 0, 2), Angle(), math.easeInOutSine },
            param { 2, 4, leftShoulder, leftShoulderAng, Angle(), Angle(-5, 0, 2), math.easeInOutSine },

            param { 0, 2, leftForearm, leftForearmAng, Angle(0, 5, 0), Angle(), math.easeInOutSine },
            param { 2, 4, leftForearm, leftForearmAng, Angle(), Angle(0, 5, 0), math.easeInOutSine },

            param { 0, 4, rightShoulder, circleProperty(2, nil, layer), nil, 1},
            param { 0, 2, rightShoulder, rightShoulderAng, Angle(-5, 0, -2), Angle(), math.easeInOutSine },
            param { 2, 4, rightShoulder, rightShoulderAng, Angle(), Angle(-5, 0, -2), math.easeInOutSine },

            param { 0, 2, rightForearm, rightForearmAng, Angle(0, -5, 0), Angle(), math.easeInOutSine },
            param { 2, 4, rightForearm, rightForearmAng, Angle(), Angle(0, -5, 0), math.easeInOutSine },

            param { 0, 4, body, circleProperty(2, nil, layer), nil, 1},
            param { 0, 2, body, bodyAng, nil, Angle(2, 0, 0), math.easeInOutSine},
            param { 2, 4, body, bodyAng, nil, Angle(), math.easeInOutSine},

            param { 0, 4, head, circleProperty(1, 0.5, layer), nil, 1},
            param { 0, 2, head, headAng, nil, Angle(5, 0, 0), math.easeInOutSine},
            param { 2, 4, head, headAng, nil, Angle(), math.easeInOutSine},
        }
    end)
    :addSequence("blade1", 0.7, function(ent, layer)
        local body = ent:getBoneEntity(ent:lookupBone("body"))
        -- local head = ent:getBoneEntity(ent:lookupBone("head"))
        local shoulder = ent:getBoneEntity(ent:lookupBone("right_shoulder"))
        local forearm = ent:getBoneEntity(ent:lookupBone("right_forearm"))
        local _, shoulderAng = shoulder:getPropertyForLayer(layer)
        local _, forearmAng = forearm:getPropertyForLayer(layer)
        local _, bodyAng = body:getPropertyForLayer(layer)
        -- local _, headAng = head:getPropertyForLayer(layer)
        return tween.new {
            fcurveParam {0, 0.7083333333333334, body, bodyAng, "rotation_euler", {[1] = {{{-0.333333, 0}, {1, 0}, {2.33333, 0}}, {{-2.22649, -8.12077}, {5, -8.12077}, {6, -8.12077}}, {{5.44972, 5.56398e-07}, {8, 5.56398e-07}, {11.3669, 5.56398e-07}}, {{12.8752, 0}, {17, 0}, {19.3333, 0}}}, [2] = {{{-0.333333, 0}, {1, 0}, {2.33333, 0}}, {{-2.22649, -44.7113}, {5, -44.7113}, {6, -44.7113}}, {{5.44972, 70}, {8, 70}, {11.3669, 70}}, {{12.8752, 0}, {17, 0}, {19.3333, 0}}}, [3] = {{{-0.333333, 0}, {1, 0}, {2.33333, 0}}, {{-2.22649, 5.7326}, {5, 5.7326}, {6, 5.7326}}, {{5.44972, -4.35774}, {8, -4.35774}, {11.3669, -4.35774}}, {{12.8752, 0}, {17, 0}, {19.3333, 0}}}}},
            fcurveParam {0, 0.75, shoulder, shoulderAng, "rotation_euler", {[1] = {{{-0.666667, 100.272}, {1, 100.272}, {2.66667, 100.272}}, {{-2.3609, 107.769}, {6, 112.14}, {7.00037, 112.663}}, {{6.58257, 61.5141}, {9, 114.978}, {11.1768, 163.121}}, {{12.7781, 100.272}, {18, 100.272}, {20.3333, 100.272}}}, [2] = {{{-0.666667, -33.6441}, {1, -33.6441}, {2.66667, -33.6441}}, {{-2.36065, -33.3275}, {6, -32.5316}, {7.39784, -32.3985}}, {{7.82474, 29.9015}, {9, 83.8891}, {11.5316, 200.181}}, {{12.7781, -33.6441}, {18, -33.6441}, {20.3333, -33.6441}}}, [3] = {{{-0.666667, 61.8868}, {1, 61.8868}, {2.66667, 61.8868}}, {{-2.36064, -9.60895}, {6, -9.60895}, {7, -9.60895}}, {{6.53891, 5.85981}, {9, 18.4819}, {11.3798, 30.687}}, {{12.7781, 61.8868}, {18, 61.8868}, {20.3333, 61.8868}}}}},
            fcurveParam {0, 0.7083333333333334, forearm, forearmAng, "rotation_euler", {[1] = {{{-0.333333, -14.9618}, {1, -14.9618}, {2.33333, -14.9618}}, {{-2.1691, -30.2635}, {5, -30.2635}, {7.15122, -30.2635}}, {{6.99834, -20.6912}, {11, -20.6912}, {12.3333, -20.6912}}, {{15, -14.9618}, {17, -14.9618}, {19, -14.9618}}}, [2] = {{{-0.333333, -19.6032}, {1, -19.6032}, {2.33333, -19.6032}}, {{-2.1691, 0.451004}, {5, 0.451004}, {7.15122, 0.451004}}, {{6.99834, 2.76729}, {11, -0.891972}, {12.3338, -2.11169}}, {{15, -19.6032}, {17, -19.6032}, {19, -19.6032}}}, [3] = {{{-0.333333, -105.524}, {1, -105.524}, {2.33333, -105.524}}, {{-2.18522, -21.5637}, {5, -21.0174}, {11.2804, -20.5398}}, {{6.62145, -91.9931}, {11, -91.9931}, {12.3333, -91.9931}}, {{15, -105.524}, {17, -105.524}, {19, -105.524}}}}},
        }
    end)
