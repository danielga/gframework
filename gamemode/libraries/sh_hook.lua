gframework.hook = {}

local hookList = {}
local hookCall = hook.Call

function gframework.hook:Add(name, uniquename, callback)
	if not hookList[name] then
		hookList[name] = {}
	end

	hookList[name][uniquename] = callback
end

function gframework.hook:Remove(name, uniquename)
	if hookList[name] then
		hookList[name][uniquename] = nil
	end
end

function gframework.hook:GetTable()
	return hookList
end

function gframework.hook:Call(name, gamemode, ...)
	if hookList[name] then
		for uniquename, callback in pairs(hookList[name]) do
			local returns = {pcall(callback, ...)}
			if not returns[1] then
				ErrorNoHalt(returns[2] .. "\n")
			elseif #returns > 1 then
				return unpack(returns, 2)
			end
		end
	end

	gframework.gamemode:Call(name, ...)
end

function hook.Call(name, gamemode, ...)
	if not gamemode then
		gamemode = gframework
	end
	
	local returns = {gframework.hook:Call(name, nil, ...)}
	
	if #returns > 0 then
		return unpack(returns)
	else
		return hookCall(name, gamemode, ...)
	end
end