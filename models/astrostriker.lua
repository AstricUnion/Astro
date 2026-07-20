local tween = tween
local param = tween.param
local property = tween.ParamProperties

local model = model
local hitbox = model.hitbox
local vertex = model.vertex
local part = model.part
local holo = model.holo
local rig = model.rig

local function blasterCluster(offset, angle)
    local baseHolos = {

         { Vector(0, 153, 2), Angle(0, 180, 180), "models/props_combine/combine_train02b.mdl", Vector(0.1, 0.145, 0.05), color = Color(255, 40, 40) },
         { Vector(0, 153, 2), Angle(0, 0, 180), "models/props_combine/combine_train02b.mdl", Vector(0.1, 0.145, 0.05), color = Color(255, 40, 40) },
         { Vector(-12.5, 136, 17), Angle(0, 270, -90), "models/combine_dropship_container.mdl", Vector(0.285, 0.25, 0.1), color = Color(255, 40, 40) },
         { Vector(12.5, 136, 17), Angle(0, 270, 90), "models/combine_dropship_container.mdl", Vector(0.285, 0.25, 0.1), color = Color(255, 40, 40) },
         { Vector(0, 136, 4), Angle(0, 270, 0), "models/combine_dropship_container.mdl", Vector(0.285, 0.25, 0.1), color = Color(255, 40, 40) },
         { Vector(0, 136, 29), Angle(0, 270, 180), "models/combine_dropship_container.mdl", Vector(0.285, 0.25, 0.1), color = Color(255, 40, 40) },
         { Vector(0, 195, 17), Angle(90, 90, 0), "models/Items/combine_rifle_ammo01.mdl", Vector(2, 2, 2), color = Color(255, 40, 40) },
         { Vector(0, 210, 17), Angle(90, 90, 0), "models/props_phx/wheels/magnetic_large.mdl", Vector(0.2, 0.2, 0.75), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
         { Vector(0, 210, 17), Angle(90, 90, 0), "models/props_phx/wheels/magnetic_large.mdl", Vector(0.245, 0.245, 1.1), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
         { Vector(0, 221, 17), Angle(90, 90, 0), "models/mechanics/wheels/wheel_speed_72.mdl", Vector(0.15, 0.15, 0.1), color = Color(0, 0, 0), material = "models/gibs/metalgibs/metal_gibs" },
         { Vector(0, 221.5, 17), Angle(90, 90, 0), "models/hunter/tubes/circle2x2.mdl", Vector(0.15, 0.15, 0.1), noLight = true, color = Color(255, 0, 0), material = "models/effects/vortshield" },
         { Vector(0, 140, 17), Angle(0, 90, 0), "models/xqm/jetengine.mdl", Vector(0.5, 1, 1), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
         { Vector(0, 145, 17), Angle(0, 180, 90), "models/props_combine/combine_mine01.mdl", Vector(0.7, 0.7, 5.1), color = Color(255, 40, 40) },
         { Vector(0, 145, 17), Angle(-45, 180, 90), "models/props_combine/combine_mine01.mdl", Vector(0.7, 0.7, 5.1), color = Color(255, 40, 40) },
         { Vector(0, 145, 17), Angle(45, 180, 90), "models/props_combine/combine_mine01.mdl", Vector(0.7, 0.7, 5.1), color = Color(255, 40, 40) },
         { Vector(40, 95, 2.3), Angle(0, 5, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(185, 30, 30), material = "models/props_canal/metalwall005b" },
         { Vector(0, 135, 0), Angle(-22.5, 180, 90), "models/props_combine/combine_mine01.mdl", Vector(1.5, 1.5, 5.1), color = Color(255, 40, 40) },
    }

    local rigFun = rig(offset, angle)
    local part = 360 / 4

    return function()
        local rg = rigFun()
        if !rg then return end
        local baseAngle = rg:getAngles()
        for i = 0, 3 do
            local ang = i * part
            rg:setAngles(baseAngle + Angle(ang, 0, 0))
            for _, hl in ipairs(baseHolos) do
                local holoFun = holo { hl[1], hl[2], hl[3], hl[4], color = hl.color, material = hl.material, noLight = hl.noLight }
                local mdl = holoFun()
                if mdl then
                    mdl:setParent(rg)
                end
            end
        end
        return rg
    end
end


local chassisModel = part {
    rig(),
    holo { Vector(0, 75, -35), Angle(0, 90, 0), "models/props_combine/combine_bridge.mdl", Vector(0.4, 0.4, 0.25), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(0, -75, -35), Angle(0, -90, 0), "models/props_combine/combine_bridge.mdl", Vector(0.4, 0.4, 0.25), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(-75, 0, -35), Angle(0, 180, 0), "models/props_combine/combine_bridge.mdl", Vector(0.4, 0.4, 0.25), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(-50, 50, -35), Angle(0, 135, 0), "models/props_combine/combine_bridge.mdl", Vector(0.4, 0.4, 0.25), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(-50, -50, -35), Angle(0, -135, 0), "models/props_combine/combine_bridge.mdl", Vector(0.4, 0.4, 0.25), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(0, -70, 40), Angle(0, 0, -20), "models/props_combine/combine_train02b.mdl", Vector(0.4, 0.1, 0.15), color = Color(255, 40, 40) },
    holo { Vector(0, -70, 40), Angle(0, 180, 20), "models/props_combine/combine_train02b.mdl", Vector(0.4, 0.1, 0.15), color = Color(255, 40, 40) },
    holo { Vector(0, 70, 40), Angle(0, 0, 20), "models/props_combine/combine_train02b.mdl", Vector(0.4, 0.1, 0.15), color = Color(255, 40, 40) },
    holo { Vector(0, 70, 40), Angle(0, 180, -20), "models/props_combine/combine_train02b.mdl", Vector(0.4, 0.1, 0.15), color = Color(255, 40, 40) },
    holo { Vector(-25, -40, 28), Angle(0, 50, 0), "models/props_combine/combineinnerwallcluster1024_002a.mdl", Vector(0.1, 0.1, 0.045), color = Color(255, 40, 40) },
    holo { Vector(-25, 40, 28), Angle(0, -50, 0), "models/props_combine/combineinnerwallcluster1024_002a.mdl", Vector(0.1, 0.1, 0.045), color = Color(255, 40, 40) },
    holo { Vector(-25, -35, 28), Angle(0, 50, 0), "models/props_combine/combineinnerwallcluster1024_002a.mdl", Vector(0.09, 0.09, 0.045), color = Color(255, 40, 40) },
    holo { Vector(-25, 35, 28), Angle(0, -50, 0), "models/props_combine/combineinnerwallcluster1024_002a.mdl", Vector(0.09, 0.09, 0.045), color = Color(255, 40, 40) },
    holo { Vector(35, 35, -30), Angle(30, 45, 0), "models/props_combine/combine_barricade_med01a.mdl", Vector(0.125, 0.35, 0.35), color = Color(255, 40, 40) },
    holo { Vector(35, -35, -30), Angle(30, -45, 0), "models/props_combine/combine_barricade_med01a.mdl", Vector(0.125, 0.35, 0.35), color = Color(255, 40, 40) },
    holo { Vector(-35, 35, -30), Angle(30, 135, 0), "models/props_combine/combine_barricade_med01a.mdl", Vector(0.125, 0.35, 0.35), color = Color(255, 40, 40) },
    holo { Vector(-35, -35, -30), Angle(30, -135, 0), "models/props_combine/combine_barricade_med01a.mdl", Vector(0.125, 0.35, 0.35), color = Color(255, 40, 40) },
    holo { Vector(50, 0, -30), Angle(30, 0, 0), "models/props_combine/combine_barricade_med01a.mdl", Vector(0.125, 0.35, 0.35), color = Color(255, 40, 40) },
    holo { Vector(-50, 0, -30), Angle(30, 180, 0), "models/props_combine/combine_barricade_med01a.mdl", Vector(0.125, 0.35, 0.35), color = Color(255, 40, 40) },
    holo { Vector(0, 50, -30), Angle(30, 90, 0), "models/props_combine/combine_barricade_med01a.mdl", Vector(0.125, 0.35, 0.35), color = Color(255, 40, 40) },
    holo { Vector(0, -50, -30), Angle(30, -90, 0), "models/props_combine/combine_barricade_med01a.mdl", Vector(0.125, 0.35, 0.35), color = Color(255, 40, 40) },
    holo { Vector(0, -65, 42), Angle(160, -90, 0), "models/combine_dropship_container.mdl", Vector(0.15, 0.5, 0.25), color = Color(255, 40, 40) },
    holo { Vector(0, 65, 42), Angle(160, 90, 0), "models/combine_dropship_container.mdl", Vector(0.15, 0.5, 0.25), color = Color(255, 40, 40) },
    holo { nil, Angle(180, 0, 0), "models/mechanics/wheels/wheel_speed_72.mdl", Vector(1.5, 1.5, 0.5), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { nil, Angle(0, 90, 90), "models/props_wasteland/wheel02a.mdl", Vector(0.575, 0.5, 0.575), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(0, 0, -15), Angle(180, -75, 0), "models/mechanics/wheels/wheel_extruded_48.mdl", Vector(2.45, 2.45, 1.35), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(0, 0, -15), Angle(180, 0, 0), "models/mechanics/wheels/wheel_extruded_48.mdl", Vector(2.45, 2.45, 1.35), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(-45, -45, -15), Angle(-70, -135, 0), "models/combine_dropship_container.mdl", Vector(0.125, 0.15, 0.15), color = Color(255, 40, 40) },
    holo { Vector(-45, 45, -15), Angle(-70, 135, 0), "models/combine_dropship_container.mdl", Vector(0.125, 0.15, 0.15), color = Color(255, 40, 40) },
    holo { Vector(45, -45, -15), Angle(-70, -45, 0), "models/combine_dropship_container.mdl", Vector(0.125, 0.15, 0.15), color = Color(255, 40, 40) },
    holo { Vector(45, 45, -15), Angle(-70, 45, 0), "models/combine_dropship_container.mdl", Vector(0.125, 0.15, 0.15), color = Color(255, 40, 40) },
    holo { Vector(-60, 0, -25), Angle(155, 0, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.045, 0.025, 0.045), color = Color(255, 40, 40) },
    holo { Vector(60, 0, -25), Angle(155, 180, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.045, 0.025, 0.045), color = Color(255, 40, 40) },
    holo { Vector(0, 60, -25), Angle(155, -90, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.045, 0.025, 0.045), color = Color(255, 40, 40) },
    holo { Vector(0, -60, -25), Angle(155, 90, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.045, 0.025, 0.045), color = Color(255, 40, 40) },
}
 
local hubFrontModel = part {
    holo { Vector(0, 0, -30), Angle(90, 0, 0), "models/props_c17/pulleywheels_large01.mdl", Vector(1, 2, 2), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { nil, nil, "models/props_combine/combine_train02a.mdl", Vector(0.15, 0.175, 0.075), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { nil, Angle(0, 180, 0), "models/props_combine/combine_train02a.mdl", Vector(0.15, 0.175, 0.075), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { nil, Angle(0, 90, 0), "models/props_combine/combine_train02a.mdl", Vector(0.15, 0.175, 0.075), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { nil, Angle(0, -90, 0), "models/props_combine/combine_train02a.mdl", Vector(0.15, 0.175, 0.075), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(0, 0, 22), Angle(180, 0, 0), "models/props_phx/wheels/moped_tire.mdl", Vector(3.5, 3.5, 4), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(0, 0, -20), Angle(180, 0, 0), "models/hunter/tubes/tube2x2x025d.mdl", Vector(1.2, 1.2, 0.2), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(1.25, -1.25, -20), Angle(180, 0, 0), "models/hunter/tubes/tube2x2x025d.mdl", Vector(1.175, 1.175, 0.15), noLight = true, color = Color(255, 40, 40), material = "models/debug/debugwhite" },
    holo { Vector(0, 0, -20), Angle(180, 180, 0), "models/hunter/tubes/tube2x2x025d.mdl", Vector(1.2, 1.2, 0.2), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(-1.25, 1.25, -20), Angle(180, 180, 0), "models/hunter/tubes/tube2x2x025d.mdl", Vector(1.175, 1.175, 0.15), noLight = true, color = Color(255, 40, 40), material = "models/debug/debugwhite" },
    holo { Vector(0, 0, -4), Angle(0, 90, 180), "models/props_combine/combine_mine01.mdl", Vector(3.15, 3.15, 3.35), color = Color(255, 40, 40) },
    holo { nil, Angle(0, 90, 180), "models/Items/combine_rifle_ammo01.mdl", Vector(12.15, 12.15, 5.25), color = Color(255, 40, 40) },
}
 
local hubRearModel = part {
    holo { Vector(0, 0, -28), Angle(180, 0, 0), "models/hunter/tubes/tube2x2x025d.mdl", Vector(0.9, 0.9, 0.2), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(1.25, -1.25, -28), Angle(180, 0, 0), "models/hunter/tubes/tube2x2x025d.mdl", Vector(0.875, 0.875, 0.15), noLight = true, color = Color(255, 40, 40), material = "models/debug/debugwhite" },
    holo { Vector(0, 0, -28), Angle(180, 180, 0), "models/hunter/tubes/tube2x2x025d.mdl", Vector(0.9, 0.9, 0.2), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(-1.25, 1.25, -28), Angle(180, 180, 0), "models/hunter/tubes/tube2x2x025d.mdl", Vector(0.875, 0.875, 0.15), noLight = true, color = Color(255, 40, 40), material = "models/debug/debugwhite" },
    holo { Vector(0, 0, -20), Angle(90, 0, 0), "models/props_c17/pulleywheels_large01.mdl", Vector(1, 2.5, 2.5), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(0, 0, 11), Angle(180, 0, 0), "models/props_phx/wheels/moped_tire.mdl", Vector(3.75, 3.75, 2), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(0, 0, -15), Angle(0, 90, 180), "models/props_combine/combine_mine01.mdl", Vector(2.5, 2.5, 3.35), color = Color(255, 40, 40) },
    holo { Vector(45, 0, -1), Angle(0, -90, 0), "models/combine_apc_wheelcollision.mdl", Vector(0.25, 0.2, 0.1), color = Color(255, 40, 40) },
    holo { Vector(-45, 0, -1), Angle(0, 90, 0), "models/combine_apc_wheelcollision.mdl", Vector(0.25, 0.2, 0.1), color = Color(255, 40, 40) },
    holo { Vector(0, 45, -1), nil, "models/combine_apc_wheelcollision.mdl", Vector(0.25, 0.2, 0.1), color = Color(255, 40, 40) },
    holo { Vector(0, -45, -1), Angle(0, 180, 0), "models/combine_apc_wheelcollision.mdl", Vector(0.25, 0.2, 0.1), color = Color(255, 40, 40) },
    holo { Vector(-10, 0, -1), Angle(0, -90, 0), "models/combine_apc_wheelcollision.mdl", Vector(0.25, 0.2, 0.1), color = Color(255, 40, 40) },
    holo { Vector(10, 0, -1), Angle(0, 90, 0), "models/combine_apc_wheelcollision.mdl", Vector(0.25, 0.2, 0.1), color = Color(255, 40, 40) },
    holo { Vector(0, -10, -1), nil, "models/combine_apc_wheelcollision.mdl", Vector(0.25, 0.2, 0.1), color = Color(255, 40, 40) },
    holo { Vector(0, 10, -1), Angle(0, 180, 0), "models/combine_apc_wheelcollision.mdl", Vector(0.25, 0.2, 0.1), color = Color(255, 40, 40) },
}
 
local headModel = part {
    rig(Vector(0, 0, 55)),
    holo { Vector(1.68, 0, 54), Angle(-110, 0, 0), "models/props_combine/combine_booth_short01a.mdl", Vector(0.3528, 0.42, 0.294), color = Color(255, 40, 40) },
    holo { Vector(1.68, 0, 54), Angle(-110, 180, 0), "models/props_combine/combine_booth_short01a.mdl", Vector(0.3528, 0.42, 0.294), color = Color(255, 40, 40) },
    holo { Vector(16.8, 0, 50.25), Angle(0, 180, 180), "models/props_combine/combine_booth_short01a.mdl", Vector(0.672, 0.4368, 0.294), color = Color(255, 40, 40) },
    holo { Vector(16.8, 0, 34.5), Angle(90, 0, 0), "models/props_combine/combine_booth_short01a.mdl", Vector(0.168, 0.42, 0.084), color = Color(255, 40, 40) },
    holo { Vector(16.8, 15.12, 42), Angle(0, 90, 90), "models/props_combine/combine_booth_short01a.mdl", Vector(0.168, 0.168, 0.084), color = Color(255, 40, 40) },
    holo { Vector(16.8, -15.12, 42), Angle(180, 90, 90), "models/props_combine/combine_booth_short01a.mdl", Vector(0.168, 0.168, 0.084), color = Color(255, 40, 40) },
    holo { Vector(-16.8, 0, 69), Angle(180, 180, 0), "models/combine_dropship_container.mdl", Vector(0.21, 0.462, 0.168), color = Color(255, 40, 40) },
    holo { Vector(-16.8, 0, 43.5), nil, "models/combine_dropship_container.mdl", Vector(0.21, 0.462, 0.336), color = Color(255, 40, 40) },
    holo { Vector(-15.12, 0, 69), Angle(0, 90, 0), "models/props_combine/combine_train02b.mdl", Vector(0.336, 0.1512, 0.084), color = Color(255, 40, 40) },
    holo { Vector(-15.12, 20.16, 61.5), Angle(90, 90, 0), "models/props_combine/combine_train02b.mdl", Vector(0.084, 0.1512, 0.084), color = Color(255, 40, 40) },
    holo { Vector(-15.12, -20.16, 61.5), Angle(-90, 90, 0), "models/props_combine/combine_train02b.mdl", Vector(0.084, 0.1512, 0.084), color = Color(255, 40, 40) },
    holo { Vector(22, 0, 45), Angle(90, 0, 0), "models/holograms/hq_torus.mdl", Vector(2.1), noLight = true, color = Color(0, 0, 0) },
    holo { Vector(18, 0, 45), Angle(90, 0, 0), "models/holograms/hq_torus_thin.mdl", Vector(2.8), noLight = true, color = Color(255, 40, 40) },
    holo { Vector(0, 0, 45), nil, "models/holograms/hq_sphere.mdl", Vector(4.125), noLight = true, color = Color(0, 0, 0), material = "models/debug/debugwhite" },
    holo { Vector(15.05, 0, 45), Angle(90, 0, 0), "models/holograms/hq_sphere.mdl", Vector(2.9, 2.9, 1.75), noLight = true, color = Color(255, 40, 40), material = "models/props_lab/cornerunit_cloud" },
    holo { Vector(16.5, 0, 45), Angle(90, 0, 0), "models/holograms/hq_sphere.mdl", Vector(2.5, 2.5, 1.75), noLight = true, color = Color(255, 40, 40) },
    holo { Vector(22.45, 0, 45), Angle(90, 0, 0), "models/holograms/hq_sphere.mdl", Vector(1.7, 0.96, 0.85), noLight = true, color = Color(0, 0, 0) },
    holo { Vector(23.35, 0, 45), Angle(90, 0, 0), "models/holograms/hq_sphere.mdl", Vector(1.5, 0.5, 0.75), noLight = true, color = Color(255, 255, 255) },
}
 
local larmModel = part {
    rig(Vector(0, 75, 25)),
    
    holo { Vector(-30, 60, 24), Angle(180, 0, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(185, 30, 30), },
    holo { Vector(30, 60, 24), Angle(0, 0, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(165, 20, 20) },
    holo { Vector(0, 60, 54), Angle(-90, 0, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(165, 20, 20) },
    holo { Vector(0, 60, 0), Angle(90, 0, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(165, 20, 20) },
    holo { Vector(30, 200, 24), Angle(180, 180, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(185, 30, 30), },
    holo { Vector(-30, 200, 24), Angle(0, 180, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(165, 20, 20) },
    holo { Vector(0, 200, 54), Angle(-90, 180, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(165, 20, 20) },
    holo { Vector(0, 200, 0), Angle(90, 180, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(165, 20, 20) },
    holo { Vector(0, 125, 27), nil, "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.175, 0.125), color = Color(255, 40, 40) },
    holo { Vector(0, 125, 27), Angle(180, 0, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.175, 0.125), color = Color(255, 40, 40) },
    holo { Vector(0, 125, 27), Angle(-90, 0, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.175, 0.125), color = Color(255, 40, 40) },
    holo { Vector(0, 125, 27), Angle(90, 0, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.175, 0.125), color = Color(255, 40, 40) },
    holo { Vector(0, 125, 27), Angle(0, 180, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.175, 0.125), color = Color(255, 40, 40) },
    holo { Vector(0, 125, 27), Angle(180, 180, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.175, 0.125), color = Color(255, 40, 40) },
    holo { Vector(0, 125, 27), Angle(-90, 180, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.175, 0.125), color = Color(255, 40, 40) },
    holo { Vector(0, 125, 27), Angle(90, 180, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.175, 0.125), color = Color(255, 40, 40) },
    holo { Vector(17, 100, 45), Angle(180, 90, -45), "models/combine_dropship_container.mdl", Vector(0.35, 0.15, 0.1), color = Color(255, 40, 40) },
    holo { Vector(-17, 100, 45), Angle(180, 90, 45), "models/combine_dropship_container.mdl", Vector(0.35, 0.15, 0.1), color = Color(255, 40, 40) },
    holo { Vector(17, 100, 10), Angle(180, 90, -135), "models/combine_dropship_container.mdl", Vector(0.35, 0.15, 0.1), color = Color(255, 40, 40) },
    holo { Vector(-17, 100, 10), Angle(180, 90, 135), "models/combine_dropship_container.mdl", Vector(0.35, 0.15, 0.1), color = Color(255, 40, 40) },
    holo { Vector(18, 89, 27), Angle(0, 0, -90), "models/props_combine/combine_barricade_med01b.mdl", Vector(0.15, 0.25, 0.575), color = Color(255, 40, 40) },
    holo { Vector(-18, 89, 27), Angle(180, 0, -90), "models/props_combine/combine_barricade_med01b.mdl", Vector(0.15, 0.25, 0.575), color = Color(255, 40, 40) },
    holo { Vector(0, 89, 45), Angle(-90, -90, 0), "models/props_combine/combine_barricade_med01b.mdl", Vector(0.15, 0.25, 0.575), color = Color(255, 40, 40) },
    holo { Vector(0, 89, 9), Angle(90, 90, 0), "models/props_combine/combine_barricade_med01b.mdl", Vector(0.15, 0.25, 0.575), color = Color(255, 40, 40) },
}
 
local rarmModel = part {
    rig(Vector(0, -75, 25)),
    holo { Vector(-30, -200, 24), Angle(180, 0, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(185, 30, 30), },
    holo { Vector(30, -200, 24), Angle(0, 0, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(165, 20, 20) },
    holo { Vector(0, -200, 54), Angle(-90, 0, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(165, 20, 20) },
    holo { Vector(0, -200, 0), Angle(90, 0, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(165, 20, 20) },
    holo { Vector(30, -60, 24), Angle(180, 180, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(185, 30, 30), },
    holo { Vector(-30, -60, 24), Angle(0, 180, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(165, 20, 20) },
    holo { Vector(0, -60, 54), Angle(-90, 180, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(165, 20, 20) },
    holo { Vector(0, -60, 0), Angle(90, 180, -90), "models/props_combine/combine_bridge.mdl", Vector(0.1, 0.15, 0.3), color = Color(165, 20, 20) },
    holo { Vector(0, -125, 27), nil, "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.175, 0.125), color = Color(255, 40, 40) },
    holo { Vector(0, -125, 27), Angle(180, 0, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.175, 0.125), color = Color(255, 40, 40) },
    holo { Vector(0, -125, 27), Angle(-90, 0, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.175, 0.125), color = Color(255, 40, 40) },
    holo { Vector(0, -125, 27), Angle(90, 0, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.175, 0.125), color = Color(255, 40, 40) },
    holo { Vector(0, -125, 27), Angle(0, 180, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.175, 0.125), color = Color(255, 40, 40) },
    holo { Vector(0, -125, 27), Angle(180, 180, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.175, 0.125), color = Color(255, 40, 40) },
    holo { Vector(0, -125, 27), Angle(-90, 180, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.175, 0.125), color = Color(255, 40, 40) },
    holo { Vector(0, -125, 27), Angle(90, 180, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.175, 0.125), color = Color(255, 40, 40) },
    holo { Vector(17, -100, 45), Angle(180, -90, 45), "models/combine_dropship_container.mdl", Vector(0.35, 0.15, 0.1), color = Color(255, 40, 40) },
    holo { Vector(-17, -100, 45), Angle(180, -90, -45), "models/combine_dropship_container.mdl", Vector(0.35, 0.15, 0.1), color = Color(255, 40, 40) },
    holo { Vector(17, -100, 10), Angle(180, -90, 135), "models/combine_dropship_container.mdl", Vector(0.35, 0.15, 0.1), color = Color(255, 40, 40) },
    holo { Vector(-17, -100, 10), Angle(180, -90, -135), "models/combine_dropship_container.mdl", Vector(0.35, 0.15, 0.1), color = Color(255, 40, 40) },
    holo { Vector(18, -89, 27), Angle(0, 0, 90), "models/props_combine/combine_barricade_med01b.mdl", Vector(0.15, 0.25, 0.575), color = Color(255, 40, 40) },
    holo { Vector(-18, -89, 27), Angle(180, 0, 90), "models/props_combine/combine_barricade_med01b.mdl", Vector(0.15, 0.25, 0.575), color = Color(255, 40, 40) },
    holo { Vector(0, -89, 45), Angle(-90, -90, 180), "models/props_combine/combine_barricade_med01b.mdl", Vector(0.15, 0.25, 0.575), color = Color(255, 40, 40) },
    holo { Vector(0, -89, 9), Angle(90, 90, 180), "models/props_combine/combine_barricade_med01b.mdl", Vector(0.15, 0.25, 0.575), color = Color(255, 40, 40) },
}
 
local rarmPodModel = part {
    rig(Vector(-4, -80, 2)),
    holo { Vector(0, -105, -10), nil, "models/props_rooftop/dome004.mdl", Vector(0.215, 0.215, 0.215), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(0, -104.5, -25), Angle(0, 0, -90), "models/props_rooftop/dome005.mdl", Vector(0.105, 0.105, 0.15), color = Color(255, 40, 40), material = "models/gibs/metalgibs/metal_gibs" },
    holo { Vector(0, -55, -42), Angle(90, 90, 180), "models/props_combine/combine_barricade_med01b.mdl", Vector(0.15, 0.25, 0.5), color = Color(255, 40, 40) },
    holo { Vector(0, -80, -25), Angle(180, 180, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.15, 0.175), color = Color(255, 40, 40) },
    holo { Vector(0, -80, -25), Angle(180, 0, 0), "models/props_combine/combine_train02b.mdl", Vector(0.35, 0.15, 0.175), color = Color(255, 40, 40) },
    holo { Vector(0, -94.5, -27), Angle(0, -90, 0), "models/combine_dropship_container_static.mdl", Vector(0.25, 0.4, 0.35), color = Color(255, 40, 40) },
    holo { Vector(0, -130, -25), Angle(0, 180, 0), "models/props_combine/combine_generator01.mdl", Vector(0.5, 1.25, 0.25), color = Color(255, 40, 40) },
    holo { Vector(0, -130, -25), Angle(180, 180, 0), "models/props_combine/combine_generator01.mdl", Vector(0.5, 1.25, 0.25), color = Color(255, 40, 40) },
    holo { Vector(-10, -130, -25), Angle(0, 180, 0), "models/props_combine/combine_generator01.mdl", Vector(0.5, 1.25, 0.25), color = Color(255, 40, 40) },
    holo { Vector(10, -130, -25), Angle(180, 180, 0), "models/props_combine/combine_generator01.mdl", Vector(0.5, 1.25, 0.25), color = Color(255, 40, 40) },
    holo { Vector(0, -130, -25), Angle(90, 180, 0), "models/props_combine/combine_generator01.mdl", Vector(0.5, 1.25, 0.25), color = Color(255, 40, 40) },
    holo { Vector(0, -130, -25), Angle(-90, 180, 0), "models/props_combine/combine_generator01.mdl", Vector(0.5, 1.25, 0.25), color = Color(255, 40, 40) },
    holo { Vector(0, -130, -35), Angle(90, 180, 0), "models/props_combine/combine_generator01.mdl", Vector(0.5, 1.25, 0.25), color = Color(255, 40, 40) },
    holo { Vector(0, -130, -15), Angle(-90, 180, 0), "models/props_combine/combine_generator01.mdl", Vector(0.5, 1.25, 0.25), color = Color(255, 40, 40) },
    holo { Vector(0, -205, -27), Angle(93, -90, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.025, 0.005, 0.2), noLight = true, color = Color(255, 40, 40), material = "models/debug/debugwhite" },
    holo { Vector(0, -210, -32), Angle(90, -90, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.055, 0.005, 0.2), noLight = true, color = Color(255, 40, 40), material = "models/debug/debugwhite" },
    holo { Vector(0, -205, -17), Angle(-93, -90, 180), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.025, 0.0025, 0.15), noLight = true, color = Color(255, 40, 40), material = "models/debug/debugwhite" },
    holo { Vector(0, -215, -12), Angle(-90, -90, 180), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.055, 0.0025, 0.15), noLight = true, color = Color(255, 40, 40), material = "models/debug/debugwhite" },
    holo { Vector(0, -180, -35), Angle(180, 0, 0), "models/props_combine/combine_train02a.mdl", Vector(0.075, 0.15, 0.05), color = Color(255, 40, 40) },
    holo { Vector(0, -180, -35), Angle(180, 180, 0), "models/props_combine/combine_train02a.mdl", Vector(0.075, 0.15, 0.05), color = Color(255, 40, 40) },
}
 
model.new("astrostriker", hitbox {
    vertex {"cube", Vector(0, 0, 0), Angle(0, 0, 0), Vector(75, 75, 45)},
    material = "Metal",
    mass = 1500,
})
    :add("chassis", chassisModel)
    :add("chassis", "hub_front", hubFrontModel)
    :add("chassis", "hub_rear", hubRearModel)
    :add("chassis", "head", headModel)
    :add("chassis", "larm", larmModel)
    :add("larm", "blaster1", blasterCluster(Vector(0, 175, 2), Angle(0, 0, 0)))
    :add("chassis", "rarm", rarmModel)
    :add("rarm", "rarm_pod", rarmPodModel)
    :addSequence("idle", 0, function(ent)
        if ent.tween then tween.stop(ent.tween) end
 
        local hubFront = ent:getBoneEntity(ent:lookupBone("hub_front"))
        local hubRear = ent:getBoneEntity(ent:lookupBone("hub_rear"))
 
        ent.tween = tween.start(tween.new {
            function(process)
                if !(isValid(hubFront) and isValid(hubRear)) then return true end
                local delta = game.serverFrameTime()
                hubFront:setLocalAngles(hubFront:getLocalAngles() + Angle(0, 36, 0))
                hubRear:setLocalAngles(hubRear:getLocalAngles() + Angle(0, -18, 0))
            end
        }, true)
    end)