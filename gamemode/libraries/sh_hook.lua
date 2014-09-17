gframework.hook = gframework.hook or {}

gframework.hook._Call = gframework.hook._Call or hook.Call

local hookCall = gframework.hook._Call
function hook.Call(name, gamemode, ...)
	local gframeworkPlugin = gframework.plugin
	if gframeworkPlugin then
		for _, plugin in pairs(gframeworkPlugin:GetAll()) do
			if plugin[name] then
				local a, b, c, d, e, f, g, h = plugin[name](...)
				if a ~= nil then
					return a, b, c, d, e, f, g, h
				end
			end
		end
	end

	local SCHEMA = SCHEMA
	if SCHEMA and SCHEMA[name] then
		local a, b, c, d, e, f, g, h = SCHEMA[name](...)
		if a ~= nil then
			return a, b, c, d, e, f, g, h
		end
	end

	return hookCall(name, gamemode, ...)
end