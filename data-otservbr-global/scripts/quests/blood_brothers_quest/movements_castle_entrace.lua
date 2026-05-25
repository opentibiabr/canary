local STORAGE_HIDDEN_ENTRANCE = Storage.Quest.U8_4.BloodBrothers.CastleHiddenEntrance

local castleEntrance = MoveEvent()

function castleEntrance.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end
	local player = Player(creature)
	if player:getStorageValue(STORAGE_HIDDEN_ENTRANCE) == 1 then
		player:teleportTo(Position(32953, 31483, 6))
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A strange force prevents you from entering.")
		player:teleportTo(fromPosition)
	end
	return true
end

castleEntrance:position(Position(32953, 31486, 6))
castleEntrance:register()
