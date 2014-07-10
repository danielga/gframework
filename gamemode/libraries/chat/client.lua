gframework.chat = gframework.chat or {}

function gframework.chat:AddText(...)
	chat.AddText(...)
end

function gframework.chat:GetChatBoxPos()
	return chat.GetChatBoxPos()
end

function gframework.chat:PlaySound()
	chat.PlaySound()
end

local function gframeworkReceiveText(msg)
	chat.AddText(unpack(msg:GetTable()))
end
usermessage.Hook("gfwchat", gframeworkReceiveText)