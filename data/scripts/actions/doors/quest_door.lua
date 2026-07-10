local doorIds = {}
for index, value in ipairs(QuestDoorTable) do
	if not table.contains(doorIds, value.openDoor) then
		table.insert(doorIds, value.openDoor)
	end

	if not table.contains(doorIds, value.closedDoor) then
		table.insert(doorIds, value.closedDoor)
	end
end

-- Account quest doors are defined by datapack-specific storages. Resolve each
-- path defensively so this core script does not crash on datapacks (e.g.
-- data-canary) that do not define the referenced quest storages.
local function resolveStorage(path)
	local node = Storage
	for key in string.gmatch(path, "[^.]+") do
		if type(node) ~= "table" then
			return nil
		end
		node = node[key]
	end
	return node
end

local accountQuestDoorPaths = {
	["Quest.U7_6.TheApeCity.DworcDoor"] = "the-ape-city",
	["Quest.U7_6.TheApeCity.ChorDoor"] = "the-ape-city",
	["Quest.U7_6.TheApeCity.FibulaDoor"] = "the-ape-city",
	["Quest.U7_6.TheApeCity.CasksDoor"] = "the-ape-city",
	["Quest.U8_1.SecretService.CGBMission01"] = "secret-service",
	["Quest.U8_1.SecretService.TBIMission02"] = "secret-service",
	["Quest.U8_1.SecretService.AVINMission02"] = "secret-service",
	["Quest.U8_1.SecretService.CGBMission02"] = "secret-service",
	["Quest.U8_1.SecretService.TBIMission03"] = "secret-service",
	["Quest.U8_1.SecretService.TBIMission04"] = "secret-service",
	["Quest.U8_1.SecretService.CGBMission04"] = "secret-service",
	["Quest.U8_1.SecretService.AVINMission05"] = "secret-service",
	["Quest.U8_1.SecretService.CGBMission05"] = "secret-service",
	["Quest.U8_1.SecretService.Mission07"] = "secret-service",
	["Quest.U8_1.SecretService.CGBMission06"] = "secret-service",
}

local accountQuestDoors = {}
for path, accountQuestId in pairs(accountQuestDoorPaths) do
	local storageValue = resolveStorage(path)
	if storageValue ~= nil then
		accountQuestDoors[storageValue] = accountQuestId
	end
end

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
