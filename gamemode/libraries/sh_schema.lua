gframework.schema = gframework.schema or {}

gframework.schema.table = gframework.schema.table or {}

function gframework.schema:Get()
	return self.table
end

function gframework.schema:GetName()
	return self.table and (self.table.Name or "no name") or "no schema"
end

function gframework.schema:GetFolderName()
	if self.table then
		return self.table.FolderName
	end
end

function gframework.schema:Initialize()
	local name
	if SERVER then
		name = engine.ActiveGamemode()
		util.AddNetworkString("gframework_" .. name)
	else
		for i = 1, 2047 do
			local temp = util.NetworkIDToString(i)
			if not temp then
				break
			end

			temp = temp:match("^gframework_(.*)$")
			if temp then
				name = temp
				break
			end
		end
	end

	if not name or name == "base" then
		print("gframework was unable to initialize the schema because the active gamemode is not set or set to 'base'.")
		return
	end

	local sh_schema = name .. "/schema/sh_schema.lua"
	local sv_init = name .. "/schema/sv_init.lua"
	local cl_init = name .. "/schema/cl_init.lua"
	if not file.Exists(sh_schema, "LUA") or not file.Exists(sv_init, "LUA") or not file.Exists(cl_init, "LUA") then
		print("gframework was unable to initialize the schema '" .. name .. "'.")
		return
	end

	SCHEMA = gframework.schema.table
	SCHEMA.FolderName = name

	gframework:Include(path)
end

gframework.schema:Initialize()