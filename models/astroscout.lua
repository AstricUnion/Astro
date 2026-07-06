--@server


local function circlePos(ang, radius, pos)
    local rad = math.rad(ang)
    return Vector(math.sin(rad)*radius,0,math.cos(rad)*radius)+pos
end

local function prong(ang)
    local prongHolo = hologram.createPart(
        Holo(Rig(Vector(-1.5,242,24))),
        Holo(SubHolo(Vector(-1.5,242,48),Angle(145,90,-90),"models/props_combine/combine_barricade_bracket01a.mdl",Vector(1.4,1,1),false,Color(255,40,40,255),"models/props_combine/metal_combinebridge001"))
    )
    prongHolo:setLocalAngles(Angle(-ang,0,0))
    return Holo(prongHolo)
end

local function laserTube(ang)
    local pos = circlePos(ang,18.5,Vector(-3,208,24))
    return Holo(SubHolo(pos,Angle(90,90,0),"models/hunter/tubes/circle2x2.mdl",Vector(0.06,0.06,18),false,Color(255,40,40,255),"models/props_combine/metal_combinebridge001"))
end

body = {
    base = {
        hologram.createPart(
            Holo(Rig(Vector(0,0,19))),
            Holo(SubHolo(Vector(0,0,19),Angle(0,0,90),"models/props_wasteland/wheel03a.mdl",Vector(0.65,0.2,0.65),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,0,0),Angle(0,0,90),"models/props_wasteland/wheel03a.mdl",Vector(0.65,0.2,0.65),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,0,8),Angle(0),"models/props_phx/construct/metal_angle360.mdl",Vector(1.3,1.3,3),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-60,0,40),Angle(0),"models/props_combine/combineinnerwallcluster1024_002a.mdl",Vector(0.09,0.09,0.09),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-34,-60,20),Angle(0,40,0),"models/props_combine/combineinnerwall001a.mdl",Vector(0.1,0.2,0.05),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-34,60,20),Angle(0,-40,0),"models/props_combine/combineinnerwall001a.mdl",Vector(0.1,0.2,0.05),false,Color(255,40,40))),
            Holo(SubHolo(Vector(46,70,10),Angle(180,225,-90),"models/combine_wall.mdl",Vector(0.06,0.08,0.05),false,Color(255,40,40))),
            Holo(SubHolo(Vector(46,-70,10),Angle(180,-225,90),"models/combine_wall.mdl",Vector(0.06,0.08,0.05),false,Color(255,40,40))),
            Holo(SubHolo(Vector(30,-72,0),Angle(0,-90,0),"models/props_combine/combine_barricade_med03b.mdl",Vector(0.3,0.3,0.25),false,Color(255,40,40))),
            Holo(SubHolo(Vector(30,72,0),Angle(0,90,0),"models/props_combine/combine_barricade_med04b.mdl",Vector(0.3,0.3,0.25),false,Color(255,40,40))),
            Holo(SubHolo(Vector(70,0,-6),Angle(0),"models/props_combine/combine_barricade_tall02b.mdl",Vector(0.4,0.4,0.15),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-10,0,-19),Angle(50,180,180),"models/props_combine/combineinnerwallcluster1024_003a.mdl",Vector(0.07,0.07,0.06),false,Color(255,40,40))),
            Holo(SubHolo(Vector(10,0,-19),Angle(130,-180,0),"models/props_combine/combineinnerwallcluster1024_003a.mdl",Vector(0.07,0.07,0.06),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-66,-20,12),Angle(180,30,90),"models/props_combine/combine_barricade_tall01a.mdl",Vector(0.4),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-66,20,12),Angle(180,-30,270),"models/props_combine/combine_barricade_tall01a.mdl",Vector(0.4),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-70,0,4),Angle(0,180,0),"models/props_combine/combine_barricade_med01a.mdl",Vector(0.4,0.6,0.35),false,Color(255,40,40)))
        ),
        hologram.createPart(
            Holo(Rig(Vector(0,0,10))),
            Holo(SubHolo(Vector(0,0,10),Angle(0,0,90),"models/props_wasteland/wheel02b.mdl",Vector(1),false,Color(255,40,40))),
            Holo(SubHolo(Vector(30,0,15),Angle(5,-5,-45),"models/Gibs/helicopter_brokenpiece_03.mdl",Vector(1),false,Color(255,40,40))),
            Holo(SubHolo(Vector(22,-22,15),Angle(5,-50,-45),"models/Gibs/helicopter_brokenpiece_03.mdl",Vector(1),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-30,0,15),Angle(5,-185,-45),"models/Gibs/helicopter_brokenpiece_03.mdl",Vector(1),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-22,-22,15),Angle(5,-140,-45),"models/Gibs/helicopter_brokenpiece_03.mdl",Vector(1),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,-30,15),Angle(5,-95,-45),"models/Gibs/helicopter_brokenpiece_03.mdl",Vector(1),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-22,22,15),Angle(5,130,-45),"models/Gibs/helicopter_brokenpiece_03.mdl",Vector(1),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,30,15),Angle(5,85,-45),"models/Gibs/helicopter_brokenpiece_03.mdl",Vector(1),false,Color(255,40,40))),
            Holo(SubHolo(Vector(22,22,15),Angle(5,40,-45),"models/Gibs/helicopter_brokenpiece_03.mdl",Vector(1),false,Color(255,40,40)))
        ),
        berserkTrails = {
            Rig(Vector(0, 75, 45)),
            Rig(Vector(0, -75, 45))
        }
    },
    head = hologram.createPart(
        Holo(Rig(Vector(0,0,68))),
        Holo(SubHolo(Vector(0,0,68),Angle(0),"models/hunter/misc/sphere075x075.mdl",Vector(1.4,1.4,1.4),true,Color(0,0,0),"models/debug/debugwhite")),
        Holo(SubHolo(Vector(14,0,68),Angle(0),"models/hunter/misc/sphere075x075.mdl",Vector(0.6,1.1,1.1),true,Color(255,40,40),"models/debug/debugwhite")),
        Holo(SubHolo(Vector(20.2,0,67),Angle(0,0,0),"models/hunter/misc/sphere075x075.mdl",Vector(0.3,0.3,0.9),true,Color(255,255,255),"models/debug/debugwhite")),
        
        --Holo(SubHolo(Vector(24.2,0,67),Angle(-90,0,0),"models/hunter/triangles/025x025mirrored.mdl",Vector(1.4,0.9,1.3),true,Color(255,255,255),"models/debug/debugwhite")),
        
        Holo(SubHolo(Vector(-22,0,70),Angle(-100,180,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.4,0.45,0.5),false,Color(255,40,40))),
        Holo(SubHolo(Vector(-4,0,64),Angle(45,180,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.3,0.45,0.4),false,Color(255,40,40))),
        Holo(SubHolo(Vector(0,-35,52),Angle(20,-12,0),"models/props_combine/headcrabcannister01a.mdl",Vector(0.4,0.5,0.5),false,Color(255,40,40))),
        Holo(SubHolo(Vector(0,35,52),Angle(20,12,0),"models/props_combine/headcrabcannister01a.mdl",Vector(0.4,0.5,0.5),false,Color(255,40,40))),
        Holo(SubHolo(Vector(0,-35,80),Angle(0,-12,0),"models/props_combine/headcrabcannister01a.mdl",Vector(0.4,0.5,0.5),false,Color(255,40,40))),
        Holo(SubHolo(Vector(0,35,80),Angle(0,12,0),"models/props_combine/headcrabcannister01a.mdl",Vector(0.4,0.5,0.5),false,Color(255,40,40))),
        Holo(SubHolo(Vector(0,-30,64),Angle(0,0,90),"models/props_combine/combine_emitter01.mdl",Vector(1,2,1.2),false,Color(255,40,40))),
        Holo(SubHolo(Vector(0,30,64),Angle(0,0,-90),"models/props_combine/combine_emitter01.mdl",Vector(1,2,1.2),false,Color(255,40,40)))
    ),
    rightarm = {
        hologram.createPart(
            Holo(Rig(Vector(-3,-85,26),Angle(0,-90,0))),
            Holo(SubHolo(Vector(-3,-110,7),Angle(0,90,0),"models/props_combine/CombineTrain01a.mdl",Vector(0.18,0.3,0.12),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-3,-130,32),Angle(-90,90,0),"models/props_combine/combineinnerwallcluster1024_003a.mdl",Vector(0.08,0.06,0.10),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-3,-69,30),Angle(220,270,180),"models/props_combine/combine_barricade_med02a.mdl",Vector(0.4,0.4,0.4),false,Color(255,40,40)))
        ),
        hologram.createPart(
            Holo(Rig(Vector(-3,-170,26),Angle(0,-90,0))),
            Holo(SubHolo(Vector(-3,-200,9),Angle(0,90,0),"models/props_combine/CombineTrain01a.mdl",Vector(0.16,0.26,0.10),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-3,-220,24),Angle(-90,90,0),"models/props_combine/combineinnerwallcluster1024_003a.mdl",Vector(0.06,0.04,0.08),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-3,-200,40),Angle(-105,-90,180),"models/props_combine/tprotato2.mdl",Vector(0.8,0.8,0.8),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-3,-190,24),Angle(270,90,0),"models/props_combine/combine_mortar01b.mdl",Vector(1.2),false,Color(255,40,40)))
        ),
        hologram.createPart(
            Holo(Rig(Vector(-3,-253,24),Angle(0,-90,0))),
            Holo(SubHolo(Vector(-3,-260,24),Angle(280,90,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.2,0.34,0.4),false,Color(255,40,40,255),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(-3,-260,24),Angle(-260,90,180),"models/props_combine/combine_booth_short01a.mdl",Vector(0.2,0.34,0.4),false,Color(255,40,40,255),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(-16,-305,22),Angle(10,90,0),"models/props_combine/breenlight.mdl",Vector(2.8,2.8,2),false,Color(255,40,40,255),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(-3,-305,22),Angle(10,90,0),"models/props_combine/breenlight.mdl",Vector(2.8,2.8,2),false,Color(255,40,40,255),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(11,-305,22),Angle(10,90,0),"models/props_combine/breenlight.mdl",Vector(2.8,2.8,2),false,Color(255,40,40,255),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(-16,-295,4),Angle(80,90,0),"models/props_combine/breenlight.mdl",Vector(2.8,2.8,1.6),false,Color(255,40,40,255),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(-3,-295,4),Angle(80,90,0),"models/props_combine/breenlight.mdl",Vector(2.8,2.8,1.6),false,Color(255,40,40,255),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(11,-295,4),Angle(80,90,0),"models/props_combine/breenlight.mdl",Vector(2.8,2.8,1.6),false,Color(255,40,40,255),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(30,-270,24),Angle(0,20,-70),"models/props_combine/breenlight.mdl",Vector(2.8,2.8,2),false,Color(255,40,40,255),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(30,-295,18),Angle(0,-25,-90),"models/props_combine/breenlight.mdl",Vector(2.8,2.8,1.5),false,Color(255,40,40,255),"models/props_combine/metal_combinebridge001"))
        ),
        hologram.createPart(
            Holo(Rig(Vector(-3,-170,26),Angle(0,-90,0))),
            Holo(SubHolo(Vector(-2,-230,48),Angle(-90,90,0),"models/props_combine/combineinnerwall001a.mdl",Vector(0.06,0.1,0.09),false,Color(255,40,40,255),"")),
            Holo(SubHolo(Vector(-8,-230,48),Angle(-90,90,0),"models/props_combine/combineinnerwall001a.mdl",Vector(0.06,0.1,0.09),false,Color(255,40,40,255),"")),    
            Holo(SubHolo(Vector(-9.1,-255,53),Angle(-90,90,0),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(0.04,0.005,0.125),true,Color(255,40,40,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(-9.1,-298.1,56),Angle(-55,-90,0),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(0.03,0.005,0.025),true,Color(255,40,40,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(-9.1,-278.1,56.2),Angle(-55,-90,0),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(0.03,0.005,0.025),true,Color(255,40,40,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(-9.1,-258.1,56.2),Angle(-55,-90,0),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(0.03,0.005,0.025),true,Color(255,40,40,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(-9.1,-238.1,56.2),Angle(-55,-90,0),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(0.03,0.005,0.025),true,Color(255,40,40,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(-9.1,-218.1,56.2),Angle(-55,-90,0),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(0.03,0.005,0.025),true,Color(255,40,40,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(2,-230,48),Angle(-90,90,0),"models/props_combine/combineinnerwall001a.mdl",Vector(0.06,0.17,0.09),false,Color(255,40,40,255),"")),
            Holo(SubHolo(Vector(4,-255,53),Angle(-90,90,0),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(0.04,0.005,0.125),true,Color(255,40,40,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(4,-298.1,56),Angle(-55,-90,0),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(0.03,0.005,0.025),true,Color(255,40,40,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(4,-278.1,56.2),Angle(-55,-90,0),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(0.03,0.005,0.025),true,Color(255,40,40,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(4,-258.1,56.2),Angle(-55,-90,0),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(0.03,0.005,0.025),true,Color(255,40,40,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(4,-238.1,56.2),Angle(-55,-90,0),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(0.03,0.005,0.025),true,Color(255,40,40,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(4,-218.1,56.2),Angle(-55,-90,0),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(0.03,0.005,0.025),true,Color(255,40,40,255),"models/debug/debugwhite"))
        )
    },
    leftarm = {
        hologram.createPart(
            Holo(Rig(Vector(-3,85,26),Angle(0,90,0))),
            Holo(SubHolo(Vector(-3,110,7),Angle(0,-90,0),"models/props_combine/CombineTrain01a.mdl",Vector(0.18,0.3,0.12),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-3,130,32),Angle(-90,-90,0),"models/props_combine/combineinnerwallcluster1024_003a.mdl",Vector(0.08,0.06,0.10),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-3,69,30),Angle(220,-270,180),"models/props_combine/combine_barricade_med02a.mdl",Vector(0.4,0.4,0.4),false,Color(255,40,40)))
        ),
        laser = {
            hologram.createPart(
                Holo(Rig(Vector(-3,170,26),Angle(0,90,0))),
                Holo(SubHolo(Vector(-3,174,24),Angle(90,90,0),"models/hunter/tubes/circle2x2.mdl",Vector(0.5,0.5,6),false,Color(255,40,40,255),"models/props_combine/metal_combinebridge001")),
                Holo(SubHolo(Vector(-3,242,24),Angle(90,90,0),"models/hunter/tubes/circle2x2.mdl",Vector(0.46,0.46,5.5),false,Color(255,40,40,255),"models/props_combine/metal_combinebridge001")),
                laserTube(0),
                laserTube(45),
                laserTube(90),
                laserTube(135),
                laserTube(180),
                laserTube(-135),
                laserTube(-90),
                laserTube(-45)
            ),
            hologram.createPart(
                Holo(Rig(Vector(-3,208,24),Angle(0,90,0))),
                Holo(SubHolo(Vector(-3,208,24),Angle(90,90,0),"models/hunter/tubes/circle2x2.mdl",Vector(0.28,0.28,18),true,Color(255,40,40,255),"models/debug/debugwhite")),
                Holo(SubHolo(Vector(-3,208,36.5),Angle(90,90,0),"models/hunter/tubes/circle2x2.mdl",Vector(0.04,0.04,18),false,Color(255,40,40,255),"models/props_combine/metal_combinebridge001")),
                Holo(SubHolo(Vector(-3,208,11.5),Angle(90,90,0),"models/hunter/tubes/circle2x2.mdl",Vector(0.04,0.04,18),false,Color(255,40,40,255),"models/props_combine/metal_combinebridge001")),
                Holo(SubHolo(Vector(-16,208,24),Angle(90,90,0),"models/hunter/tubes/circle2x2.mdl",Vector(0.04,0.04,18),false,Color(255,40,40,255),"models/props_combine/metal_combinebridge001")),
                Holo(SubHolo(Vector(10,208,24),Angle(90,90,0),"models/hunter/tubes/circle2x2.mdl",Vector(0.04,0.04,18),false,Color(255,40,40,255),"models/props_combine/metal_combinebridge001"))
            ),
            hologram.createPart(
                Holo(Rig(Vector(-3,250,24),Angle(0,90,0))),
                Holo(SubHolo(Vector(-3,250,24),Angle(90,90,0),"models/hunter/tubes/tube1x1x1.mdl",Vector(0.7,0.7,0.15),false,Color(255,40,40,255),"models/props_combine/metal_combinebridge001")),
                Holo(SubHolo(Vector(-3,250,24),Angle(90,90,0),"models/hunter/tubes/circle2x2.mdl",Vector(0.3,0.3,3),true,Color(255,40,40,255),"models/debug/debugwhite")),
                prong(0),
                prong(90),
                prong(180),
                prong(-90)
            )
        }
    }
}


