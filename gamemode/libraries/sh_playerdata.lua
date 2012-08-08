gframework.playerdata = {}
gframework.pdata = gframework.playerdata

function gframework.playerdata:GetPlayerData(ply, varname, default)
	if not IsValid(ply) or not ply:IsPlayer() then
		return
	end

	return ply:GetNetworkedVar("GFWPlayerData_" .. varname, default)
end

function _R.Player:GetPlayerData(varname, default)
	return gframework.playerdata:GetPlayerData(self, varname, default)
end