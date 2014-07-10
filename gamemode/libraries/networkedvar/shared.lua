gframework.networkedvar = gframework.networkedvar or {}
gframework.nwvar = gframework.networkedvar

local ENTITY = FindMetaTable("Entity")

function ENTITY:GetNetworkedVar(varname, default)
	return gframework.networkedvar:GetEntityNetworkedVar(self, varname, default)
end

ENTITY.GetNWVar = ENTITY.GetNetworkedVar

function ENTITY:SetNetworkedVarCallback(uniquename, callback)
	return gframework.networkedvar:SetEntityNetworkedVarCallback(self, uniquename, callback)
end

ENTITY.SetNWVarCallback = ENTITY.SetNetworkedVarCallback