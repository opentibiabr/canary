local doorIds = {}
for index, value in ipairs(QuestDoorTable) do
	if not table.contains(doorIds, value.openDoor) then
		table.insert(doorIds, value.openDoor)
	end

	if not table.contains(doorIds, value.closedDoor) then
		table.insert(doorIds, value.closedDoor)
	end
end

local accountQuestDoors = {}
local function addAccountQuestDoor(storageId, questId)
	if storageId then
		accountQuestDoors[storageId] = questId
	end
end

local theApeCity = Storage.Quest.U7_6 and Storage.Quest.U7_6.TheApeCity or {}
addAccountQuestDoor(theApeCity.DworcDoor, "the-ape-city")
addAccountQuestDoor(theApeCity.ChorDoor, "the-ape-city")
addAccountQuestDoor(theApeCity.FibulaDoor, "the-ape-city")
addAccountQuestDoor(theApeCity.CasksDoor, "the-ape-city")

local secretService = Storage.Quest.U8_1 and Storage.Quest.U8_1.SecretService or {}
addAccountQuestDoor(secretService.CGBMission01, "secret-service")
addAccountQuestDoor(secretService.TBIMission02, "secret-service")
addAccountQuestDoor(secretService.AVINMission02, "secret-service")
addAccountQuestDoor(secretService.CGBMission02, "secret-service")
addAccountQuestDoor(secretService.TBIMission03, "secret-service")
addAccountQuestDoor(secretService.TBIMission04, "secret-service")
addAccountQuestDoor(secretService.CGBMission04, "secret-service")
addAccountQuestDoor(secretService.AVINMission05, "secret-service")
addAccountQuestDoor(secretService.CGBMission05, "secret-service")
addAccountQuestDoor(secretService.Mission07, "secret-service")
addAccountQuestDoor(secretService.CGBMission06, "secret-service")

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
