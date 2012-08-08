AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function GM:GetGameDescription()
	return self.Name or "Gamemode Framework"
end

gframework:IncludeLibraries()