AddCSLuaFile("client.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local networkedvarList = {}
local networkedvarCallbacks = {}

local ENTITY = FindMetaTable("Entity")

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

function gframework.networkedvar:SendEntityVariablesToPlayer(entindex, ply)
	local info = {}
	for varname, value in pairs(networkedvarList[entindex]) do
		table.insert(info, varname)
		table.insert(info, value)
	end

	gframework.usermessage:SendUsermessage("gfwNWupdate", ply, entindex, unpack(info))
end

function gframework.networkedvar:SendAllVariablesToPlayer(ply)
	for entindex, _ in pairs(networkedvarList) do
		self:SendEntityVariablesToPlayer(entindex, ply)
	end
end

function gframework.networkedvar:SetEntityNetworkedVar(ent, varname, value)
	if not IsValid(ent) then
		return
	end

	local entindex = ent:EntIndex()
	if not networkedvarList[entindex] then
		networkedvarList[entindex] = {}
	end

	if networkedvarList[entindex][varname] ~= value then
		if networkedvarCallbacks[entindex] then
			for _, callback in pairs(networkedvarCallbacks[entindex]) do
				pcall(callback, ent, varname, networkedvarList[entindex][varname], value)
				print(ent, varname, networkedvarList[entindex][varname], value)
			end
		end

		gframework.usermessage:SendUsermessage("gfwNWupdate", ply, entindex, varname, value)
	end

	networkedvarList[entindex][varname] = value
end

gframework.networkedvar.SetEntityNWVar = gframework.networkedvar.SetEntityNetworkedVar

function ENTITY:SetNetworkedVar(varname, value)
	gframework.networkedvar:SetEntityNetworkedVar(self, varname, value)
end

ENTITY.SetNWVar = ENTITY.SetNetworkedVar

local function gframeworkEntityRemoved(ent)
	if not IsValid(ent) then
		return
	end

	local entindex = ent:EntIndex()
	networkedvarList[entindex] = nil
	networkedvarCallbacks[entindex] = nil

	umsg.Start("gfwNWclean")
		umsg.Float(entindex)
	umsg.End()
end
hook.Add("EntityRemoved", "gframework.networkedvar.EntityRemoved", gframeworkEntityRemoved)

local function gframeworkPlayerInitialSpawn(ply)
	if not IsValid(ply) then
		return
	end

	gframework.networkedvar:SendAllVariablesToPlayer(ply)
end
hook.Add("PlayerInitialSpawn", "gframework.networkedvar.PlayerInitialSpawn", gframeworkPlayerInitialSpawn)