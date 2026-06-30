---@name AstroSound
---@author AstricUnion

---@class PlaySound
---@field identifier string? Identifier of sound
---@field pos Vector? Position of sound. By default Vector(). If you provided ent parameter, it will be offset
---@field ent Entity? Entity to parent sound
---@field volume number? Volume of sound (0-10), by default 1
---@field pitch number? Pitch of sound (0-100), by default 1
---@field fadeMin number? Minimal fading distance for sound (50 - 100). By default 50
---@field fadeMax number? Maximal fading distance for sound (5 000 - 200 000). By default 20000
---@field useSimpleFade boolean? Use simple fade. By default true
---@field looping boolean? Loop sound. By default false. Looping sounds have protection from deleting for limits

---@class SoundParent
---@field offset Vector
---@field ent Entity
---@field snd Bass

---Lib to preload URL and file sounds
---@class astrosound
---@field preloaded table<string, string>
---@field playing table<string, Bass[]>
---@field parent SoundParent[] Sounds to parent
---@field loads number How many sounds loads now
local astrosound = {}
astrosound.preloaded = {}
astrosound.loads = 0
astrosound.playing = {}
astrosound.parent = {}


local function garbageCollector()
    local soundsLeft = bass.soundsLeft()
    if soundsLeft > 2 then return end
    for id, v in pairs(astrosound.playing) do
        if soundsLeft > 2 then break end
        local newSounds = {}
        for _, snd in ipairs(v) do
            if isValid(snd) then
                local loop = !snd:isLooping()
                if (!loop and soundsLeft < 3) or (loop and soundsLeft < 2) or snd:getTime() == snd:getLength() then
                    snd:stop()
                    soundsLeft = soundsLeft + 1
                    goto cont
                end
                newSounds[#newSounds+1] = snd
            else
                soundsLeft = soundsLeft + 1
            end
            if soundsLeft > 2 then break end
            ::cont::
        end
        astrosound.playing[id] = newSounds
    end
end


---[SHADER] Play preloaded sound
---@param tbl PlaySound
function astrosound.play(tbl)
    local identifier = tbl.identifier or tbl[1] or throw("Missed parameter \"identifier\" in sound playing")
    local pos = tbl.pos or tbl[2] or Vector()
    local ent = tbl.ent or tbl[3]
    local volume = tbl.volume or tbl[4] or 1
    local pitch = tbl.pitch or tbl[5] or 1
    local fadeMin = tbl.fadeMin or tbl[6] or 50
    local fadeMax = tbl.fadeMax or tbl[7] or 20000
    local useAdvancedFade = !(tbl.useSimpleFade == nil and tbl[8] or tbl.useSimpleFade)
    local looping = tbl.looping or tbl[9] or false
    if CLIENT then
        local path = astrosound.preloaded[identifier]
        if !path then return end
        garbageCollector()
        bass.loadFile(path, "3d noblock", function(snd)
            if !snd then return end
            local currentPlaying = astrosound.playing[identifier] or {}
            currentPlaying[#currentPlaying+1] = snd
            astrosound.playing[identifier] = currentPlaying
            if isValid(ent) then
                astrosound.parent[#astrosound.parent+1] = { snd = snd, ent = ent, offset = pos }
                snd:setPos(ent:localToWorld(pos))
            else
                snd:setPos(pos)
            end
            snd:setVolume(volume)
            snd:setPitch(pitch)
            snd:setFade(fadeMin, fadeMax, !useAdvancedFade)
            snd:setLooping(looping)
        end)
    else
        net.start("AstroSoundPlay")
            net.writeTable(tbl)
            if isValid(ent) then
                net.writeBool(true)
                net.writeEntity(ent)
            else
                net.writeBool(false)
            end
        net.send(find.allPlayers())
    end
end


if CLIENT then
    ---[CLIENT] Preload sound
    ---@param identifier string Unique identifier of sound
    ---@param path string Path to sound
    function astrosound.preloadFile(identifier, path)
        astrosound.preloaded[identifier] = path
    end

    ---[CLIENT] Preload URL sound
    ---@param identifier string Unique identifier of sound
    ---@param url string URL of sound
    function astrosound.preloadURL(identifier, url)
        astrosound.loads = astrosound.loads + 1
        -- TODO: coroutine
        timer.simple(0.5 * astrosound.loads, function()
            http.get(url, function(body)
                local path = file.writeTemp(identifier .. ".txt", body)
                astrosound.preloaded[identifier] = path
                astrosound.loads = astrosound.loads - 1
            end)
        end)
    end

    hook.add("Think", "AstroSoundParent", function()
        if table.isEmpty(astrosound.parent) then return end
        local newParent = {}
        for _, v in ipairs(astrosound.parent) do
            if isValid(v.snd) and isValid(v.ent) then
                newParent[#newParent+1] = v
                v.snd:setPos(v.ent:localToWorld(v.offset))
            end
        end
        astrosound.parent = newParent
    end)

    net.receive("AstroSoundPlay", function()
        local tbl = net.readTable()
        local isEnt = net.readBool()
        if !isEnt then
            astrosound.play(tbl)
        else
            net.readEntity(function(ent)
                tbl.ent = ent
                astrosound.play(tbl)
            end)
        end
    end)
end


return astrosound
