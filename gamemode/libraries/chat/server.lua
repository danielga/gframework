AddCSLuaFile("client.lua")

gframework.chat = gframework.chat or {}

function gframework.chat:SendText(...)
	net.Start("gfwchat")
	net.WriteTable({...})
	net.Broadcast()
end

function gframework.chat:SendTextToPlayer(ply, ...)
	net.Start("gfwchat")
	net.WriteTable({...})
	net.Send(ply)
end

local PLAYER = FindMetaTable("Player")

function PLAYER:SendText(...)
	gframework.chat:SendTextToPlayer(self, ...)
end