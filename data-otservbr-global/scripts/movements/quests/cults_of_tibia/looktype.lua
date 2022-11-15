
local looktype = MoveEvent()

function looktype.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local firstCheck = Position(33135, 31859, 10)
	local secondCheck = Position(33128, 31885, 11)
	local thirdCheck = Position(33175, 31923, 12)
	if position == firstCheck or position == Position(firstCheck.x + 1, firstCheck.y, firstCheck.z) then
		if player:getStorageValue(Storage.CultsOfTibia.Orcs.LookType) < 1 then
			if creature:getOutfit().lookType == 5 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Due to the strength of an orc you are able to pass this rift.")
				player:setStorageValue(Storage.CultsOfTibia.Orcs.LookType, 1)
			else
				player:teleportTo(fromPosition, true)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need the strength of an orc to pass this rift.")
			end
		end
	end
	if position == secondCheck or position == Position(secondCheck.x + 1, secondCheck.y, secondCheck.z) then
		if player:getStorageValue(Storage.CultsOfTibia.Orcs.LookType) < 2 then
			if creature:getOutfit().lookType == 2 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
				"With the help off the might of an orc warlod you are able to pass this rift.")
				player:setStorageValue(Storage.CultsOfTibia.Orcs.LookType, 2)
			else
				player:teleportTo(fromPosition, true)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need the might of an orc warlod to pass this rift.")
			end
		end
	end
	if position == thirdCheck or position == Position(thirdCheck.x + 1, thirdCheck.y, thirdCheck.z) or
	position == Position(thirdCheck.x + 2, thirdCheck.y, thirdCheck.z) then
		if player:getStorageValue(Storage.CultsOfTibia.Orcs.LookType) < 3 then
			if creature:getOutfit().lookType == 6 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
				"With the help of the wisdom of an orc shaman you are able to pass this rift.")
				player:setStorageValue(Storage.CultsOfTibia.Orcs.LookType, 3)
			else
				player:teleportTo(fromPosition, true)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need the wisdom of an orc shaman to pass this rift.")
			end
		end
	end
	return true
end

looktype:type("stepin")
looktype:aid(5540)
looktype:register()
