local setting = {
	[50092] = Position(32612, 31499, 15),
	[50093] = Position(32612, 31499, 14)
}

local elevator = MoveEvent()

function elevator.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local teleport = setting[item.actionid]
	if not teleport then
		return true
	end

	if player:getStorageValue(Storage.HiddenCityOfBeregar.GoingDown) == 2 then
		player:teleportTo(teleport)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't know how to use this yet.")
	end
	return true
end

elevator:type("stepin")

for index, value in pairs(setting) do
	elevator:aid(index)
end

elevator:register()
