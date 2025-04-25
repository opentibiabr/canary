local movements_library_mazzinor = MoveEvent()

function movements_library_mazzinor.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()

	if not player then
		return true
	end

	if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline) >= 1 then
		if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Cellar) < 1 then
			if creature:getOutfit().lookType == 19 and player:getItemCount(29310) >= 1 then
				player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Cellar, 1)
				player:teleportTo(Position(32727, 32280, 8))
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				player:removeCondition(CONDITION_OUTFIT)
				if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Tomb) == 1 and player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Cellar) == 1 and player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Temple) == 1 then
					player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline, 2)
				end
			end
		end
	end

	return true
end

movements_library_mazzinor:aid(23102)
movements_library_mazzinor:register()
