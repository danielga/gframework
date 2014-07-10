gframework.plugin = gframework.plugin or {}

gframework.plugin.list = gframework.plugin.list or {}

function gframework.plugin:GetAll()
	return gframework.plugin.list
end

function gframework.plugin:Get(name)
	return gframework.plugin.list[name]
end

function gframework.plugin:Load(name, frombase)
	local directory = "/plugins/" .. name
	if frombase then
		directory = "gframework" .. directory
	else
		directory = SCHEMA.FolderName .. directory
	end

	local path = directory .. "/sh_plugin.lua"
	if file.Exists(path, "LUA") then
		PLUGIN = self:Get(name) or {}

		gframework:Include(path)

		self.list[name] = PLUGIN

		PLUGIN = nil

		return true
	end

	return false
end

function gframework.plugin:Initialize(frombase)
	local _, folders = file.Find(frombase and "gframework/plugins/*" or (SCHEMA.FolderName .. "/plugins/*"), "LUA")
	for i = 1, #folders do
		self:Load(folders[i], frombase)
	end
end