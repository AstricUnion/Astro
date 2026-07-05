-- This is NOT a Starfall script. This is builder for BMod (WIP)

local folder = arg[1]
local fileToBuild = arg[2]

local pattern_escape_replacements = {
	["("] = "%(",
	[")"] = "%)",
	["."] = "%.",
	["%"] = "%%",
	["+"] = "%+",
	["-"] = "%-",
	["*"] = "%*",
	["?"] = "%?",
	["["] = "%[",
	["]"] = "%]",
	["^"] = "%^",
	["$"] = "%$",
	["\0"] = "%z"
}

local function patternSafe( str )
	return ( string.gsub( str, ".", pattern_escape_replacements ) )
end

local function getRequirePatternForFile(file)
    return "require *%(* *\"" .. folder .. "/" .. file .. "\" *%)*"
end

local function getDoDirPatternForFile(file)
    return "dodir *%(* *\"" .. folder .. "/" .. file .. "\" *, *{} *%)*"
end

local FILEPATTERN = "([a-zA-Z/0-9%._-]+)"
local REQUIREPATTERN = getRequirePatternForFile(FILEPATTERN)
local VARREQUIREPATTERN = "= *" .. REQUIREPATTERN
local DODIRPATTERN = getDoDirPatternForFile(FILEPATTERN)

-- got it from https://stackoverflow.com/questions/5303174/how-to-get-list-of-directories-in-lua
-- TODO: windows version
local function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls "'..directory..'"')
    if not pfile then return end
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

---Function to require all chips in one file. Recursive for all required files
---@param path string Path to file
---@return file*?
---@return string?
local function requireAll(path)
    local f = io.open(path, "rb")
    if not f then return end
    local content = f:read("*a")

    -- Firstly, we should replace all require with variables
    for v in string.gmatch(content, VARREQUIREPATTERN) do
        local f2, content2 = requireAll(v)
        if not f2 or not content2 then return end
        local str = string.format("=(function() %s end)()", string.gsub(content2, "%%", "%%%%"))
        local patt = " *= *" .. getRequirePatternForFile(patternSafe(v))
        content = string.gsub(content, patt, str)
    end

    -- Secondly, we should replace all require without variable, or we can got error about "ambigous syntax"
    for v in string.gmatch(content, REQUIREPATTERN) do
        local f2, content2 = requireAll(v)
        if not f2 or not content2 then return end
        local str = string.format("do _=(function() %s end)() end", string.gsub(content2, "%%", "%%%%"))
        local patt = getRequirePatternForFile(patternSafe(v))
        content = string.gsub(content, patt, str)
    end

    -- And dodir, to include all directory files
    for v in string.gmatch(content, DODIRPATTERN) do
        local files = scandir(v)
        if not files then return end
        local functions = {}
        for _, file in ipairs(files) do
            local f2, content2 = requireAll(v .. "/" .. file)
            if not f2 or not content2 then goto cont end
            local str = string.format("_=(function() %s end)()", string.gsub(content2, "%%", "%%%%"))
            functions[#functions+1] = str
            ::cont::
        end
        local toPlace = table.concat(functions, "\n")
        local patt = getDoDirPatternForFile(patternSafe(v))
        content = string.gsub(content, patt, "do " .. toPlace .. " end")
    end

    return f, content
end

local _, content = requireAll(fileToBuild)
if not content then return end
-- local chipName = string.match(content, "-%-+ *@name (.-)\n")
-- local chipAuthor = string.match(content, "-%-+ *@author (.-)\n")
-- local chipSide = string.match(content, "-%-+ *@(shared|server|servermain|client|clientmain)$") or "shared"
-- content = string.gsub(content, "-%-+%[%[.-%]%]", "")
-- content = string.gsub(content, "-%-.-\n", "\n")
-- remove empty lines. this is from DuckDuckGo AI, so TODO: make it simpler
content = string.gsub(content, "(\r?\n)%s*\r?\n", "%1")
content = string.gsub(content, "\n *", "\n")
-- content = string.format("---@name %s\n---@author %s\n---@%s\n%s", chipName, chipAuthor, chipSide, content)

local output = io.open("builded_" .. fileToBuild, "wb")
if not output then return end
output:write(content)
