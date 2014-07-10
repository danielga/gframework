require("mysqloo")

local mysql = {}

function mysql:Query(query, onsucess, onfailure)
	local queryobj = self.__connection:query(query)
	queryobj.owner = self

	function queryobj:onSuccess(data)
		if onsuccess then
			onsucess(data)
		end
	end

	function queryobj:onError(err)
		local owner = self.owner
		if owner.connection:status() == mysqloo.DATABASE_NOT_CONNECTED then
			table.insert(owner.queue, {query = query, callback = callback})
			owner.connection:connect()
			return
		end

		if onfailure then
			onfailure(err)
		end
	end

	queryobj:start()
end

function mysql:EscapeString(str)
	return self.__connection:escape(str)
end

function gframework.database:MySQL(address, username, password, dbname, port)
	local connection = mysqloo.connect(address, username, password, dbname, port)
	if not connection then
		error("failed to create connection")
	end

	local tbl = setmetatable({__queue = {}, __connection = connection}, mysql)
	tbl.__connection.owner = tbl

	function connection:onConnected()
		local owner = self.owner
		for _, v in pairs(owner.__queue) do
			owner:Query(v.query, v.callback)
		end

		owner.__queue = {}
	end

	function connection:onConnectionFailed(err)
		print("Connection to database failed!\nError: " .. err)
	end

	connection:connect()

	return tbl
end