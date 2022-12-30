local checkOasis = MoveEvent()

function checkOasis.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.CultsOfTibia.Life.Mission) == 2 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
		"You have found a lovely oasis with green fauna and juicy fruit. You didn't expect that.")
		player:setStorageValue(Storage.CultsOfTibia.Life.Mission, 3)
	end
	return true
end

checkOasis:type("stepin")
checkOasis:aid(5560)
checkOasis:register()
