function canJoin(player)
	return player:getGroup():getId() >= GROUP_TYPE_TUTOR
end

function onSpeak(player, type, message)
	local playerGroupType = player:getGroup():getId()
	if type == TALKTYPE_CHANNEL_Y then
		if playerGroupType >= GROUP_TYPE_SENIORTUTOR then
			type = TALKTYPE_CHANNEL_O
		end
	elseif type == TALKTYPE_CHANNEL_O then
		if playerGroupType < GROUP_TYPE_SENIORTUTOR then
			type = TALKTYPE_CHANNEL_Y
		end
	elseif type == TALKTYPE_CHANNEL_R1 then
		if playerGroupType < GROUP_TYPE_GAMEMASTER and not player:hasFlag(PlayerFlag_CanTalkRedChannel) then
			type = TALKTYPE_CHANNEL_Y
		end
	end
	return type
end
