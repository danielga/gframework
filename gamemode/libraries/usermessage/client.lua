include("shared.lua")

local usermessageList = {}
local usermessageHooks = {}

function gframework.usermessage:IncomingMessage(name, msg)
	if usermessageHooks[name] then
		for uniquename, func in pairs(usermessageHooks[name]) do
			local err, errstr = pcall(func, msg)
			if err then
				ErrorNoHalt(errstr .. " (in usermessage hook " .. uniquename .. ")\n")
			end
			msg:Reset()
		end
	end
end

function gframework.usermessage:AddHook(name, uniquename, func)
	if not usermessageHooks[name] then
		usermessageHooks[name] = {}
	end

	usermessageHooks[name][uniquename] = func
end

function gframework.usermessage:RemoveHook(name, uniquename)
	if usermessageHooks[name] then
		usermessageHooks[name][uniquename] = nil
	end
end

function gframework.usermessage:GetHookTable()
	return usermessageHooks
end

local FAKEMSG = {}
FAKEMSG.__index = FAKEMSG

function FAKEMSG:Init()
	self.Read = 0
	self.Items = {}
end

function FAKEMSG:GetNumberOfValues()
	return #self.Items
end

function FAKEMSG:ReadValue()
	if self.Read < #self.Items then
		self.Read = self.Read + 1
		return self.Items[self.Read]
	end
end

function FAKEMSG:SetValue(index, value)
	if not index then return end

	self.Items[index] = value
end

function FAKEMSG:Reset()
	self.Read = 0
end

function FAKEMSG:SetTable(tbl)
	self.Items = table.Copy(tbl)
end

function FAKEMSG:GetTable()
	return self.Items
end

local types = {"Angle", "Bool", "Char", "Entity", "Float", "Long", "Short", "String", "Vector", "VectorNormal"}
for _, readtype in pairs(types) do
	FAKEMSG["Read" .. readtype] = function(self) return self:ReadValue() end
end

local function FakeMsg(tbl)
	local fakemsg = {}
	setmetatable(fakemsg, FAKEMSG)

	fakemsg:Init()
	fakemsg:SetTable(tbl)

	return fakemsg
end

local function IsColor(color) --SO MUCH CHECKING AND SO MUCH ACCURATE
	return type(color) == "table" and table.Count(color) == 4 and color.r and color.g and color.b and color.a
end

local function gframeworkGetUsermessage(um)
	local name = um:ReadString()
	local umsgtype = um:ReadChar()
	local loops = 0
	local index = 0

	if not usermessageList[name] then usermessageList[name] = {} end

	while umsgtype ~= UMSG_TYPE_END and umsgtype ~= UMSG_TYPE_STOP do
		loops = loops + 1
		if loops >= 260 then
			ErrorNoHalt("[gframework] Usermessage system failed. Please warn an admin or superadmin.")
			break
		end

		index = index + 1

		if umsgtype == UMSG_TYPE_STRING then
			usermessageList[name][index] = um:ReadString()
		elseif umsgtype == UMSG_TYPE_UNFINISHED_STRING then
			if index == 1 then
				print("[gframework] Empty table for this usermessage. (" .. name .. ")")
			end

			if not usermessageList[name][index] then
				print("[gframework] Unexistant string for this usermessage on index " .. index .. ". (" .. name .. ")")
				usermessageList[name][index] = um:ReadString()
			else
				usermessageList[name][index] = usermessageList[name][index] .. um:ReadString()
			end
		elseif umsgtype == UMSG_TYPE_NUMBER then
			usermessageList[name][index] = um:ReadFloat()
		elseif umsgtype == UMSG_TYPE_VECTOR then
			usermessageList[name][index] = um:ReadVector()
		elseif umsgtype == UMSG_TYPE_ANGLE then
			usermessageList[name][index] = um:ReadAngle()
		elseif umsgtype == UMSG_TYPE_BOOL then
			usermessageList[name][index] = um:ReadBool()
		elseif umsgtype == UMSG_TYPE_ENTITY then
			usermessageList[name][index] = um:ReadEntity()
		elseif umsgtype == UMSG_TYPE_CHAR then
			local data = um:ReadChar() + 128
			local char = ""
			if data ~= 0 then
				char = string.char(data)
			end

			usermessageList[name][index] = char
		elseif umsgtype == UMSG_TYPE_COLOR then
			local r, g, b, a = um:ReadChar() + 128, um:ReadChar() + 128, um:ReadChar() + 128, um:ReadChar() + 128
			usermessageList[name][index] = Color(r, g, b, a)
		elseif umsgtype == UMSG_TYPE_PHYSOBJ then
			local ent, phys = um:ReadEntity(), um:ReadChar()
			usermessageList[name][index] = ent:GetPhysicsObjectNum(phys)
		elseif umsgtype == UMSG_TYPE_NIL then
			usermessageList[name][index] = nil
		else
			ErrorNoHalt("[gframework] Unhandled item type on the usermessage system (" .. umsgtype .. ").")
		end
		umsgtype = um:ReadChar()
	end

	if umsgtype == UMSG_TYPE_END then
		local fakemsg = FakeMsg(usermessageList[name])
		gframework.usermessage:IncomingMessage(name, fakemsg)
		usermessageList[name] = nil
	end
end
usermessage.Hook("gfwINFumsg", gframeworkGetUsermessage)