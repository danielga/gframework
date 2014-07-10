AddCSLuaFile("client.lua")

gframework.chat = gframework.chat or {}

function gframework.chat:SendText(...)
	gframework.usermessage:SendGlobalUsermessage("gfwchat", ...)
end

function gframework.chat:SendTextToPlayer(ply, ...)
	gframework.usermessage:SendUsermessage("gfwchat", ply, ...)
end

local PLAYER = FindMetaTable("Player")

function PLAYER:SendText(...)
	gframework.chat:SendTextToPlayer(self, ...)
end