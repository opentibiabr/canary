function onSpeak(player, type, message)
	if player:getLevel() < 20 and not player:isPremium() then
		player:sendCancelMessage("You may not speak in this channel unless you have reached level 20 or your account has premium status.")
		return false
	end

	local playerGroupType = player:getGroup():getId()
	if type == TALKTYPE_CHANNEL_Y then
		if playerGroupType >= GROUP_TYPE_GAMEMASTER then
			type = TALKTYPE_CHANNEL_O
		end
	elseif type == TALKTYPE_CHANNEL_O then
		if playerGroupType < GROUP_TYPE_GAMEMASTER then
			type = TALKTYPE_CHANNEL_Y
		end
	elseif type == TALKTYPE_CHANNEL_R1 then
		if playerGroupType < GROUP_TYPE_GAMEMASTER and not player:hasFlag(PlayerFlag_CanTalkRedChannel) then
			type = TALKTYPE_CHANNEL_Y
		end
	end
	return type
end
