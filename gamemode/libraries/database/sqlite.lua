local sqlite = {}

function sqlite:Query(query, onsuccess, onfailure)
	local result = sql.Query(query)
	if onfailure and result == false then
		onfailure(sql.LastError())
	elseif onsuccess then
		onsuccess(result or {})
	end
end

function sqlite:EscapeString(str)
	return sql.SQLStr(str, true)
end

function gframework.database:SQLite()
	return setmetatable({}, sqlite)
end