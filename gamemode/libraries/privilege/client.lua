include("shared.lua")

local privilegeList = {}

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

local function gframeworkPrivilegesUpdate(msg)
	local action = msg:ReadChar()
	local target = msg:ReadEntity()
	if not target.GFrameworkData then
		target.GFrameworkData = {}
	end

	if action == PRIVILEGES_RESET then
		target.GFrameworkData.Privileges = {}
	elseif action == PRIVILEGES_ADD then
		local privilege = gframework.privilege:GetPrivilegeName(msg:ReadShort())
		table.insert(target.GFrameworkData.Privileges, privilege)
	elseif action == PRIVILEGES_REVOKE then
		local privilege = gframework.privilege:GetPrivilegeName(msg:ReadShort())
		for key, privname in pairs(target.GFrameworkData.Privileges) do
			if privname == privilege then
				table.remove(target.GFrameworkData.Privileges, key)
				break
			end
		end
	end
end
usermessage.Hook("gfwPrivUpdate", gframeworkPrivilegesUpdate)

local function gframeworkPrivilegesAdd(msg)
	local privilege = msg:ReadString()
	local index = msg:ReadShort()
	privilegeList[index] = privilege
end
usermessage.Hook("gfwPrivAdd", gframeworkPrivilegesAdd)