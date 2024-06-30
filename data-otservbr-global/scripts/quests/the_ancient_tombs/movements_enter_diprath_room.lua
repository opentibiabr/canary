local movements_enter_diprath_room = MoveEvent()

function movements_enter_diprath_room.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local destination = Position(33092, 32590, 15)

	if player:getStorageValue(Storage.Quest.U7_4.TheAncientTombs.DiprathSwitchesGlobalStorage) < 7 and player:getStorageValue(Storage.Quest.U7_4.TheAncientTombs.Diprath_sign8) ~= 1 then
		player:teleportTo(fromPosition, true)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:teleportTo(destination)
		destination:sendMagicEffect(CONST_ME_TELEPORT)
		if player:getStorageValue(Storage.Quest.U7_4.TheAncientTombs.DiphtrahsTreasure) <= 2 then
			player:setStorageValue(Storage.Quest.U7_4.TheAncientTombs.DiphtrahsTreasure, 3)
		end
	end

	return true
end

movements_enter_diprath_room:type("stepin")
movements_enter_diprath_room:uid(40083)
movements_enter_diprath_room:register()
