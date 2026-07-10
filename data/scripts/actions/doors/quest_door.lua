local doorIds = {}
for index, value in ipairs(QuestDoorTable) do
	if not table.contains(doorIds, value.openDoor) then
		table.insert(doorIds, value.openDoor)
	end

	if not table.contains(doorIds, value.closedDoor) then
		table.insert(doorIds, value.closedDoor)
	end
end

local accountQuestDoors = {
	[Storage.Quest.U7_6.TheApeCity.DworcDoor] = "the-ape-city",
	[Storage.Quest.U7_6.TheApeCity.ChorDoor] = "the-ape-city",
	[Storage.Quest.U7_6.TheApeCity.FibulaDoor] = "the-ape-city",
	[Storage.Quest.U7_6.TheApeCity.CasksDoor] = "the-ape-city",
}

local questDoor = Action()
function questDoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for index, value in ipairs(QuestDoorTable) do
		if value.closedDoor == item.itemid then
			local hasCharacterAccess = item.actionid > 0 and player:getStorageValue(item.actionid) ~= -1
			local accountQuestId = accountQuestDoors[item.actionid]
			local hasAccountAccess = accountQuestId and player:hasAccountQuestAccess(accountQuestId) or false

			if hasCharacterAccess and accountQuestId then
				player:unlockAccountQuestAccess(accountQuestId)
			end

			if hasCharacterAccess or hasAccountAccess then
				item:transform(value.openDoor)
				item:getPosition():sendSingleSoundEffect(SOUND_EFFECT_TYPE_ACTION_OPEN_DOOR)
				player:teleportTo(toPosition, true)
				return true
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The door seems to be sealed against unwanted intruders.")
				return true
			end
		end
	end

	if Creature.checkCreatureInsideDoor(player, toPosition) then
		return true
	end
	return true
end

for index, value in ipairs(doorIds) do
	questDoor:id(value)
end

questDoor:register()
