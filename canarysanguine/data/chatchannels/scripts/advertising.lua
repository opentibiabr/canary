function canJoin(player)
	return player:getVocation():getId() ~= VOCATION_NONE or player:getGroup():getId() >= GROUP_TYPE_SENIORTUTOR
end

local CHANNEL_ADVERTISING = 5

local muted = Condition(CONDITION_CHANNELMUTEDTICKS, CONDITIONID_DEFAULT)
muted:setParameter(CONDITION_PARAM_SUBID, CHANNEL_ADVERTISING)
muted:setParameter(CONDITION_PARAM_TICKS, 120000)

function onSpeak(player, type, message)
	if player:getGroup():getId() >= GROUP_TYPE_GAMEMASTER then
		if type == TALKTYPE_CHANNEL_Y then
			return TALKTYPE_CHANNEL_O
		end
		return true
	end

	if player:getLevel() < 20 and not player:isPremium() then
		player:sendCancelMessage("You may not speak in this channel unless you have reached level 20 or your account has premium status.")
		return false
	end

	if player:getCondition(CONDITION_CHANNELMUTEDTICKS, CONDITIONID_DEFAULT, CHANNEL_ADVERTISING) then
		player:sendCancelMessage("You may only place one offer in two minutes.")
		return false
	end
	player:addCondition(muted)

	if type == TALKTYPE_CHANNEL_O then
		if player:getGroup():getId() < GROUP_TYPE_GAMEMASTER then
			type = TALKTYPE_CHANNEL_Y
		end
	elseif type == TALKTYPE_CHANNEL_R1 then
		if not player:hasFlag(PlayerFlag_CanTalkRedChannel) then
			type = TALKTYPE_CHANNEL_Y
		end
	end
	return type
end
