gframework.privilege = gframework.privilege or {}

local PLAYER = FindMetaTable("Player")

PRIVILEGES_RESET = -1
PRIVILEGES_ADD = 0
PRIVILEGES_REVOKE = 1

function PLAYER:GetPrivileges()
	if self.GFrameworkData then
		return self.GFrameworkData.Privileges
	end
end

function PLAYER:HasPrivilege(privilege)
	if self.GFrameworkData and self.GFrameworkData.Privileges then
		return table.HasValue(self.GFrameworkData.Privileges, privilege)
	end
end