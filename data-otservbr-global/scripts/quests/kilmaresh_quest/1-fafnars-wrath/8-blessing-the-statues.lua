local config = {
	[40036] = {
		itemId = 31162,
		storage = 1,
	},
	[40037] = {
		itemId = 31162,
		storage = 2,
	},
	[40038] = {
		itemId = 31161,
		storage = 4,
	},
	[40039] = {
		itemId = 31162,
		storage = 8,
	},
	[40040] = {
		itemId = 31161,
		storage = 16,
	},
}

local statuesActions = Action()

function statuesActions.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local key = config[target.uid]

	if not table.contains({ key.itemId }, target.itemid) then
		return false
	end

	if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.Favor) >= 5 and not testFlag(player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.BlessedStatues), key.storage) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You bless the statue.")
		player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.Favor, player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.Favor) + 1)
		player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.BlessedStatues, player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.BlessedStatues) + key.storage)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already blessed this statue.")
	end

	return true
end

statuesActions:id(31414)
statuesActions:register()
