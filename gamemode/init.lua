local loading_start = SysTime()

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

print("gframework took " .. math.Round(SysTime() - loading_start, 3) .. " second(s) to initialize.")