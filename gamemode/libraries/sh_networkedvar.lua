gframework.networkedvar = {}
gframework.nwvar = gframework.networkedvar

function _R.Entity:GetNetworkedVar(varname, default)
	return gframework.networkedvar:GetEntityNetworkedVar(self, varname, default)
end

_R.Entity.GetNWVar = _R.Entity.GetNetworkedVar

function _R.Entity:SetNetworkedVarCallback(uniquename, callback)
	return gframework.networkedvar:SetEntityNetworkedVarCallback(self, uniquename, callback)
end

_R.Entity.SetNWVarCallback = _R.Entity.SetNetworkedVarCallback