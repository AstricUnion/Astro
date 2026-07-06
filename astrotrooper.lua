---@name AstroTrooper
---@author AstricUnion
---@include astronew/libs/astrosound/astrosound.lua
---@include astronew/libs/bmodentity/entity.lua
---@include astronew/libs/model/model.lua
---@include astronew/libs/tween/tweens.lua
---@include astronew/libs/beffect/effects.lua
---@include astronew/libs/beffect/safeparticle.lua
---@include astronew/libs/utils.lua
---@include astronew/libs/projectile.lua
---@include astronew/libs/astrogui.lua
---@include astronew/src/astrobase.lua
---@include astronew/models/astrotrooper.lua
---@include astronew/entities/astroblaster.lua
---@include astronew/entities/astrowarpdash.lua
---@include astronew/entities/astrotrooper.lua

---@class astrosound
astrosound = require("astronew/libs/astrosound/astrosound.lua")

---@class ents
ents = require("astronew/libs/bmodentity/entity.lua")

---@class model
model = require("astronew/libs/model/model.lua")

---@class tween 
tween = require("astronew/libs/tween/tweens.lua")

---@class beff
beff = require("astronew/libs/beffect/effects.lua")
require("astronew/libs/beffect/safeparticle.lua")

---@class astrogui
astrogui = require("astronew/libs/astrogui.lua")

---@class astroutils
astroutils = require("astronew/libs/utils.lua")

---@class projectile
projectile = require("astronew/libs/projectile.lua")

---@includedir astronew/effects
dodir("astronew/effects", {})

require("astronew/models/astrotrooper.lua")

require("astronew/src/astrobase.lua")

require("astronew/entities/astroblaster.lua")
require("astronew/entities/astrowarpdash.lua")
require("astronew/entities/astrotrooper.lua")


if SERVER then
    local ent = ents.create("astrotrooper")
    ent:spawn(chip():getPos() + Vector(0, 0, 30), Angle(), false)
end
