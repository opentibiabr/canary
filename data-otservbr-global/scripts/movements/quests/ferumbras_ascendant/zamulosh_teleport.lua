local zamuloshTeleport = MoveEvent()

function zamuloshTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item.actionid == 34313 then
		if player:getStorageValue(Storage.FerumbrasAscension.ZamuloshTeleports) >= 9 then
			player:teleportTo(Position(33618, 32620, 10))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			"What was wrong is not necessarily right now. Nevertheless you nade it further.")
			return true
		else
			local pos = player:getPosition()
			pos.x = pos.x - 2
			player:teleportTo(pos)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have access to this teleport yet.")
			return true
		end
	elseif item.actionid == 34314 then
		if player:getStorageValue(Storage.FerumbrasAscension.ZamuloshTeleports) >= 4
		and Game.getStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.AllHabitats) >= 8 then
			player:teleportTo(Position(33618, 32620, 10))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			"What was wrong is not necessarily right now. Nevertheless you nade it further.")
			player:setStorageValue(Storage.FerumbrasAscension.ZamuloshTeleports, 9)
			return true
		else
			local pos = player:getPosition()
			pos.x = pos.x - 2
			player:teleportTo(pos)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have access to this teleport yet.")
			return true
		end
	end
	return true
end

zamuloshTeleport:type("stepin")
zamuloshTeleport:aid(34313, 34314)
zamuloshTeleport:register()
