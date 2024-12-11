local masks = {
	[31369] = {
		storage = 1,
		successMessage = "You have found a gryphon mask.", -- TODO Gryphon Mask
		emptyMessage = "The gryphon nest is empty.",
		storageKey = Storage.Quest.U12_20.KilmareshQuest.Sixth.GryphonMask,
	},
	[31370] = { -- Silver mask
		storage = 2,
		successMessage = "You have found a silver mask.",
		emptyMessage = "This palm is empty.",
		storageKey = Storage.Quest.U12_20.KilmareshQuest.Sixth.SilverMask,
	},
	[31371] = { -- For Ivory mask action see data\scripts\actions\other\gems.lua
		storage = 4,
		storageKey = Storage.Quest.U12_20.KilmareshQuest.Sixth.IvoryMask,
	},
	[31372] = { -- Mirror Mask
		storage = 8,
		successMessage = "You have found a mirror mask.",
		emptyMessage = "The sarcophagus is empty.",
		storageKey = Storage.Quest.U12_20.KilmareshQuest.Sixth.MirrorMask,
	},
}

local uidRewards = {
	[40033] = 31369,
	[40034] = 31370,
	[40035] = 31372,
}

local masksAction = Action()

function masksAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local maskDiscovered = uidRewards[item.uid]
	local mask = masks[maskDiscovered]

	if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.Favor) >= 1 and not testFlag(player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.FourMasks), mask.storage) then
		player:addItem(maskDiscovered, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, mask.successMessage)
		player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.Favor, player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.Favor) + 1)
		player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.FourMasks, player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.FourMasks) + mask.storage)
		player:setStorageValue(mask.storageKey, 1)
	elseif player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.Favor) >= 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, mask.emptyMessage)
	else
		return false
	end

	return true
end

for uniqueId, itemId in pairs(uidRewards) do
	masksAction:uid(uniqueId)
end

masksAction:register()
