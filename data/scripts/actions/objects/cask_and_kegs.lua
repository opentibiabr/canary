local targetIdList = {
	[25879] = { itemId = 285, transform = 266 },
	[25880] = { itemId = 283, transform = 236 },
	[25881] = { itemId = 284, transform = 239 },
	[25882] = { itemId = 284, transform = 7643 },
	[25883] = { itemId = 284, transform = 23375 },
	[25889] = { itemId = 285, transform = 268 },
	[25890] = { itemId = 283, transform = 237 },
	[25891] = { itemId = 284, transform = 238 },
	[25892] = { itemId = 284, transform = 23373 },
	[25899] = { itemId = 284, transform = 7642 },
	[25900] = { itemId = 284, transform = 23374 },
	[25903] = { itemId = 285, transform = 266 },
	[25904] = { itemId = 283, transform = 236 },
	[25905] = { itemId = 284, transform = 239 },
	[25906] = { itemId = 284, transform = 7643 },
	[25907] = { itemId = 284, transform = 23375 },
	[25908] = { itemId = 285, transform = 268 },
	[25909] = { itemId = 283, transform = 237 },
	[25910] = { itemId = 284, transform = 238 },
	[25911] = { itemId = 284, transform = 23373 },
	[25913] = { itemId = 284, transform = 7642 },
	[25914] = { itemId = 284, transform = 23374 },
}

local flasks = Action()

function flasks.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not target or not target:isItem() then
        return false
    end

    local charges = target:getCharges()
    local itemCount = item:getCount()

    if itemCount > charges then
        itemCount = charges
    end

    local targetId = targetIdList and targetIdList[target:getId()]
    if not targetId or item:getId() ~= targetId.itemId or charges <= 0 then
        return false
    end

    local inbox = player:getStoreInbox()
    if not inbox then
        return false
    end

    item:transform(targetId.transform, itemCount)
    charges = charges - itemCount
    target:transform(target:getId(), charges)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Remaining %s charges.", charges))

    if charges == 0 then
        target:remove()
    end

    if inbox:addItem(targetId.transform, itemCount) then
        item:remove(itemCount)
    else
        item:transform(item:getId(), itemCount)
        target:transform(target:getId(), charges + itemCount)
        return false
    end
    
    return true
end

flasks:id(283, 284, 285)
flasks:register()
