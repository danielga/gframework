gframework.chat = {}

function gframework.chat:SendText(...)
	gframework.usermessage:SendGlobalUsermessage("gfwchat", ...)
end

function gframework.chat:SendTextToPlayer(ply, ...)
	gframework.usermessage:SendUsermessage("gfwchat", ply, ...)
end

function _R.Player:SendText(...)
	gframework.chat:SendTextToPlayer(self, ...)
end