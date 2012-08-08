local function escapeText(text)
	return gframework.mysqldata:EscapeText(text)
end

local function databaseQueryFailed(error)
	ErrorNoHalt(error .. "\n")
end

local function databaseQueryComplete(data, ply)
	if data[1] == nil then
		gframework.mysqldata:Query("INSERT INTO test VALUES (" .. escapeText(ply:SteamID()) .. ", " .. escapeText("") .. ", " .. escapeText("") .. ")")
	else
		ply.GFrameworkData.PlayerData = gframework.playerdata:DecompressData(data[1].PlayerData)

		for varname, value in pairs(ply.GFrameworkData.PlayerData) do
			ply:SetPlayerData(varname, value)
		end
	end
end

function gframework.playerdata:CompressData(data)
	if data == nil then
		return ""
	end

	local first = true
	local text = ""
	for key, value in pairs(data) do
		if not first then
			text = text .. ","
		else
			text = text .. "{"
			first = false
		end

		local keytype = type(key)
		if keytype == "string" then
			text = text .. "\"" .. escapeText(key) .. "\":"
		elseif keytype == "number" then
			text = text .. key .. ":"
		end

		local valuetype = type(value)
		if valuetype == "string" then
			text = text .. "\"" .. escapeText(value) .. "\""
		elseif valuetype == "number" then
			text = text .. value
		elseif valuetype == "table" then
			text = text .. self:CompressData(value) .. ""
		end
	end

	if text == "" then
		return text
	else
		return text .. "}"
	end
end

function gframework.playerdata:DecompressData(text)
	if text == nil or text == "" then
		return {}
	end

	local first, last = string.sub(text, 1, 1), string.sub(text, -1, -1)
	if first == "{" and last == "}" then
		text = string.sub(text, 2, -2)
		local data = {}
		local exploded = string.Explode(",", text)
		for _, piece in ipairs(exploded) do
			local pos = string.find(piece, ":")
			local key, value = string.sub(piece, 1, pos - 1), string.sub(piece, pos + 1, -1)
			data[self:DecompressData(key)] = self:DecompressData(value)
		end

		return data
	elseif first == "\"" and last == "\"" then
		return string.sub(text, 2, -2)
	else
		return tonumber(text)
	end
end

function gframework.playerdata:SetPlayerData(ply, varname, value)
	if not IsValid(ply) or not ply:IsPlayer() then
		return
	end

	ply.GFrameworkData.PlayerData[varname] = value

	gframework.mysqldata:Query("UPDATE test SET PlayerData = " .. escapeText(gframework.playerdata:CompressData(ply.GFrameworkData.PlayerData)) .. " WHERE SteamID = " .. escapeText(ply:SteamID()))

	ply:SetNetworkedVar("GFWPlayerData_" .. varname, value)
end

function _R.Player:SetPlayerData(varname, value)
	gframework.playerdata:SetPlayerData(self, varname, value)
end

local function gframeworkPlayerInitialSpawn(ply)
	if not ply.GFrameworkData then ply.GFrameworkData = {} end

	ply.GFrameworkData.PlayerData = {}

	gframework.mysqldata:Query("SELECT PlayerData FROM test WHERE SteamID = " .. escapeText(ply:SteamID()), function(data) databaseQueryComplete(data, ply) end, databaseQueryFailed)
end
gframework.hook:Add("PlayerInitialSpawn", "gframework.privilege.PlayerInitialSpawn", gframeworkPlayerInitialSpawn)

local function gframeworkPlayerDisconnected(ply)
	gframework.mysqldata:Query("UPDATE test SET PlayerData = " .. escapeText(gframework.playerdata:CompressData(ply.GFrameworkData.PlayerData)) .. " WHERE SteamID = " .. escapeText(ply:SteamID()))
end
gframework.hook:Add("PlayerDisconnected", "gframework.privilege.PlayerDisconnected", gframeworkPlayerDisconnected)