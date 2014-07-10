gframework.schema = gframework.schema or {}

gframework.schema.table = gframework.schema.table or {}
gframework.schema.hookCall = gframework.schema.hookCall or hook.Call

function gframework.schema:GetName()
	return self.table and (self.table.Name or "no name") or "no schema"
end

function gframework.schema:GetFolderName()
	if self.table then
		return self.table.FolderName
	end
end

function gframework.schema:Initialize()
	local name = engine.ActiveGamemode()
	if name == "base" then
		print("gframework was unable to initialize the schema because the active gamemode is not set or set to 'base'.")
		return
	end

	local path = name .. "/schema/sh_schema.lua"
	if not file.Exists(path, "LUA") then
		print("gframework was unable to initialize the schema '" .. name .. "'.")
		return
	end

	SCHEMA = gframework.schema.table
	SCHEMA.FolderName = name

	gframework:Include(path)
end

local gframework = gframework
local hookCall = gframework.schema.hookCall
function hook.Call(name, gamemode, ...)
	for _, plugin in pairs(gframework.plugin:GetAll()) do
		if plugin[name] then
			local a, b, c, d, e, f, g, h = plugin[name](...)
			if a ~= nil then
				return a, b, c, d, e, f, g, h
			end
		end
	end

	local schema = SCHEMA
	if schema then
		if schema[name] then
			local a, b, c, d, e, f, g, h = schema[name](...)
			if a ~= nil then
				return a, b, c, d, e, f, g, h
			end
		end
	else
		gframework.schema:Initialize()
	end

	return hookCall(name, gamemode, ...)
end