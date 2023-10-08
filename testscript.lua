local http = require 'gamesense/http'
local ffi = require("ffi") or error("Failed to require FFI, please make sure Allow unsafe scripts is enabled!", 2)

ffi.cdef[[
    typedef long(__thiscall* GetRegistryString)(void* this, const char* pFileName, const char* pPathID);
    typedef bool(__thiscall* Wrapper)(void* this, const char* pFileName, const char* pPathID);
]]

local type2 = ffi.typeof("void***")
local interface = client.create_interface("filesystem_stdio.dll", "VBaseFileSystem011") or error("Error", 2)
local system10 = ffi.cast(type2, interface) or error("Error", 2)
local systemxwrapper = ffi.cast("Wrapper", system10[0][10]) or error("Error", 2)
local gethwid = ffi.cast("GetRegistryString", system10[0][13]) or error("Error", 2)

-- Funkcja do uzyskiwania HWID
local function getHWID()
    for i = 65, 90 do
        local driveLetter = string.char(i)
        local filecheck = driveLetter .. ":\\Windows\\Setup\\State\\State.ini"

        if systemxwrapper(system10, filecheck, "olympia") then
            local hwid = gethwid(system10, filecheck, "olympia")
            return hwid
        end
    end
    return nil
end

local hwid = getHWID()


http.get('http://localhost/gengarlogin/secondcheck.php?hwid=' .. hwid, function(success, response)
    if response.body == "trueprawdziwygosc" then
        http.get('https://raw.githubusercontent.com/PrinceABN/HvH-Stuff/main/interitus.lua', function(success, response)
            if not success or response.status ~= 200 then
                print('Failed to fetch Lua code from the server.')
                return
            end
    else
        print("Nuh uh")
    end
end)
