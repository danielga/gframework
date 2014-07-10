gframework.voice = gframework.voice or {}

local voiceChannels = {}
local voiceChannelsActive = false

local PLAYER = FindMetaTable("Player")

function gframework.voice:SetChannelsActive(boolean)
	voiceChannelsActive = boolean
end

function gframework.voice:GetChannelsActive()
	return voiceChannelsActive
end

function gframework.voice:AddPlayerToChannel(ply, channel)
	if not self:IsPlayerOnChannel(ply, channel) then
		if not voiceChannels[channel] then
			voiceChannels[channel] = {}
		end

		table.insert(voiceChannels[channel], ply)
	end
end

function PLAYER:AddVoiceChannel(channel)
	gframework.voice:AddPlayerToChannel(self, channel)
end

function gframework.voice:RemovePlayerFromChannel(ply, channel)
	if voiceChannels[channel] then
		for index, chanply in ipairs(voiceChannels[channel]) do
			if chanply == ply then
				table.remove(voiceChannels[channel], index)
				return
			end
		end
	end
end

function PLAYER:RemoveVoiceChannel(channel)
	gframework.voice:RemovePlayerFromChannel(self, channel)
end

function gframework.voice:GetPlayerChannels(ply)
	local channels = {}
	for channel, plylist in pairs(voiceChannels) do
		for _, chanply in ipairs(plylist) do
			if chanply == ply then
				table.insert(channels, channel)
				break
			end
		end
	end

	return channels
end

function PLAYER:GetVoiceChannels()
	return gframework.voice:GetPlayerChannels(self)
end

function gframework.voice:IsPlayerOnChannel(ply, channel)
	if voiceChannels[channel] then
		for _, chanply in ipairs(voiceChannels[channel]) do
			if chanply == ply then
				return true
			end
		end
	end

	return false
end

function gframework.voice:PlayerCanHearPlayer(talker, listener)
	if not self:GetChannelsActive() then
		return true
	end

	for _, channel in ipairs(self:GetPlayerChannels(talker)) do
		if self:IsPlayerOnChannel(listener, channel) then
			return true
		end
	end

	return false
end

local function gframeworkPlayerCanHearPlayersVoice(listener, talker) --Receives 2 boolean returns, one for allowing and another for ranged talking
	if gframework.voice:PlayerCanHearPlayer(talker, listener) then
		return true, false
	end

	return false, false
end
hook.Add("PlayerCanHearPlayersVoice", "gframework.voice.PlayerCanHearPlayersVoice", gframeworkPlayerCanHearPlayersVoice)