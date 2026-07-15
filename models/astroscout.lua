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


local function prongsFun()
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

        shoulder:setLocalAnglesLayer(layer + 1, tween.blenderRotation(19.5255, -35.631, 58.67))
        forearm:setLocalAnglesLayer(layer + 1, tween.blenderRotation(-180.605, 63.6716, -164.196))

        return tween.new {
            param { 0, 4, shoulder, circleProperty(2, nil, layer), nil, 1},
            param { 0, 2, shoulder, shoulderAng, Angle(-5, 0, -2), Angle(), math.easeInOutSine },
            param { 2, 4, shoulder, shoulderAng, Angle(), Angle(-5, 0, -2), math.easeInOutSine },

            param { 0, 2, forearm, forearmAng, Angle(0, -5, 0), Angle(), math.easeInOutSine },
            param { 2, 4, forearm, forearmAng, Angle(), Angle(0, -5, 0), math.easeInOutSine },
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
            fcurveParam {0, 0.75, shoulder, shoulderAng, "rotation_euler", {[1] = {{{0.0707951, 0.340784}, {1, 0.340784}, {2.96366, 0.340784}}, {{3, 0.250226}, {4, 0.250226}, {4.66667, 0.250226}}, {{5.33333, 0.403605}, {6, 0.403605}, {6.001, 0.403605}}, {{6.66667, -0.0851573}, {7, -0.162209}, {7.33333, -0.23926}}, {{7.999, -0.239261}, {8, -0.239261}, {11.165, -0.239261}}, {{10.7048, 1.14807}, {11, 0.993169}, {13.4935, -0.315493}}, {{15.975, 0.340784}, {18, 0.340784}, {19.9637, 0.340784}}}, [2] = {{{0.0707951, -0.621879}, {1, -0.621879}, {2.96366, -0.621879}}, {{3, -0.621879}, {4, -0.838573}, {4.66667, -0.983036}}, {{5.33333, -1.48879}, {6, -1.48879}, {6.001, -1.48879}}, {{6.99894, 1.29147}, {7, 1.29147}, {7.71114, 1.29147}}, {{9.66667, 1.29147}, {11, 1.07357}, {11.6667, 0.964617}}, {{12.6463, 0.0443725}, {13, -0.182798}, {14.5407, -1.17225}}, {{15.975, -0.621879}, {18, -0.621879}, {19.9637, -0.621879}}}, [3] = {{{0.0707951, 1.02399}, {1, 1.02399}, {2.96366, 1.02399}}, {{3, 1.02399}, {4, 0.489909}, {4.66667, 0.133855}}, {{5.33333, -0.248462}, {6, -0.248462}, {6.64783, -0.248462}}, {{6.999, -0.170419}, {7, -0.170419}, {7.001, -0.170419}}, {{8.33333, -0.373811}, {9, -0.373811}, {11.2071, -0.373811}}, {{10.3333, 1.18002}, {11, 1.18002}, {11.6667, 1.18002}}, {{12.6633, 1.0665}, {13, 1.12886}, {14.3799, 1.38437}}, {{15.975, 1.02399}, {18, 1.02399}, {19.9637, 1.02399}}}}},
            fcurveParam {0, 0.6666666666666666, forearm, forearmAng, "rotation_euler", {[1] = {{{0.0707951, -3.15215}, {1, -3.15215}, {2.96366, -3.15215}}, {{3, -3.65867}, {4, -3.65867}, {4.66667, -3.65867}}, {{5.79822, -3.96473}, {6, -3.15215}, {6.0272, -3.04261}}, {{6.66667, -0.0198987}, {7, -0.0198987}, {8.45726, -0.0198987}}, {{8.33333, -0.130314}, {9, -0.130314}, {10, -0.130314}}, {{10.7612, 0.333233}, {12, 0.109035}, {12.656, -0.00968981}}, {{14.5791, -4.22217}, {16, -3.15215}, {17.5686, -1.97087}}}, [2] = {{{0.0707951, 1.11128}, {1, 1.11128}, {2.96366, 1.11128}}, {{3, 1.29875}, {4, 1.29875}, {4.66667, 1.29875}}, {{5.30937, 1.16249}, {6, 1.11128}, {6.00309, 1.11105}}, {{6.74146, 0.256283}, {7, 0.183452}, {7.35221, 0.0842328}}, {{9.04439, -0.15208}, {10, 0.142541}, {10.654, 0.344173}}, {{11.3207, 0.820312}, {12, 1.21172}, {12.2888, 1.37812}}, {{15.3263, 1.11128}, {16, 1.11128}, {17.9637, 1.11128}}}, [3] = {{{0.0707951, -2.86576}, {1, -2.86576}, {2.96366, -2.86576}}, {{3, -3.5828}, {4, -3.5828}, {4.66667, -3.5828}}, {{5.33333, -3.5828}, {6, -2.86576}, {6.33333, -2.50724}}, {{6.67622, 0.155984}, {7, 0.0767416}, {8.07062, -0.185287}}, {{8.33333, 0.0113164}, {9, 0.0113164}, {9.33333, 0.0113164}}, {{9.68193, 0.00483315}, {10, -0.100408}, {10.6066, -0.30111}}, {{11.1792, -0.351373}, {12, -0.322863}, {13.2944, -0.277906}}, {{14.5791, -3.93578}, {16, -2.86576}, {17.5686, -1.68447}}}}},
            fcurveParam {0, 0.6666666666666666, hand, handAng, "rotation_euler", {[1] = {{{0.0707951, 0}, {1, 0}, {2.96366, 0}}, {{3, -0.192456}, {4, -0.192456}, {4.66667, -0.192456}}, {{5.33333, 0.00928021}, {6, 0.00928021}, {6.66667, 0.00928021}}, {{7.33333, -0.0706531}, {8, -0.0912027}, {8.33333, -0.101478}}, {{8.66667, -0.101478}, {9, -0.101478}, {9.33333, -0.101478}}, {{9.66667, -0.0900194}, {10, -0.0785613}, {10.3333, -0.0671031}}, {{10.6667, -0.055645}, {11, -0.055645}, {11.3333, -0.055645}}, {{11.6667, -0.435088}, {12, -0.435088}, {12.6667, -0.435088}}, {{13.658, -0.42824}, {14, -0.309143}, {14.2755, -0.213225}}, {{14.5855, -0.025628}, {15, -0.0668556}, {15.3829, -0.104934}}, {{15.5855, 0}, {16, 0}, {17.9637, 0}}}, [2] = {{{0.0707951, 0}, {1, 0}, {2.96366, 0}}, {{3, 0.0368817}, {4, 0.241806}, {4.66667, 0.378422}}, {{5.33333, 0.501955}, {6, 0.501955}, {6.33333, 0.501955}}, {{6.66667, 0.0748708}, {7, 0.0748708}, {7.33333, 0.0748708}}, {{7.66666, 0.0758435}, {8, 0.0769902}, {10.4643, 0.0854675}}, {{10.6667, 0.43575}, {12, 0.43575}, {12.6667, 0.43575}}, {{13.658, 0.232503}, {14, 0.113225}, {14.2755, 0.0171602}}, {{14.5855, -0.025628}, {15, -0.0668556}, {15.3829, -0.104934}}, {{15.5855, 0}, {16, 0}, {17.9637, 0}}}, [3] = {{{0.0707951, 0}, {1, 0}, {2.96366, 0}}, {{3, -0.0867643}, {4, -0.0867643}, {4.66667, -0.0867643}}, {{5.33714, 0.223809}, {6, 0.152694}, {6.71784, 0.07568}}, {{10.5233, 0.0395442}, {11, 0.0905967}, {11.3314, 0.126096}}, {{11.6667, 0.372436}, {12, 0.372436}, {13.3302, 0.372436}}, {{14.4586, -0.208782}, {16, 0}, {17.9459, 0.263573}}}}}
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
       prongsFun ()
    })
    :addSequence("idle", 0, function(ent, layer)
        local tube = ent:getBoneEntity(ent:lookupBone("tube"))
        local prongs = ent:getBoneEntity(ent:lookupBone("prongs"))
        local shoulder = ent:getBoneEntity(ent:lookupBone("shoulder"))
        local forearm = ent:getBoneEntity(ent:lookupBone("forearm"))
        local _, shoulderAng = shoulder:getPropertyForLayer(layer)
        local _, forearmAng = forearm:getPropertyForLayer(layer)

        shoulder:setLocalAnglesLayer(layer + 1, tween.blenderRotation(19.5255, 35.631, -58.67))
        forearm:setLocalAnglesLayer(layer + 1, tween.blenderRotation(-180.605, -63.6716, 164.196))

        return tween.new {
            param { 0, 4, shoulder, circleProperty(2, nil, layer), nil, 1},
            param { 0, 2, shoulder, shoulderAng, Angle(-5, 0, 2), Angle(), math.easeInOutSine },
            param { 2, 4, shoulder, shoulderAng, Angle(), Angle(-5, 0, 2), math.easeInOutSine },

            param { 0, 2, forearm, forearmAng, Angle(0, 5, 0), Angle(), math.easeInOutSine },
            param { 2, 4, forearm, forearmAng, Angle(), Angle(0, 5, 0), math.easeInOutSine },
            function(process)
                if !isValid(tube) then return end
                local delta = game.serverFrameTime()
                tube:setLocalAngles(tube:getLocalAngles() + Angle(400 * delta, 0, 0))
                prongs:setLocalAngles(prongs:getLocalAngles() + Angle(200 * delta, 0, 0))
                if process > 4 then return true end
            end
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
        }
    })
    :add("body", "rotor", part {
        part {
            rig(),
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
        local rotor = ent:getBoneEntity(ent:lookupBone("rotor"))
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

            function(process)
                if !isValid(rotor) then return end
                rotor:setLocalAngles(rotor:getLocalAngles() + Angle(0, 200 * game.serverFrameTime(), 0))
                if process > 4 then return true end
            end
        }
    end)
    :addSequence("attack1", 0.75, function(ent, layer)
        local body = ent:getBoneEntity(ent:lookupBone("body"))
        if !body then return end
        local _, bodyAng = body:getPropertyForLayer(layer)
        return tween.new {
            fcurveParam {0, 0.75, body, bodyAng, "rotation_euler", {[1] = {{{0.0719737, 0.0467787}, {1, 0}, {4.40951, -0.171862}}, {{8.32405, 0.141957}, {11, 0.14067}, {12.0407, 0.140169}}, {{13.657, 0.0693383}, {14, 0.0493183}, {16.2311, -0.0808997}}, {{16.188, 0.00148404}, {18, 0}, {19.9637, -0.00160829}}}, [2] = {{{0.07882, 0.121861}, {1, 0}, {3.16015, -0.285762}}, {{4.33334, -0.35236}, {6, -0.348725}, {7.14206, -0.346234}}, {{4.71878, 0.884119}, {10, 0.884119}, {10.8478, 0.884119}}, {{10.5885, 0.352506}, {12, 0.227491}, {12.6827, 0.167024}}, {{13.6557, 0.0971393}, {14, 0.0684638}, {16.0612, -0.103201}}, {{16.3581, 0.000967786}, {18, 0}, {19.9637, -0.00115746}}}, [3] = {{{0.0759026, 0.0972928}, {1, 0}, {3.94286, -0.309837}}, {{7.66667, -0.157007}, {8, -0.157007}, {8.54055, -0.157007}}, {{9.03148, -0.0637872}, {11, -0.0782009}, {12.414, -0.0885546}}, {{13.6578, -0.0534663}, {14, -0.0344253}, {16.4632, 0.102621}}, {{16.2664, 0.00186509}, {18, 0}, {19.9637, -0.00211266}}}}},
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

