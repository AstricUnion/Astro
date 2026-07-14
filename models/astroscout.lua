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

-- local function circlePos(ang, radius, pos)
--     local rad = math.rad(ang)
--     return Vector(math.sin(rad)*radius, 0, math.cos(rad)*radius)+pos
-- end


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


model.new("astroscout_rightarm", hitbox {
    vertex {"cube", Vector(0, 0, 8), nil, Vector(56, 36, 56)},
    material = "Metal",
    mass = 300,
})
    :add("module", rig(nil, Angle(0, 0, 0)))
    :add("module", "shoulder", part {
        rig (),
        holo { Vector(0, -25, -19), Angle(0, 90, 0), "models/props_combine/CombineTrain01a.mdl", Vector(0.18, 0.3, 0.12), color = mainColor },
        holo { Vector(0, -45, 6), Angle(-90, 90, 0), "models/props_combine/combineinnerwallcluster1024_003a.mdl", Vector(0.08, 0.06, 0.10), color = mainColor },
        holo { Vector(0, 16, 4), Angle(220, 270, 180), "models/props_combine/combine_barricade_med02a.mdl", Vector(0.4, 0.4, 0.4), color = mainColor },
    })
    :add("shoulder", "forearm", part {
        rig ( Vector(0, -85, 0) ),
        holo { Vector(0, -115, -17), Angle(0, 90, 0), "models/props_combine/CombineTrain01a.mdl", Vector(0.16, 0.26, 0.10), color = mainColor },
        holo { Vector(0, -135, -2), Angle(-90, 90, 0), "models/props_combine/combineinnerwallcluster1024_003a.mdl", Vector(0.06, 0.04, 0.08), color = mainColor },
        holo { Vector(0, -115, 14), Angle(-105, -90, 180), "models/props_combine/tprotato2.mdl", Vector(0.8, 0.8, 0.8), color = mainColor },
        holo { Vector(0, -105, -2), Angle(270, 90, 0), "models/props_combine/combine_mortar01b.mdl", Vector(1.2), color = mainColor },
    })
    :add("forearm", "hand", part {
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
    :add("hand", "claws", part {
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
    :addSequence("idle", 0, function(ent, layer)
        local shoulder = ent:getBoneEntity(ent:lookupBone("shoulder"))
        local forearm = ent:getBoneEntity(ent:lookupBone("forearm"))
        local _, shoulderAng = shoulder:getPropertyForLayer(layer)
        local _, forearmAng = forearm:getPropertyForLayer(layer)

        return tween.new {
            param { 0, 4, shoulder, circleProperty(2, nil, layer), nil, 1},
            param { 0, 2, shoulder, shoulderAng, Angle(-5, 0, -2), Angle(), math.easeInOutSine },
            param { 0, 2, forearm, forearmAng, Angle(), Angle(0, 5, 0), math.easeInOutSine },

            param { 2, 4, shoulder, shoulderAng, Angle(), Angle(-5, 0, -2), math.easeInOutSine },
            param { 2, 4, forearm, forearmAng, Angle(0, 5, 0), Angle(), math.easeInOutSine },
        }
    end)
    :addSequence("attack1", 0.75, function(ent, layer)
        local shoulder = ent:getBoneEntity(ent:lookupBone("shoulder"))
        local forearm = ent:getBoneEntity(ent:lookupBone("forearm"))
        local hand = ent:getBoneEntity(ent:lookupBone("hand"))
        if !(shoulder and forearm and hand) then return end
        local _, shoulderAng = shoulder:getPropertyForLayer(layer)
        local _, forearmAng = forearm:getPropertyForLayer(layer)
        local _, handAng = hand:getPropertyForLayer(layer)

        return tween.new {
            fcurveParam {0, 0.75, shoulder, shoulderAng, "rotation_euler", {[1] = {{{-0.542648, 0.28771}, {1, 0.28771}, {2.54265, 0.28771}}, {{3.83558, -0.137848}, {5.62794, -0.103026}, {6.1656, -0.092581}}, {{6.80072, -0.00999749}, {7, 0.255631}, {7.29048, 0.64283}}, {{8.35525, 1.34051}, {9, 1.51006}, {10.7872, 1.98004}}, {{13.747, 0.729856}, {16, 0.94511}, {16.8, 1.02154}}, {{16.5597, 0.297143}, {18, 0.28771}, {20.9999, 0.268061}}}, [2] = {{{-0.790686, -0.54666}, {1, -0.54666}, {2.79069, -0.54666}}, {{5.11135, -1.37183}, {6.37206, -1.22954}, {7.39348, -1.11425}}, {{6.94223, 0.993423}, {7, 1.21681}, {7.10566, 1.62535}}, {{8.57148, 1.31886}, {9, 1.52602}, {10.457, 2.23037}}, {{13.6082, 1.17803}, {16, 0.250582}, {16.7738, -0.0494794}}, {{16.5595, -0.547095}, {18, -0.54666}, {21, -0.545754}}}, [3] = {{{-0.554676, 1.05329}, {1, 1.05329}, {2.55468, 1.05329}}, {{3.89738, -0.20389}, {5.66403, -0.157655}, {6.22438, -0.142991}}, {{6.55468, -0.026502}, {7, 0.265312}, {7.66667, 0.702169}}, {{8.38637, 1.39778}, {9, 1.65836}, {10.4269, 2.26432}}, {{13.6399, 1.77502}, {16, 1.6291}, {16.8129, 1.57884}}, {{16.5903, 1.05951}, {18, 1.05329}, {21, 1.04005}}}}},
            fcurveParam {0, 0.75, forearm, forearmAng, "rotation_euler", {[1] = {{{-0.666667, -3.19249}, {1, -3.19249}, {2.66667, -3.19249}}, {{4.34878, -3.40615}, {6, -3.17942}, {6.33333, -3.13365}}, {{6.66667, -0.364725}, {7, -0.286788}, {7.66667, -0.130915}}, {{8.33333, -0.130915}, {9, -0.130915}, {12, -0.130915}}, {{15, -3.19249}, {18, -3.19249}, {21, -3.19249}}}, [2] = {{{-0.666667, 1.19081}, {1, 1.19081}, {2.66667, 1.19081}}, {{4.32428, 1.08243}, {6, 0.997017}, {7.04259, 0.943873}}, {{6.66667, 0.110455}, {7, 0.110455}, {7.66667, 0.110455}}, {{8.33333, 1.037}, {9, 1.06496}, {12, 1.19081}}, {{15, 1.19081}, {18, 1.19081}, {21, 1.19081}}}, [3] = {{{-0.666667, -2.89984}, {1, -2.89984}, {2.66667, -2.89984}}, {{4.32991, -2.86031}, {6, -2.73543}, {6.43972, -2.70255}}, {{6.66667, -0.0475522}, {7, 0.0329457}, {7.66667, 0.193942}}, {{8.33333, 0.193942}, {9, 0.193942}, {12, 0.193942}}, {{15, -2.89984}, {18, -2.89984}, {21, -2.89984}}}}},
            fcurveParam {0, 0.75, hand, handAng, "rotation_euler", {[1] = {{{-0.666667, 0}, {1, 0}, {2.66667, 0}}, {{4.33333, 0.417478}, {6, 0.417478}, {6.33333, 0.417478}}, {{6.66667, 0.318378}, {7, 0.318378}, {7.66667, 0.318378}}, {{8.33333, 0.944769}, {9, 0.944769}, {12, 0.944769}}, {{15, 0}, {18, 0}, {21, 0}}}, [2] = {{{-0.666667, 0}, {1, 0}, {2.66667, 0}}, {{4.33333, 0.221614}, {6, 0.221614}, {6.33333, 0.221614}}, {{6.66667, -0.0518507}, {7, -0.0518507}, {7.66667, -0.0518507}}, {{8.33333, 0.655151}, {9, 0.655151}, {12, 0.655151}}, {{15, 0}, {18, 0}, {21, 0}}}, [3] = {{{-0.666667, 0}, {1, 0}, {2.66667, 0}}, {{4.33333, 0.354758}, {6, 0.354758}, {6.33333, 0.354758}}, {{6.66667, 0.0854883}, {7, 0.0854883}, {7.66667, 0.0854883}}, {{8.33333, 0.529063}, {9, 0.529063}, {12, 0.529063}}, {{15, 0}, {18, 0}, {21, 0}}}}},
        }
    end)


model.new("astroscout_leftarm", hitbox {
    vertex {"cube", Vector(10, 0, -10), nil, Vector(56, 24, 56)},
    material = "Metal",
    mass = 300,
})
    :add("module", rig())
    :add("module", "shoulder", part { -- right shoulder
        rig(),
        holo { Vector(0, 25, -19), Angle(0, -90, 0), "models/props_combine/CombineTrain01a.mdl", Vector(0.18, 0.3, 0.12), color = mainColor },
        holo { Vector(0, 45, 6), Angle(-90, -90, 0), "models/props_combine/combineinnerwallcluster1024_003a.mdl", Vector(0.08, 0.06, 0.10), color = mainColor },
        holo { Vector(0, -16, 4), Angle(220, -270, 180), "models/props_combine/combine_barricade_med02a.mdl", Vector(0.4, 0.4, 0.4), color = mainColor },
    })
    :add("shoulder", "forearm", part { -- laser base
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
    :add("forearm", "tube", part { -- inner tube 
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
    :add("forearm", "prongs", part {
       rig ( Vector(0, 80, 0), Angle() ),
       prongs ()
    })
    :addSequence("idle", 0, function(ent, layer)
        local shoulder = ent:getBoneEntity(ent:lookupBone("shoulder"))
        local forearm = ent:getBoneEntity(ent:lookupBone("forearm"))
        local _, shoulderAng = shoulder:getPropertyForLayer(layer)
        local _, forearmAng = forearm:getPropertyForLayer(layer)

        return tween.new {
            param { 0, 4, shoulder, circleProperty(2, nil, layer), nil, 1},
            param { 0, 2, shoulder, shoulderAng, Angle(5, 0, 2), Angle(), math.easeInOutSine },
            param { 0, 2, forearm, forearmAng, Angle(), Angle(0, -5, 0), math.easeInOutSine },

            param { 2, 4, shoulder, shoulderAng, Angle(), Angle(5, 0, 2), math.easeInOutSine },
            param { 2, 4, forearm, forearmAng, Angle(0, -5, 0), Angle(), math.easeInOutSine },
        }
    end)
    :addSequence("startLaser", 1, function(ent)
        local shoulder = ent:getBoneEntity(ent:lookupBone("shoulder"))
        local forearm = ent:getBoneEntity(ent:lookupBone("forearm"))

        return tween.new {
            param { 0, 0.5, shoulder, property.LOCALANGLES, nil, Angle(-30, -90, 0), math.easeOutQuint },
            param { 0, 0.5, forearm, property.LOCALANGLES, nil, Angle(), math.easeOutQuint }
        }
    end)
    :addSequence("laser", 0, function(ent)
        local shoulder = ent:getBoneEntity(ent:lookupBone("shoulder"))

        return function(process)
            local fraction = math.min(process / 0.1, 1)
            shoulder:setLocalPos(Vector(math.sin(fraction * math.pi * 2) * 2, math.rand(-1, 1), math.rand(-1, 1)))
            if fraction == 1 then return true end
        end
    end)


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
    :addSequence("idle", 0, function(ent, layer)
        local body = ent:getBoneEntity(ent:lookupBone("body"))
        local head = ent:getBoneEntity(ent:lookupBone("head"))
        local _, bodyAng = body:getPropertyForLayer(layer)
        local _, headAng = head:getPropertyForLayer(layer)

        return tween.new {
            param { 0, 4, body, circleProperty(2, nil, layer), nil, 1},
            param { 0, 2, body, bodyAng, nil, Angle(2, 0, 0), math.easeInOutSine},
            param { 2, 4, body, bodyAng, nil, Angle(), math.easeInOutSine},

            param { 0, 4, head, circleProperty(2, 1, layer), nil, 1},
            param { 0, 2, head, headAng, nil, Angle(5, 0, 0), math.easeInOutSine},
            param { 2, 4, head, headAng, nil, Angle(), math.easeInOutSine},
        }
    end)
    :addSequence("attack1", 0.75, function(ent, layer)
        local body = ent:getBoneEntity(ent:lookupBone("body"))
        if !body then return end
        local _, bodyAng = body:getPropertyForLayer(layer)
        return tween.new {
            fcurveParam {0, 0.75, body, bodyAng, "rotation_euler", {[1] = {{{-0.666667, 0}, {1, 0}, {2.66667, 0}}, {{4.31829, -0.457148}, {6, -0.200859}, {6.32953, -0.15064}}, {{6.66667, -0.0899577}, {7, -0.0899577}, {7.66667, -0.0899577}}, {{8.33333, -0.188114}, {9, -0.188114}, {12, -0.188114}}, {{15, 0}, {18, 0}, {21, 0}}}, [2] = {{{-0.666667, 0}, {1, 0}, {2.66667, 0}}, {{4.43399, -1.08528}, {6, -0.51485}, {6.31829, -0.398909}}, {{6.66667, 0.567651}, {7, 0.61479}, {7.66667, 0.709067}}, {{8.33333, 0.709067}, {9, 0.709067}, {12, 0.709067}}, {{15, 0}, {18, 0}, {21, 0}}}, [3] = {{{-0.666667, 0}, {1, 0}, {2.66667, 0}}, {{4.33333, -0.111247}, {6, 0.0999219}, {6.33072, 0.141824}}, {{6.66667, 0.106487}, {7, 0.106487}, {7.66667, 0.106487}}, {{8.33333, 0.0794155}, {9, 0.0649763}, {12, 0}}, {{15, 0}, {18, 0}, {21, 0}}}}},
        }
    end)
    :addSequence("startLaser", 0.7, function(ent)
        local body = ent:getBoneEntity(ent:lookupBone("body"))

        return tween.new {
            param { 0, 0.7, body, property.LOCALANGLES, nil, Angle(0, -30, -5), math.easeOutQuint },
        }
    end)
    :addSequence("laser", 0, function(ent)
        local body = ent:getBoneEntity(ent:lookupBone("body"))

        return tween.new {
            param { 0, 0.1, body, property.LOCALANGLES, nil, Angle(0, -35, -5), math.easeInSine },
            param { 0.1, 0, body, property.LOCALANGLES, nil, Angle(0, -30, -5), math.easeOutSine },
        }
    end)

