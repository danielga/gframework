gframework.privilege = {}

PRIVILEGES_RESET = -1
PRIVILEGES_ADD = 0
PRIVILEGES_REVOKE = 1

function _R.Player:GetPrivileges()
	if self.GFrameworkData then
		return self.GFrameworkData.Privileges
	end
end

function _R.Player:HasPrivilege(privilege)
	if self.GFrameworkData and self.GFrameworkData.Privileges then
		return table.HasValue(self.GFrameworkData.Privileges, privilege)
	end
end