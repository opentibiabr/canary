local UniqueTable = {
	-- Chests uniques
	[14029] = {
		-- Uzgod's Family Brooch
		rewardItemId = 4845,
		storageMission = Storage.ExplorerSociety.TheBonelordSecret,
		storageMissionValue = 31,
		storageQuestlineValue = 30
	},
	[14030] = {
		-- Wrinkled parchment
		rewardItemId = 4857,
		storageMission = Storage.ExplorerSociety.TheBonelordSecret,
		storageMissionValue = 31,
		storageQuestlineValue = 30
	},
	[14031] = {
		-- Strange powder
		rewardItemId = 15389,
		storageMission = Storage.ExplorerSociety.TheOrcPowder,
		storageMissionValue = 34,
		storageQuestlineValue = 33
	},
	[14032] = {
		-- Elven poetry book
		rewardItemId = 4855,
		storageMission = Storage.ExplorerSociety.TheElvenPoetry,
		storageMissionValue = 37,
		storageQuestlineValue = 36
	},
	[14033] = {
		-- Memory stone
		rewardItemId = 4852,
		storageMission = Storage.ExplorerSociety.TheMemoryStone,
		storageMissionValue = 40,
		storageQuestlineValue = 39
	},
	[14034] = {
		-- Spectral dress
		rewardItemId = 4847,
		storageMission = Storage.ExplorerSociety.TheSpectralDress,
		storageMissionValue = 49,
		storageQuestlineValue = 48
	},
	[14035] = {
		-- Damage logbook
		rewardItemId = 6124,
		storageMission = Storage.ExplorerSociety.CalassaQuest,
		storageMissionValue = 2,
		storageQuestlineValue = 0
	},
	-- Others uniques
	[40041] = {
		-- Funeral urn
		rewardItemId = 4858,
		storageMission = Storage.ExplorerSociety.TheLizardUrn,
		storageMissionValue = 28,
		storageQuestlineValue = 27
	},
}

local explorerSocietyFindings = Action()
function explorerSocietyFindings.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local uniqueItem = UniqueTable[item.uid]
	if not uniqueItem then
		return true
	end
	if player:getStorageValue(item.uid) >= 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The ' .. getItemName(uniqueItem.itemId) .. ' is empty.')
		return true
	end
	if player:getStorageValue(uniqueItem.storageMission) ~= uniqueItem.storageMissionValue then
		player:addItem(uniqueItem.rewardItemId, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a " .. getItemName(uniqueItem.rewardItemId) .. ".")
		player:setStorageValue(item.uid, 1)
		player:setStorageValue(uniqueItem.storageMission, uniqueItem.storageMissionValue)
		if(uniqueItem.storageQuestlineValue > 0) then
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, uniqueItem.storageQuestlineValue)
		end
		return true
	end
end

for index, value in pairs(UniqueTable) do
	explorerSocietyFindings:uid(index)
end

explorerSocietyFindings:register()
