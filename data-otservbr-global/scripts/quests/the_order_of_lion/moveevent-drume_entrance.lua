
local drumeEntrance = MoveEvent()
function drumeEntrance.onStepIn(creature, item, position, fromPosition)
	if creature:isPlayer() and creature:getStorageValue(Storage.TheOrderOfTheLion.Drume.Timer) > os.time() then
		creature:teleportTo(fromPosition, true)
		creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You've been into the skirmish in the last 20 hours.")
	end
	return true
end
drumeEntrance:aid(59601)
drumeEntrance:register()
