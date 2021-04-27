local config = {
	[1] = Position(32566, 31505, 9),
	[2] = Position(32611, 31513, 9)
}

local theHiddenDeeper = Action()
function theHiddenDeeper.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.HiddenCityOfBeregar.RoyalRescue) >= 3 then
		player:teleportTo(Position(32611, 31513, 9), true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	local targetPosition = config[player:getStorageValue(Storage.HiddenCityOfBeregar.RoyalRescue)]
	if not targetPosition then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have permission to use this yet.")
		return true
	end

	player:teleportTo(targetPosition, true)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

theHiddenDeeper:aid(50128)
theHiddenDeeper:register()