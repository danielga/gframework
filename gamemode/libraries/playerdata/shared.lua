gframework.playerdata = gframework.playerdata or {}
gframework.pdata = gframework.playerdata

local PLAYER = FindMetaTable("Player")

function gframework.playerdata:GetPlayerData(ply, varname, default)
	if not IsValid(ply) or not ply:IsPlayer() then
		return
	end

	return ply:GetNetworkedVar("GFWPlayerData_" .. varname, default)
end

function PLAYER:GetPlayerData(varname, default)
	return gframework.playerdata:GetPlayerData(self, varname, default)
end