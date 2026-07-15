---@class tween
local tween = tween
local param = tween.param
local fcurveParam = tween.fcurveParam
local property = tween.ParamProperties

---@class model
local model = model
local hitbox = model.hitbox
local vertex = model.vertex
local part = model.part
local holo = model.holo
local rig = model.rig

local mainColor = Color(255, 40, 40)
local metalMat = "models/props_combine/metal_combinebridge001"
local whiteMat = "models/debug/debugwhite"

local function prongs()
    local rigFun = rig()
    local holoFun = holo { Vector(0, 110, 56), Angle(-50, 90, 180), "models/props_combine/combine_bridge.mdl", Vector(0.14, 0.04, 0.08), color = mainColor, material = metalMat }
    local part = 360 / 3
    return function()
        local rg = rigFun()
        if !rg then return end
        for i=0, 3 do
            local ang = i * part
            local mdl = holoFun()
            if !mdl then goto cont end
            mdl:setParent(rg)
            rg:setAngles(Angle(ang, 0, 0))
            ::cont::
        end
        return rg
    end
end

model.new("astroscout", part {
    hitbox {
        vertex {"cylinder", Vector(0, 0, 8), nil, Vector(86, 86, 18)},
        vertex {"cylinder", Vector(0, 0, -24), nil, Vector(36, 36, 12)},
        vertex {"cube", Vector(0, 0, 68), nil, Vector(30, 28, 28)},
        material = "Metal",
        mass = 1000,
        visible = false
    },
})
    :add("body", part {
        part {
            rig (),
            holo { Vector(0, 0, 19), Angle(0, 0, 90), "models/props_wasteland/wheel03a.mdl", Vector(0.65, 0.2, 0.65), color = mainColor },
            holo { Vector(0, 0, 0), Angle(0, 0, 90), "models/props_wasteland/wheel03a.mdl", Vector(0.65, 0.2, 0.65), color = mainColor },
            holo { Vector(0, 0, 8), nil, "models/props_phx/construct/metal_angle360.mdl", Vector(1.3, 1.3, 3), color = mainColor },
            holo { Vector(-60, 0, 40), nil, "models/props_combine/combineinnerwallcluster1024_002a.mdl", Vector(0.09, 0.09, 0.09), color = mainColor },
            holo { Vector(-34, -60, 20), Angle(0, 40, 0), "models/props_combine/combineinnerwall001a.mdl", Vector(0.1, 0.2, 0.05), color = mainColor },
            holo { Vector(-34, 60, 20), Angle(0, -40, 0), "models/props_combine/combineinnerwall001a.mdl", Vector(0.1, 0.2, 0.05), color = mainColor },
            holo { Vector(46, 70, 10), Angle(180, 225, -90), "models/combine_wall.mdl", Vector(0.06, 0.08, 0.05), color = mainColor },
            holo { Vector(46, -70, 10), Angle(180, -225, 90), "models/combine_wall.mdl", Vector(0.06, 0.08, 0.05), color = mainColor },
            holo { Vector(30, -72, 0), Angle(0, -90, 0), "models/props_combine/combine_barricade_med03b.mdl", Vector(0.3, 0.3, 0.25), color = mainColor },
            holo { Vector(30, 72, 0), Angle(0, 90, 0), "models/props_combine/combine_barricade_med04b.mdl", Vector(0.3, 0.3, 0.25), color = mainColor },
            holo { Vector(70, 0, -6), nil, "models/props_combine/combine_barricade_tall02b.mdl", Vector(0.4, 0.4, 0.15), color = mainColor },
            holo { Vector(-10, 0, -19), Angle(50, 180, 180), "models/props_combine/combineinnerwallcluster1024_003a.mdl", Vector(0.07, 0.07, 0.06), color = mainColor },
            holo { Vector(10, 0, -19), Angle(130, -180, 0), "models/props_combine/combineinnerwallcluster1024_003a.mdl", Vector(0.07, 0.07, 0.06), color = mainColor },
            holo { Vector(-66, -20, 12), Angle(180, 30, 90), "models/props_combine/combine_barricade_tall01a.mdl", Vector(0.4), color = mainColor },
            holo { Vector(-66, 20, 12), Angle(180, -30, 270), "models/props_combine/combine_barricade_tall01a.mdl", Vector(0.4), color = mainColor },
            holo { Vector(-70, 0, 4), Angle(0, 180, 0), "models/props_combine/combine_barricade_med01a.mdl", Vector(0.4, 0.6, 0.35), color = mainColor },
        },
        part {
            rig (),
            holo { Vector(0, 0, 10), Angle(0, 0, 90), "models/props_wasteland/wheel02b.mdl", color = mainColor },
            holo { Vector(30, 0, 15), Angle(5, -5, -45), "models/Gibs/helicopter_brokenpiece_03.mdl", color = mainColor },
            holo { Vector(22, -22, 15), Angle(5, -50, -45), "models/Gibs/helicopter_brokenpiece_03.mdl", color = mainColor },
            holo { Vector(-30, 0, 15), Angle(5, -185, -45), "models/Gibs/helicopter_brokenpiece_03.mdl", color = mainColor },
            holo { Vector(-22, -22, 15), Angle(5, -140, -45), "models/Gibs/helicopter_brokenpiece_03.mdl", color = mainColor },
            holo { Vector(0, -30, 15), Angle(5, -95, -45), "models/Gibs/helicopter_brokenpiece_03.mdl", color = mainColor },
            holo { Vector(-22, 22, 15), Angle(5, 130, -45), "models/Gibs/helicopter_brokenpiece_03.mdl", color = mainColor },
            holo { Vector(0, 30, 15), Angle(5, 85, -45), "models/Gibs/helicopter_brokenpiece_03.mdl", color = mainColor },
            holo { Vector(22, 22, 15), Angle(5, 40, -45), "models/Gibs/helicopter_brokenpiece_03.mdl", color = mainColor },
        }
    })
    :add("camera", rig(Vector(0, 0, 68)))
    :add("camera", "head", part {
        rig (),
        holo { nil, nil, "models/hunter/misc/sphere075x075.mdl", Vector(1.4, 1.4, 1.4), noLight = true, color = Color(0, 0, 0), material = whiteMat },
        holo { Vector(14, 0, 0), nil, "models/hunter/misc/sphere075x075.mdl", Vector(0.6, 1.1, 1.1), noLight = true, color = mainColor, material = whiteMat },
        holo { Vector(20.2, 0, -1), nil, "models/hunter/misc/sphere075x075.mdl", Vector(0.3, 0.3, 0.9), noLight = true, material = whiteMat },
        holo { Vector(-22, 0, 2), Angle(-100, 180, 0), "models/props_combine/combine_booth_short01a.mdl", Vector(0.4, 0.45, 0.5), color = mainColor },
        holo { Vector(-4, 0, -4), Angle(45, 180, 0), "models/props_combine/combine_booth_short01a.mdl", Vector(0.3, 0.45, 0.4), color = mainColor },
        holo { Vector(0, -35, -16), Angle(20, -12, 0), "models/props_combine/headcrabcannister01a.mdl", Vector(0.4, 0.5, 0.5), color = mainColor },
        holo { Vector(0, 35, -16), Angle(20, 12, 0), "models/props_combine/headcrabcannister01a.mdl", Vector(0.4, 0.5, 0.5), color = mainColor },
        holo { Vector(0, -35, 12), Angle(0, -12, 0), "models/props_combine/headcrabcannister01a.mdl", Vector(0.4, 0.5, 0.5), color = mainColor },
        holo { Vector(0, 35, 12), Angle(0, 12, 0), "models/props_combine/headcrabcannister01a.mdl", Vector(0.4, 0.5, 0.5), color = mainColor },
        holo { Vector(0, -30, -4), Angle(0, 0, 90), "models/props_combine/combine_emitter01.mdl", Vector(1, 2, 1.2), color = mainColor },
        holo { Vector(0, 30, -4), Angle(0, 0, -90), "models/props_combine/combine_emitter01.mdl", Vector(1, 2, 1.2), color = mainColor },
    })
    :add("body", "right_shoulder", part {
        rig (Vector(-3, -85, 26)),
        holo { Vector(-3, -110, 7), Angle(0, 90, 0), "models/props_combine/CombineTrain01a.mdl", Vector(0.18, 0.3, 0.12), color = mainColor },
        holo { Vector(-3, -130, 32), Angle(-90, 90, 0), "models/props_combine/combineinnerwallcluster1024_003a.mdl", Vector(0.08, 0.06, 0.10), color = mainColor },
        holo { Vector(-3, -69, 30), Angle(220, 270, 180), "models/props_combine/combine_barricade_med02a.mdl", Vector(0.4, 0.4, 0.4), color = mainColor },
    })
    :add("right_shoulder", "right_forearm", part {
        rig ( Vector(0, -85, 0) ),
        holo { Vector(0, -115, -17), Angle(0, 90, 0), "models/props_combine/CombineTrain01a.mdl", Vector(0.16, 0.26, 0.10), color = mainColor },
        holo { Vector(0, -135, -2), Angle(-90, 90, 0), "models/props_combine/combineinnerwallcluster1024_003a.mdl", Vector(0.06, 0.04, 0.08), color = mainColor },
        holo { Vector(0, -115, 14), Angle(-105, -90, 180), "models/props_combine/tprotato2.mdl", Vector(0.8, 0.8, 0.8), color = mainColor },
        holo { Vector(0, -105, -2), Angle(270, 90, 0), "models/props_combine/combine_mortar01b.mdl", Vector(1.2), color = mainColor },
    })
    :add("right_forearm", "right_hand", part {
        rig ( Vector(0, -83, -2) ),
        holo { Vector(0, -90, -2), Angle(280, 90, 0), "models/props_combine/combine_booth_short01a.mdl", Vector(0.2, 0.34, 0.4), color = mainColor, material = metalMat },
        holo { Vector(0, -90, -2), Angle(-260, 90, 180), "models/props_combine/combine_booth_short01a.mdl", Vector(0.2, 0.34, 0.4), color = mainColor, material = metalMat },
        holo { Vector(-13, -135, -4), Angle(10, 90, 0), "models/props_combine/breenlight.mdl", Vector(2.8, 2.8, 2), color = mainColor, material = metalMat },
        holo { Vector(0, -135, -4), Angle(10, 90, 0), "models/props_combine/breenlight.mdl", Vector(2.8, 2.8, 2), color = mainColor, material = metalMat },
        holo { Vector(14, -135, -4), Angle(10, 90, 0), "models/props_combine/breenlight.mdl", Vector(2.8, 2.8, 2), color = mainColor, material = metalMat },
        holo { Vector(-13, -125, -22), Angle(80, 90, 0), "models/props_combine/breenlight.mdl", Vector(2.8, 2.8, 1.6), color = mainColor, material = metalMat },
        holo { Vector(0, -125, -22), Angle(80, 90, 0), "models/props_combine/breenlight.mdl", Vector(2.8, 2.8, 1.6), color = mainColor, material = metalMat },
        holo { Vector(14, -125, -22), Angle(80, 90, 0), "models/props_combine/breenlight.mdl", Vector(2.8, 2.8, 1.6), color = mainColor, material = metalMat },
        holo { Vector(33, -100, -2), Angle(0, 20, -70), "models/props_combine/breenlight.mdl", Vector(2.8, 2.8, 2), color = mainColor, material = metalMat },
        holo { Vector(33, -125, -8), Angle(0, -25, -90), "models/props_combine/breenlight.mdl", Vector(2.8, 2.8, 1.5), color = mainColor, material = metalMat },
    })
    :add("right_hand", "claws", part {
        rig ( Vector(0, 0, 30), Angle(0, -90, 0) ),
        holo { Vector(-2, 0, 26), Angle(-90, 90, 0), "models/props_combine/combineinnerwall001a.mdl", Vector(0.06, 0.1, 0.09), color = mainColor },
        holo {Vector(-8, 0, 26), Angle(-90, 90, 0), "models/props_combine/combineinnerwall001a.mdl", Vector(0.06, 0.1, 0.09), color = mainColor },
        holo { Vector(-9.1, -25, 31), Angle(-90, 90, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.04, 0.005, 0.125), noLight = true, color = mainColor, material = whiteMat },
        holo { Vector(-9.1, -68.1, 34), Angle(-55, -90, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.03, 0.005, 0.025), noLight = true, color = mainColor, material = whiteMat },
        holo { Vector(-9.1, -48.1, 34.2), Angle(-55, -90, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.03, 0.005, 0.025), noLight = true, color = mainColor, material = whiteMat },
        holo { Vector(-9.1, -28.1, 34.2), Angle(-55, -90, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.03, 0.005, 0.025), noLight = true, color = mainColor, material = whiteMat },
        holo { Vector(-9.1, -8.1, 34.2), Angle(-55, -90, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.03, 0.005, 0.025), noLight = true, color = mainColor, material = whiteMat },
        holo { Vector(-9.1, 28.1, 34.2), Angle(-55, -90, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.03, 0.005, 0.025), noLight = true, color = mainColor, material = whiteMat },
        holo { Vector(2, 0, 26), Angle(-90, 90, 0), "models/props_combine/combineinnerwall001a.mdl", Vector(0.06, 0.17, 0.09), color = mainColor },
        holo { Vector(4, -25, 31), Angle(-90, 90, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.04, 0.005, 0.125), noLight = true, color = mainColor, material = whiteMat },
        holo { Vector(4, -68.1, 34), Angle(-55, -90, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.03, 0.005, 0.025), noLight = true, color = mainColor, material = whiteMat },
        holo { Vector(4, -48.1, 34.2), Angle(-55, -90, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.03, 0.005, 0.025), noLight = true, color = mainColor, material = whiteMat },
        holo { Vector(4, -28.1, 34.2), Angle(-55, -90, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.03, 0.005, 0.025), noLight = true, color = mainColor, material = whiteMat },
        holo { Vector(4, -8.1, 34.2), Angle(-55, -90, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.03, 0.005, 0.025), noLight = true, color = mainColor, material = whiteMat },
        holo { Vector(4, 28.1, 34.2), Angle(-55, -90, 0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(0.03, 0.005, 0.025), noLight = true, color = mainColor, material = whiteMat },
    })
    :add("body", "left_shoulder", part { -- right shoulder
        rig( Vector(-3, 85, 26) ),
        holo { Vector(-3, 110, 7), Angle(0, -90, 0), "models/props_combine/CombineTrain01a.mdl", Vector(0.18, 0.3, 0.12), color = mainColor },
        holo { Vector(-3, 130, 32), Angle(-90, -90, 0), "models/props_combine/combineinnerwallcluster1024_003a.mdl", Vector(0.08, 0.06, 0.10), color = mainColor },
        holo { Vector(-3, 69, 30), Angle(220, -270, 180), "models/props_combine/combine_barricade_med02a.mdl", Vector(0.4, 0.4, 0.4), color = mainColor },
    })
    :add("left_shoulder", "left_forearm", part { -- laser base
        rig ( Vector(0, 85, 0), Angle() ),
        holo { Vector(0, 85, -2), Angle(90, 90, 0), "models/props_combine/combine_mine01.mdl", Vector(2, 2, 3), color = mainColor, material = metalMat },
        holo { Vector(0, 185, -2), Angle(-90, 90, 0), "models/props_combine/combine_mine01.mdl", Vector(1.8, 1.8, 2), color = mainColor, material = metalMat },
        holo { Vector(0, 90, 16), Angle(90, 90, 0), "models/props_combine/combine_light002a.mdl", Vector(0.75, 1, 2), color = mainColor, material = metalMat },
        holo { Vector(0, 90, -19.5), Angle(-90, 90, 180), "models/props_combine/combine_light002a.mdl", Vector(0.75, 1, 2), color = mainColor, material = metalMat },
        holo { Vector(18, 90, -2), Angle(180, 0, -90), "models/props_combine/combine_light002a.mdl", Vector(0.75, 1, 2), color = mainColor, material = metalMat },
        holo { Vector(-18, 90, -2), Angle(0, 0, -90), "models/props_combine/combine_light002a.mdl", Vector(0.75, 1, 2), color = mainColor, material = metalMat },
        holo { Vector(0, 180, -2), Angle(0, 90, 0), "models/props_silo/ventilationduct02large.mdl", Vector(0.4, 0.8, 0.8), color = mainColor, material = metalMat },
        holo { Vector(0, 190, -2), Angle(90, 90, 0), "models/hunter/tubes/circle2x2.mdl", Vector(0.3, 0.3, 1), noLight = true, color = mainColor, material = whiteMat },
        holo { Vector(0, 194, -2), Angle(90, 90, 0), "models/hunter/tubes/circle2x2.mdl", Vector(0.2, 0.2, 1), noLight = true, color = mainColor, material = whiteMat },
    })
    :add("left_forearm", "tube", part { -- inner tube 
        rig ( Vector(0, 38, -2), Angle() ),
        holo { Vector(0, 80, -2), Angle(0, 0, 90), "models/hunter/tubes/tube1x1x2.mdl", Vector(0.55, 0.55, 0.6), noLight = true, color = mainColor, material = whiteMat },
        holo { Vector(0, 50, 13), Angle(270, 90, 0), "models/props_combine/breenlight.mdl", Vector(1, 1.6, 4), color = mainColor, material = metalMat },
        holo { Vector(0, 50, -17), Angle(90, 90, 180), "models/props_combine/breenlight.mdl", Vector(1, 1.6, 4), color = mainColor, material = metalMat },
        holo { Vector(15, 50, -2), Angle(0, 0, 90), "models/props_combine/breenlight.mdl", Vector(1, 1.6, 4), color = mainColor, material = metalMat },
        holo { Vector(-15, 50, -2), Angle(180, 0, 90), "models/props_combine/breenlight.mdl", Vector(1, 1.6, 4), color = mainColor, material = metalMat },
        holo { Vector(9, 50, 7), Angle(315, 0, 90), "models/props_combine/breenlight.mdl", Vector(1, 1.6, 4), color = mainColor, material = metalMat },
        holo { Vector(-9, 50, 7), Angle(225, 0, 90), "models/props_combine/breenlight.mdl", Vector(1, 1.6, 4), color = mainColor, material = metalMat },
        holo { Vector(-9, 50, -11), Angle(135, 0, 90), "models/props_combine/breenlight.mdl", Vector(1, 1.6, 4), color = mainColor, material = metalMat },
        holo { Vector(9, 50, -11), Angle(45, 0, 90), "models/props_combine/breenlight.mdl", Vector(1, 1.6, 4), color = mainColor, material = metalMat },
    })
    :add("left_forearm", "prongs", part {
       rig ( Vector(0, 80, 0), Angle() ),
       prongs ()
    })

