---@name Astro Trooper Model
---@author Ratyuha
---@shared

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

model.new("astrotrooper_blaster", hitbox {
        vertex {"cube", Vector(0, 0, 6), Angle(0, 0, 0), Vector(30, 8, 10)},
        vertex {"cylinder", Vector(36, 0, 2), Angle(0, 90, 0), Vector(6, 6, 8)},
        material = "Metal",
        mass = 200,
    })
    :add("blaster", part {
        holo { Vector(-5, 0, 2), nil, "models/hunter/blocks/cube025x025x025.mdl", color = Color(255, 0, 0, 0) },
        holo { Vector(-28, 0, -2), Angle(180, 90, 90), "models/props_combine/combinethumper001a.mdl", Vector(0.08, 0.08, 0.12), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
        holo { Vector(-28, 0, 6), Angle(0, 90, 90), "models/props_combine/combinethumper001a.mdl", Vector(0.08, 0.08, 0.12), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
        holo { Vector(-28, -5, 2), Angle(-90, 90, 90), "models/props_combine/combinethumper001a.mdl", Vector(0.08, 0.08, 0.12), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
        holo { Vector(-28, 5, 2), Angle(90, 90, 90), "models/props_combine/combinethumper001a.mdl", Vector(0.08, 0.08, 0.12), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
        holo { Vector(-19, 0, 12), Angle(180, 0, 0), "models/combine_dropship_container.mdl", Vector(0.12, 0.12, 0.12), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
        holo { Vector(25, 0, 2), Angle(90, 0, 0), "models/Items/combine_rifle_ammo01.mdl", Vector(1.8, 1.8, 1.8), color = Color(255, 40, 40) },
    })
    :addSequence("shoot", 0.5, function(ent)
        if ent.tween then tween.stop(ent.tween) end
        local boneId = ent:lookupBone("blaster")
        if !boneId then return end
        local bone = ent:getBoneEntity(boneId)
        ent.tween = tween.start(tween.new {
            param { 0, 0.1, bone, property.LOCALPOS, Vector(), Vector(-16, 0, 0), math.easeOutQuart },
            param { 0.1, 0.3, bone, property.LOCALPOS, Vector(-16, 0, 0), Vector(0, 0, 0), math.easeInQuart }
        })
    end)
    :addSequence("reload", 1, function(ent)
        if ent.tween then tween.stop(ent.tween) end
        local boneId = ent:lookupBone("blaster")
        if !boneId then return end
        local bone = ent:getBoneEntity(boneId)
        local propertyWithoutDiff = table.copy(property.LOCALANGLES)
        propertyWithoutDiff.diff = nil
        ent.tween = tween.start(tween.new {
            param { 0, 0.6, bone, propertyWithoutDiff, Angle(), Angle(360, 0, 0), math.easeInOutQuart},
        })
    end)

local mat = {[0] = "models/props_combine/metal_combinebridge001", [1] = "models/props_combine/metal_combinebridge001", [2] = "models/props_combine/metal_combinebridge001"}
model.new("astrotrooper", hitbox {
    vertex {"cylinder", Vector(0, 0, 0), Angle(0, 0, 0), Vector(32, 32, 7)},
    vertex {"cylinder", Vector(0, 0, -10), Angle(0, 0, 0), Vector(20, 20, 8)},
    vertex {"cube", Vector(0, 0, 28), Angle(0, 0, 0), Vector(14, 14, 14)},
    material = "Metal",
    mass = 1000,
})
    :add("body", part {
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
        holo { Vector(0, 0, -11), nil, "models/props_phx/wheels/moped_tire.mdl", Vector(1.8, 1.8, 2.2), color = Color(255, 40, 40), material = mat},
        holo { Vector(0, 0, -6), Angle(0, 0, 90), "models/props_wasteland/wheel03a.mdl", Vector(0.27, 0.18, 0.27), color = Color(255, 40, 40) },
        holo { Vector(0, 0, -10), Angle(90, 0, 0), "models/props_c17/pulleywheels_large01.mdl", Vector(1.2, 1, 1), color = Color(255, 40, 40), material = mat }
    })
    :add("camera", rig(Vector(0, 0, 25), Angle()))
    :add("camera", "head", part {
        holo { Vector(0, 0, 0), nil, "models/hunter/misc/sphere075x075.mdl", Vector(0.75, 0.75, 0.75), noLight = true, color = Color(0, 0, 0), material = "models/debug/debugwhite" },
        holo { Vector(9, 0, 0), nil, "models/hunter/misc/sphere075x075.mdl", Vector(0.3, 0.55, 0.55), noLight = true, color = Color(255, 40, 40), material = "models/debug/debugwhite" },
        holo { Vector(12, 0, 0), nil, "models/hunter/misc/sphere075x075.mdl", Vector(0.18, 0.4, 0.4), noLight = true, color = Color(255, 255, 255), material = "models/debug/debugwhite" },
        holo { Vector(0, 0, 0), Angle(-90, 180, 0), "models/props_combine/combine_booth_short01a.mdl", Vector(0.22, 0.22, 0.16), color = Color(255, 40, 40) },
        holo { Vector(0, 0, 0), Angle(-90, 0, 0), "models/props_combine/combine_booth_short01a.mdl", Vector(0.22, 0.22, 0.16), color = Color(255, 40, 40) },
        holo { Vector(5, 0, -5), Angle(-50, 180, 0), "models/props_combine/combine_booth_short01a.mdl", Vector(0.22, 0.22, 0.16), color = Color(255, 0, 0) },
        holo { Vector(-3, 0, 6), Angle(-190, 0, 0), "models/props_combine/combine_booth_short01a.mdl", Vector(0.21, 0.21, 0.16), color = Color(255, 40, 40), material = "models/props_combine/metal_combinebridge001" },
    })
    :addSequence("idle", 0.5, function(ent)
        if ent.tween then tween.stop(ent.tween) end

        local headId = ent:lookupBone("head")
        if !headId then return end
        local head = ent:getBoneEntity(headId)
        if !head then return end

        local cameraId = ent:lookupBone("camera")
        if !cameraId then return end
        local camera = ent:getBoneEntity(cameraId)
        if !camera then return end

        local bodyId = ent:lookupBone("body")
        if !bodyId then return end
        local body = ent:getBoneEntity(bodyId)
        if !body then return end

        ent.tween = tween.start(tween.new {
            function(process)
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
        }, true)
    end)
