gframework.hook = gframework.hook or {}

gframework.hook._Call = gframework.hook._Call or hook.Call

local gframeworkPlugin = gframework.plugin
local hookCall = gframework.hook._Call
local SCHEMA = SCHEMA
function hook.Call(name, gamemode, ...)
	for _, plugin in pairs(gframeworkPlugin:GetAll()) do
		if plugin[name] then
			local a, b, c, d, e, f, g, h = plugin[name](...)
			if a ~= nil then
				return a, b, c, d, e, f, g, h
			end
		end
	end

	if SCHEMA[name] then
		local a, b, c, d, e, f, g, h = SCHEMA[name](...)
		if a ~= nil then
			return a, b, c, d, e, f, g, h
		end
	end

	return hookCall(name, gamemode, ...)
end