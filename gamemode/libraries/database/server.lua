gframework.database = gframework.database or {}
gframework.db = gframework.database

include("sqlite.lua")

local database = gframework.database:SQLite()

function gframework.database:Query(querytext, onsuccess, onfailure)
	database:Query(querytext, onsucess, onfailure)
end

function gframework.database:EscapeString(str)
	database:EscapeString(str)
end