local config = {
	[40036] = {
        itemId = 35997,
        storage = 1
    },
	[40037] = {
        itemId = 35997,
        storage = 2
    },
	[40038] = {
        itemId = 35996,
        storage = 4
    },
	[40039] = {
        itemId = 35997,
        storage = 8
    },
	[40040] = {
        itemId = 35996,
        storage = 16
    },
}

local statuesActions = Action()

function statuesActions.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local key = config[target.uid]

    if not table.contains({key.itemId}, target.itemid) then
        return false
    end

    if player:getStorageValue(Storage.Kilmaresh.Sixth.Favor) >= 5 and
		not testFlag(player:getStorageValue(Storage.Kilmaresh.Sixth.BlessedStatues), key.storage)
	then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You bless the statue.")
        player:setStorageValue(Storage.Kilmaresh.Sixth.Favor, player:getStorageValue(Storage.Kilmaresh.Sixth.Favor) + 1)
        player:setStorageValue(Storage.Kilmaresh.Sixth.BlessedStatues, player:getStorageValue(Storage.Kilmaresh.Sixth.BlessedStatues) + key.storage)
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already blessed this statue.")
    end

	return true
end

statuesActions:id(36249)
statuesActions:register()