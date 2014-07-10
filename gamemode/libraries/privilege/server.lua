AddCSLuaFile("client.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local privilegeList = {}

local PLAYER = FindMetaTable("Player")

function gframework.privilege:GetPrivilegeIndex(name)
	for index, privilege in pairs(privilegeList) do
		if privilege == name then
			return index
		end
	end
end

function gframework.privilege:GetPrivilegeName(index)
	return privilegeList[index]
end

local function escapeText(text)
	--return gframework.database:EscapeText(text)
end

local function databaseQueryFailed(error)
	ErrorNoHalt(error .. "\n")
end

local function databaseQueryComplete(data, ply)
	if data[1] == nil then
		--gframework.database:Query("INSERT INTO test VALUES (" .. escapeText(ply:SteamID()) .. ", " .. escapeText("") .. ", " .. escapeText("") .. ")")
	else
		local privileges = {}
		if data[1].Privileges ~= nil and data[1].Privileges ~= "" then
			for _, privilege in ipairs(string.Explode(";", data[1].Privileges)) do
				gframework.privilege:AddPrivilege(privilege)
				table.insert(privileges, privilege)
			end
		end

		ply:SetPrivileges(privileges, true)
	end
end

function PLAYER:GivePrivilege(privilege)
	if not table.HasValue(self.GFrameworkData.Privileges, privilege) then
		table.insert(self.GFrameworkData.Privileges, privilege)

		umsg.Start("gfwPrivUpdate")
			umsg.Char(PRIVILEGES_ADD)
			umsg.Entity(self)
			umsg.Short(gframework.privilege:GetPrivilegeIndex(privilege))
		umsg.End()

		--gframework.database:Query("UPDATE test SET Privileges = " .. escapeText(table.concat(self.GFrameworkData.Privileges, ";")) .. " WHERE SteamID = " .. escapeText(self:SteamID()))
	end
end

function PLAYER:RevokePrivilege(privilege)
	for key, priv in ipairs(self.GFrameworkData.Privileges) do
		if priv == privilege then
			table.remove(self.GFrameworkData.Privileges, key)
			umsg.Start("gfwPrivUpdate")
				umsg.Char(PRIVILEGES_REVOKE)
				umsg.Entity(self)
				umsg.Short(gframework.privilege:GetPrivilegeIndex(privilege))
			umsg.End()

			--gframework.database:Query("UPDATE test SET Privileges = " .. escapeText(table.concat(self.GFrameworkData.Privileges, ";")) .. " WHERE SteamID = " .. escapeText(self:SteamID()))
			return
		end
	end
end

function PLAYER:RevokePrivileges()
	self.GFrameworkData.Privileges = {}

	umsg.Start("gfwPrivUpdate")
		umsg.Char(PRIVILEGES_RESET)
		umsg.Entity(self)
	umsg.End()

	--gframework.database:Query("UPDATE test SET Privileges = \"\" WHERE SteamID = " .. escapeText(self:SteamID()))
end

function PLAYER:SetPrivileges(privileges, noupdate)
	self.GFrameworkData.Privileges = privileges

	umsg.Start("gfwPrivUpdate")
		umsg.Char(PRIVILEGES_RESET)
		umsg.Entity(self)
	umsg.End()

	for _, privilege in ipairs(self.GFrameworkData.Privileges) do
		umsg.Start("gfwPrivUpdate")
			umsg.Char(PRIVILEGES_ADD)
			umsg.Entity(self)
			umsg.Short(gframework.privilege:GetPrivilegeIndex(privilege))
		umsg.End()
	end

	if not noupdate then
		--gframework.database:Query("UPDATE test SET Privileges = " .. escapeText(concat) .. " WHERE SteamID = " .. escapeText(self:SteamID()))
	end
end

function gframework.privilege:AddPrivilege(privilege)
	if not self:PrivilegeExists(privilege) then
		local index = table.insert(privilegeList, privilege)
		umsg.Start("gfwPrivAdd")
			umsg.String(privilege)
			umsg.Short(index)
		umsg.End()
	end
end

function gframework.privilege:PrivilegeExists(privilege)
	return table.HasValue(privilegeList, privilege)
end

function gframework.privilege:SendPrivilegesToPlayer(ply)
	for index, privilege in pairs(privilegeList) do
		umsg.Start("gfwPrivAdd", ply)
			umsg.String(privilege)
			umsg.Short(index)
		umsg.End()
	end
end

local function gframeworkPlayerInitialSpawn(ply)
	if not ply.GFrameworkData then ply.GFrameworkData = {} end

	ply.GFrameworkData.Privileges = {}

	gframework.privilege:SendPrivilegesToPlayer(ply)

	--gframework.database:Query("SELECT Privileges FROM test WHERE SteamID = " .. escapeText(ply:SteamID()), function(data) databaseQueryComplete(data, ply) end, databaseQueryFailed)
end
hook.Add("PlayerInitialSpawn", "gframework.privilege.PlayerInitialSpawn", gframeworkPlayerInitialSpawn)

local function gframeworkPlayerDisconnected(ply)
	--gframework.database:Query("UPDATE test SET Privileges = " .. escapeText(table.concat(ply.GFrameworkData.Privileges, ";")) .. " WHERE SteamID = " .. escapeText(ply:SteamID()))
end
hook.Add("PlayerDisconnected", "gframework.privilege.PlayerDisconnected", gframeworkPlayerDisconnected)