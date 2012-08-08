gframework.gamemode = {}
gframework.gm = gframework.gamemode

local gmtable = nil

function gframework.gamemode:Set(tbl)
	gmtable = tbl
end

function gframework.gamemode:Get()
	return gmtable
end

function gframework.gamemode:GetName()
	return gmtable and (gmtable.name or "No name") or "No gamemode"
end

function gframework.gamemode:Call(name, ...)
	if gmtable and gmtable[name] then
		return gmtable[name](...)
	end
end