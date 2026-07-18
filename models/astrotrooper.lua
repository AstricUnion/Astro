---@class tween
local tween = tween
local param = tween.param
local property = tween.ParamProperties

---@class model
local model = model
local hitbox = model.hitbox
local vertex = model.vertex
local part = model.part
local holo = model.holo
local rig = model.rig

model.new("astrotrooper_projectile", part {
    holo { nil, nil, "models/holograms/hq_sphere.mdl", Vector(4, 0.5, -0.5), noLight = true, color = Color(255, 0, 0) },
    holo { nil, nil, "models/holograms/hq_sphere.mdl", Vector(3.6, 0.45, -0.45), noLight = true, color = Color(255, 200, 200) },
    holo { nil, nil, "models/holograms/hq_sphere.mdl", Vector(3.2, 0.4, 0.4), noLight = true }
})

local propertyWithoutDiff = table.copy(property.LOCALANGLES)
propertyWithoutDiff.diff = nil

local function astrosoundShot(playAt, snd, ent)
    local isPlayed = false
    return function(process)
        if process < playAt then isPlayed = false return end
        if isPlayed then return true end
        astrosound.play {snd, nil, ent}
        isPlayed = true
    end
end


-- i don't transfer it to layers, because it not requires
model.new("astrotrooper_blaster", hitbox {
    vertex {"cube", Vector(0, 0, 6), Angle(0, 0, 0), Vector(30, 8, 10)},
    vertex {"cylinder", Vector(36, 0, 2), Angle(0, 90, 0), Vector(6, 6, 8)},
    material = "Metal",
    mass = 200,
})
    :add("module", rig())
    :add("module", "blaster", part {
        --[[
        holo { Vector(-5, 0, 2), nil, "models/hunter/blocks/cube025x025x025.mdl", color = Color(255, 0, 0, 0) },
        holo { Vector(-28, 0, -2), Angle(180, 90, 90), "models/props_combine/combinethumper001a.mdl", Vector(0.08, 0.08, 0.12), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
        holo { Vector(-28, 0, 6), Angle(0, 90, 90), "models/props_combine/combinethumper001a.mdl", Vector(0.08, 0.08, 0.12), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
        holo { Vector(-28, -5, 2), Angle(-90, 90, 90), "models/props_combine/combinethumper001a.mdl", Vector(0.08, 0.08, 0.12), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
        holo { Vector(-28, 5, 2), Angle(90, 90, 90), "models/props_combine/combinethumper001a.mdl", Vector(0.08, 0.08, 0.12), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
        holo { Vector(-19, 0, 12), Angle(180, 0, 0), "models/combine_dropship_container.mdl", Vector(0.12, 0.12, 0.12), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
        holo { Vector(25, 0, 2), Angle(90, 0, 0), "models/Items/combine_rifle_ammo01.mdl", Vector(1.8, 1.8, 1.8), color = Color(255, 40, 40) },
        ]]
        rig ( Vector(), Angle() ),
        holo { Vector(24, 0, 4), Angle(267, 0, 0), "models/props_combine/breenpod.mdl", Vector(0.4, 0.48, 0.7), color = Color(255, 40, 40) },
        holo { Vector(6, 0, 4), nil, "models/props_combine/combine_emitter01.mdl", Vector(1.2, 0.8, 0.4), color = Color(255, 40, 40) },
        holo { Vector(23, 0, -4), Angle(0, 180, 0), "models/props_combine/CombineTrain01a.mdl", Vector(0.06, 0.08, 0.035), color = Color(255, 40, 40) },
        --holo { Vector(42, 0, 2), Angle(0, 90, 0), "models/weapons/w_magnade.mdl", Vector(1.1, 1.8, 1.1), color = Color(255, 40, 40) },
        --holo { Vector(48, 0, 0.35), nil, "models/props_wasteland/light_spotlight01_lamp.mdl", Vector(0.4, 0.45, 0.45), color = Color(255, 40, 40) },
        holo { Vector(39, 0, 0.8), Angle(90, 0, 0), "models/Items/combine_rifle_ammo01.mdl", Vector(1.4), color = Color(255, 40, 40) },
    })
    :addSequence("shoot", 0.3, function(ent)
        local bone = ent:getBoneEntity(ent:lookupBone("blaster"))
        if !bone then return end
        astrosound.play {"blaster", nil, ent}
        local eff = beff.create("blaster_muzzle")
        eff:setEntity(ent)
        eff:setOrigin(Vector(32, 0, 0))
        eff:play()
        return tween.new {
            param { 0, 0.15, bone, property.LOCALPOS, Vector(), Vector(-20, 0, 0), math.easeOutCubic },
            param { 0.15, 0.3, bone, property.LOCALPOS, Vector(-20, 0, 0), Vector(), math.easeOutCubic },
        }
    end)
    :addSequence("reload", 1, function(ent)
        local bone = ent:getBoneEntity(ent:lookupBone("blaster"))
        if !bone then return end
        astrosound.play {"blaster", nil, ent}
        local eff = beff.create("blaster_muzzle")
        eff:setEntity(ent)
        eff:setOrigin(Vector(32, 0, 0))
        eff:play()
        return tween.new {
            param { 0, 0.15, bone, property.LOCALPOS, Vector(), Vector(-20, 0, 0), math.easeOutCubic },
            param { 0.15, 0.3, bone, property.LOCALPOS, Vector(-20, 0, 0), Vector(), math.easeOutCubic },
            param { 0.3, 0.9, bone, propertyWithoutDiff, Angle(), Angle(360, 0, 0), math.easeInOutQuart},
            astrosoundShot(0.3, "reload", ent)
        }
    end)

local mat = {[0] = "models/props_combine/metal_combinebridge001", [1] = "models/props_combine/metal_combinebridge001", [2] = "models/props_combine/metal_combinebridge001"}
local bodyModel = part {
    rig ( Vector(), Angle() ),
    holo { Vector(0, 0, 3), Angle(0, 0, 90), "models/props_wasteland/wheel02b.mdl", Vector(0.45, 0.3, 0.45), color = Color(255, 40, 40) },
    holo { Vector(0, 0, -6), Angle(0, 0, 90), "models/props_wasteland/wheel02b.mdl", Vector(0.37, 0.3, 0.37), color = Color(255, 40, 40) },
    holo { Vector(0, 0, -10), Angle(140, 0, 0), "models/props_combine/combineinnerwallcluster1024_003a.mdl", Vector(0.03, 0.02, 0.02), color = Color(255, 40, 40) },
    holo { Vector(0, 0, -10), Angle(140, 180, 0), "models/props_combine/combineinnerwallcluster1024_003a.mdl", Vector(0.03, 0.02, 0.02), color = Color(255, 40, 40) },
    holo { Vector(17, -25, -2), Angle(18, -60, 0), "models/props_combine/tprotato2.mdl", Vector(0.16, 0.22, 0.18), color = Color(255, 40, 40) },
    holo { Vector(17, 25, -4), Angle(18, 60, 0), "models/props_combine/tprotato2.mdl", Vector(0.16, 0.22, 0.18), color = Color(255, 40, 40) },
    holo { Vector(24, -18, -3), Angle(0, 142, 0), "models/combine_room/combine_monitor002.mdl", Vector(0.03, 0.1, 0.055), color = Color(255, 40, 40) },
    holo { Vector(24, 18, -3.4), Angle(0, -142, 0), "models/combine_room/combine_monitor002.mdl", Vector(0.03, 0.1, 0.055), color = Color(255, 40, 40) },
    holo { Vector(23, -1, 4), nil, "models/combine_turrets/ground_turret.mdl", Vector(0.65, 0.95, 0.7), color = Color(255, 40, 40) },
    holo { Vector(29.4, 0, -1), nil, "models/props_combine/combine_barricade_med02c.mdl", Vector(0.08, 0.14, 0.06), color = Color(255, 40, 40) },
    holo { Vector(-6, -27, 0), Angle(0, 90, -90), "models/props_combine/combine_binocular01.mdl", Vector(1, 1.6, 0.75), color = Color(255, 40, 40) },
    holo { Vector(-6, 27, 0), Angle(180, 90, -90), "models/props_combine/combine_binocular01.mdl", Vector(1, 1.6, 0.75), color = Color(255, 40, 40) },
    holo { Vector(-27, 17, -5), Angle(0, 135, 0), "models/props_combine/combine_barricade_med03b.mdl", Vector(0.06, 0.09, 0.12), color = Color(255, 40, 40) },
    holo { Vector(-27, -17, -5), Angle(0, -135, 0), "models/props_combine/combine_barricade_med04b.mdl", Vector(0.06, 0.09, 0.12), color = Color(255, 40, 40) },
    holo { Vector(-30, 0, -6), Angle(0, 180, 0), "models/props_combine/combine_barricade_med02b.mdl", Vector(0.08, 0.15, 0.12), color = Color(255, 40, 40) },
}
local rotor1Model = part {
    rig ( Vector(), Angle() ),
    holo { Vector(0, 0, -7), Angle(180, 0, 0), "models/props_phx/gears/bevel12.mdl", Vector(1.8, 1.8, 1), noLight = true, color = Color(255, 40, 40) },
}
local rotor2Model = part {
    rig ( Vector(), Angle() ),
    holo { Vector(0, 0, -1), Angle(180, 0, 0), "models/props_phx/gears/bevel36.mdl", Vector(1.1, 1.1, 1), color = Color(255, 40, 40) },
    holo { Vector(15, 0, 7), Angle(285, 0, 0), "models/props_combine/tprotato1.mdl", Vector(0.25, 0.1, 0.16), color = Color(255, 40, 40) },
    holo { Vector(0, 15, 7), Angle(285, 90, 0), "models/props_combine/tprotato1.mdl", Vector(0.25, 0.1, 0.16), color = Color(255, 40, 40) },
    holo { Vector(-15, 0, 7), Angle(285, 180, 0), "models/props_combine/tprotato1.mdl", Vector(0.25, 0.1, 0.16), color = Color(255, 40, 40) },
    holo { Vector(0, -15, 7), Angle(285, 270, 0), "models/props_combine/tprotato1.mdl", Vector(0.25, 0.1, 0.16), color = Color(255, 40, 40) },
}
model.new("astrotrooper_body", part {
    hitbox {
        vertex {"cylinder", Vector(0, 0, 0), Angle(0, 0, 0), Vector(32, 32, 7)},
        vertex {"cylinder", Vector(0, 0, -10), Angle(0, 0, 0), Vector(20, 20, 8)},
        material = "Metal",
        mass = 800,
    },
    bodyModel,
    rotor1Model,
    rotor2Model
})

local eyeModel = part {
    holo { Vector(9, 0, 0), nil, "models/hunter/misc/sphere075x075.mdl", Vector(0.3, 0.55, 0.55), noLight = true, color = Color(255, 40, 40), material = "models/debug/debugwhite" },
    holo { Vector(12, 0, 0), nil, "models/hunter/misc/sphere075x075.mdl", Vector(0.18, 0.4, 0.4), noLight = true, color = Color(255, 255, 255), material = "models/debug/debugwhite" },
}

local headModel = part {
    holo { Vector(0, 0, 0), nil, "models/hunter/misc/sphere075x075.mdl", Vector(0.75, 0.75, 0.75), noLight = true, color = Color(0, 0, 0), material = "models/debug/debugwhite" },
    holo { Vector(0, 0, 0), Angle(-90, 180, 0), "models/props_combine/combine_booth_short01a.mdl", Vector(0.22, 0.22, 0.16), color = Color(255, 40, 40) },
    holo { Vector(0, 0, 0), Angle(-90, 0, 0), "models/props_combine/combine_booth_short01a.mdl", Vector(0.22, 0.22, 0.16), color = Color(255, 40, 40) },
    holo { Vector(5, 0, -5), Angle(-50, 180, 0), "models/props_combine/combine_booth_short01a.mdl", Vector(0.22, 0.22, 0.16), color = Color(255, 0, 0) },
    holo { Vector(-3, 0, 6), Angle(-190, 0, 0), "models/props_combine/combine_booth_short01a.mdl", Vector(0.21, 0.21, 0.16), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
}
model.new("astrotrooper_head", part {
    hitbox {
        vertex {"cube", Vector(0, 0, 5), Angle(0, 0, 0), Vector(14, 14, 14)},
        material = "Metal",
        mass = 200,
    },
    headModel
})


model.new("astrotrooper", hitbox {
    vertex {"cylinder", Vector(0, 0, 0), Angle(0, 0, 0), Vector(32, 32, 7)},
    vertex {"cylinder", Vector(0, 0, -10), Angle(0, 0, 0), Vector(20, 20, 8)},
    vertex {"cube", Vector(0, 0, 28), Angle(0, 0, 0), Vector(14, 14, 14)},
    material = "Metal",
    mass = 1000
})
    :add("body", bodyModel)
    :add("body", "rotor1", rotor1Model)
    :add("body", "rotor2", rotor2Model)
    :add("camera", rig(Vector(0, 0, 25), Angle()))
    :add("camera", "head", headModel)
    :add("head", "eye", eyeModel)
    :addSequence("idle", 0, function(ent)
        local head = ent:getBoneEntity(ent:lookupBone("head"))
        local camera = ent:getBoneEntity(ent:lookupBone("camera"))
        local body = ent:getBoneEntity(ent:lookupBone("body"))
        local rotor1 = ent:getBoneEntity(ent:lookupBone("rotor1"))
        local rotor2 = ent:getBoneEntity(ent:lookupBone("rotor2"))

        return tween.new {
            function(process)
                if !(isValid(body) and isValid(camera)) then return true end
                local fraction = math.min(process / 4, 1)
                local rads = math.pi * fraction * 2
                local x, y = math.sin(rads), math.cos(rads)
                camera:setLocalPos(Vector(x * 3, 0, 25 - y * 2))
                body:setLocalPos(Vector(x * 2, 0, 0 - y))
                if fraction == 1 then
                    return true
                end
            end,

            param { 0, 2, body, property.LOCALANGLES, Angle(4, 0, 0), Angle(0, 0, 0), math.easeInOutSine },
            param { 2, 4, body, property.LOCALANGLES, Angle(0, 0, 0), Angle(4, 0, 0), math.easeInOutSine },

            param { 0, 2, head, property.LOCALANGLES, Angle(8, 0, 0), Angle(0, 0, 0), math.easeInOutSine },
            param { 2, 4, head, property.LOCALANGLES, Angle(0, 0, 0), Angle(8, 0, 0), math.easeInOutSine },

            function(process)
                if !(isValid(rotor1) and isValid(rotor2)) then return true end
                if process > 4 then
                    return true
                end
                local delta = game.serverFrameTime()
                rotor1:setLocalAngles(rotor1:getLocalAngles() + Angle(0, 200 * delta, 0))
                rotor2:setLocalAngles(rotor2:getLocalAngles() + Angle(0, -80 * delta, 0))
            end
        }
    end)
