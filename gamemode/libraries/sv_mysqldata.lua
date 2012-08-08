gframework.mysqldata = {}
gframework.mysql = gframework.mysqldata

require("mysqloo")

local HOST = "localhost"
local PORT = 3306
local DATABASE = "triorigaming"
local USERNAME = "root"
local PASSWORD = "AAFE95LK"
local CONNECTED = false
local CONNECTION = mysqloo.connect(HOST, USERNAME, PASSWORD, DATABASE, PORT)

local function databaseConnected(database)
	CONNECTED = true
end

local function databaseFailedConnection(database, error)
	ErrorNoHalt(error .. "\n")
end

CONNECTION.onConnected = databaseConnected
CONNECTION.onConnectionFailed = databaseFailedConnection
CONNECTION:connect()

function gframework.mysqldata:Query(querytext, successcallback, errorcallback)
	local query = CONNECTION:query(querytext)
	query.onSuccess = function(query) if successcallback then successcallback(query:getData()) end end
	query.onError = function(query, error) if errorcallback then errorcallback(error) else ErrorNoHalt(error .. "\n") end end
	query:start()
end

function gframework.mysqldata:EscapeText(text, noquotes)
	text = tostring(text)

	if string.find(text, "\\\"") then
		return
	end

	text = string.gsub(text, "\"", "\\\"")

	if noquotes then
		return text
	end

	return "\"" .. text .. "\""
end