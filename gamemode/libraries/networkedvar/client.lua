include("shared.lua")

local networkedvarList = {}
local networkedvarCallbacks = {}

function gframework.networkedvar:GetEntityNetworkedVar(ent, varname, default)
	if not IsValid(ent) then
		return
	end

	local entindex = ent:EntIndex()
	if networkedvarList[entindex] then
		return networkedvarList[entindex][varname] or default
	end
end

gframework.networkedvar.GetEntityNWVar = gframework.networkedvar.GetEntityNetworkedVar

function gframework.networkedvar:SetEntityNetworkedVarCallback(ent, uniquename, callback)
	if not IsValid(ent) then
		return
	end

	local entindex = ent:EntIndex()
	if not networkedvarCallbacks[entindex] then
		networkedvarCallbacks[entindex] = {}
	end

	networkedvarCallbacks[entindex][uniquename] = callback
end

gframework.networkedvar.SetEntityNWVarCallback = gframework.networkedvar.SetEntityNetworkedVarCallback

local function gframeworkNetworkedVarUpdate(msg)
	local entindex = msg:ReadFloat()
	local varname = msg:ReadString()
	local value = msg:ReadString()

	if not networkedvarList[entindex] then
		networkedvarList[entindex] = {}
	end

	if networkedvarCallbacks[entindex] then
		for _, callback in pairs(networkedvarCallbacks[entindex]) do
			pcall(callback, Entity(entindex), varname, networkedvarList[entindex][varname], value)
			print(Entity(entindex), varname, networkedvarList[entindex][varname], value)
		end
	end

	networkedvarList[entindex][varname] = value
end
usermessage.Hook("gfwNWupdate", gframeworkNetworkedVarUpdate)

local function gframeworkNetworkedVarClean(msg)
	local entindex = msg:ReadFloat()
	networkedvarList[entindex] = nil
	networkedvarCallbacks[entindex] = nil
end
usermessage.Hook("gfwNWclean", gframeworkNetworkedVarClean)