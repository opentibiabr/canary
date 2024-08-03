local shulgraxLever = MoveEvent()

function shulgraxLever.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if Game.getStorageValue(GlobalStorage.FerumbrasAscendant.FlowerPuzzleTimer) >= 1 then
		player:teleportTo(Position(33436, 32800, 13))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		local pos = position
		pos.y = pos.y + 1
		player:teleportTo(pos)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You not proven your worth. There is no escape for you here.")
		item:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

shulgraxLever:type("stepin")
shulgraxLever:aid(34301)
shulgraxLever:register()
