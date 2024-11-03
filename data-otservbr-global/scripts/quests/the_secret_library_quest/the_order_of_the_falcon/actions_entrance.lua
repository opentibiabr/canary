local actions_entrance = Action()

function actions_entrance.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if (target == nil) or not target:isItem() then
		return false
	end

	local currentTime = os.date("*t")
	local currentMinute = currentTime.min

	local isNightTime = (currentMinute >= 45 or currentMinute < 15)

	if isNightTime then
		if target:getPosition() == Position(33201, 31763, 1) then
			player:teleportTo(Position(33356, 31309, 4), true)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Once more you mix the chalk with a drop of your blood and a bit of water and renew the symbol on the floor...")
			item:transform(2873, 0)
		end
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can only use this entrance during the night.")
	end

	return true
end

actions_entrance:id(28468)
actions_entrance:register()
