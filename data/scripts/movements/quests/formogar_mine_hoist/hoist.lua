local hoist = MoveEvent()

function hoist.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.QuestChests.FormorgarMinesHoistSkeleton) ~= 1
	or player:getStorageValue(Storage.QuestChests.FormorgarMinesHoistChest) ~= 1 then
		player:teleportTo(fromPosition)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You must first find the hoist instruction before using it.')
		return true
	end

	if table.contains({3059, 3061}, item.uid) then
		player:teleportTo(Position(32157, 31125, 10))
	elseif item.uid == 3060 then
		if Tile(Position(32156, 31125, 10)):getItemById(1945) then
			player:teleportTo(Position(32157, 31125, 11))
		else
			player:teleportTo(Position(32157, 31125, 9))
		end
	end
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

hoist:type("stepin")
hoist:uid(3059, 3060, 3061)
hoist:register()
