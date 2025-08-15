local quaidDen = MoveEvent()

function quaidDen.onStepIn(creature, item, position, fromPosition)
	if creature:isMonster() then
		return true
	end

	if creature:getStorageValue(Storage.Quest.U12_20.GraveDanger.CustodianKilled) < 1 then
		creature:teleportTo(Position(33401, 32658, 3))
		creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "With the power of the dark Custodian still holding away, the fog is keeping you from entering Quaid's den.")
	end

	return true
end

quaidDen:id(31636)
quaidDen:register()
