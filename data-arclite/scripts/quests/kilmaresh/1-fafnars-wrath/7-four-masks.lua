local masks = {
    [31369] = {
        storage = 1,
        successMessage = "You have found a gryphon mask.", -- TODO Gryphon Mask
        emptyMessage = "The gryphon nest is empty."
    },
    [31370] = { -- Silver mask
        storage = 2,
        successMessage = "You have found a silver mask.",
        emptyMessage = "This palm is empty."
    }, 
    [31371] = { -- For Ivory mask action see data\scripts\actions\other\gems.lua
        storage = 4
    },
    [31372] = { -- Mirror Mask
        storage = 8,
        successMessage = "You have found a mirror mask.",
        emptyMessage = "The sarcophagus is empty."
    }
}

local uidRewards = {
    [40033] = 31369,
    [40034] = 31370,
    [40035] = 31372
}

local masksAction = Action()

function masksAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local maskDiscovered = uidRewards[item.uid]
    local mask = masks[maskDiscovered]

    if player:getStorageValue(Storage.Kilmaresh.Sixth.Favor) >= 1 and
		not testFlag(player:getStorageValue(Storage.Kilmaresh.Sixth.FourMasks), mask.storage)
	then
		player:addItem(maskDiscovered, 1)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, mask.successMessage)
        player:setStorageValue(Storage.Kilmaresh.Sixth.Favor, player:getStorageValue(Storage.Kilmaresh.Sixth.Favor) + 1)
        player:setStorageValue(Storage.Kilmaresh.Sixth.FourMasks, player:getStorageValue(Storage.Kilmaresh.Sixth.FourMasks) + mask.storage)
    elseif player:getStorageValue(Storage.Kilmaresh.Sixth.Favor) >= 1 then
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

