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
        holo { Vector(-5, 0, 2), nil, "models/hunter/blocks/cube025x025x025.mdl", color = Color(255, 0, 0, 0) },
        holo { Vector(-28, 0, -2), Angle(180, 90, 90), "models/props_combine/combinethumper001a.mdl", Vector(0.08, 0.08, 0.12), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
        holo { Vector(-28, 0, 6), Angle(0, 90, 90), "models/props_combine/combinethumper001a.mdl", Vector(0.08, 0.08, 0.12), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
        holo { Vector(-28, -5, 2), Angle(-90, 90, 90), "models/props_combine/combinethumper001a.mdl", Vector(0.08, 0.08, 0.12), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
        holo { Vector(-28, 5, 2), Angle(90, 90, 90), "models/props_combine/combinethumper001a.mdl", Vector(0.08, 0.08, 0.12), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
        holo { Vector(-19, 0, 12), Angle(180, 0, 0), "models/combine_dropship_container.mdl", Vector(0.12, 0.12, 0.12), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
        holo { Vector(25, 0, 2), Angle(90, 0, 0), "models/Items/combine_rifle_ammo01.mdl", Vector(1.8, 1.8, 1.8), color = Color(255, 40, 40) },
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
}
local rotor1Model = part {
    holo { Vector(0, 0, -11), nil, "models/props_phx/wheels/moped_tire.mdl", Vector(1.8, 1.8, 2.2), color = Color(255, 40, 40), material = mat},
    holo { Vector(0, 0, -10), Angle(90, 0, 0), "models/props_c17/pulleywheels_large01.mdl", Vector(1.2, 1, 1), color = Color(255, 40, 40), material = mat }
}
local rotor2Model = part {
    rig(Vector(0, 0, -6)),
    holo { Vector(0, 0, -6), Angle(0, 0, 90), "models/props_wasteland/wheel03a.mdl", Vector(0.27, 0.18, 0.27), color = Color(255, 40, 40) },
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
                rotor2:setLocalAngles(rotor2:getLocalAngles() + Angle(0, -200 * delta, 0))
            end
        }
    end)
