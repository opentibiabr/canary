local targetTransformationList = {
	[25879] = { flaskId = 285, transformId = 266 },
	[25880] = { flaskId = 283, transformId = 236 },
	[25881] = { flaskId = 284, transformId = 239 },
	[25882] = { flaskId = 284, transformId = 7643 },
	[25883] = { flaskId = 284, transformId = 23375 },
	[25889] = { flaskId = 285, transformId = 268 },
	[25890] = { flaskId = 283, transformId = 237 },
	[25891] = { flaskId = 284, transformId = 238 },
	[25892] = { flaskId = 284, transformId = 23373 },
	[25899] = { flaskId = 284, transformId = 7642 },
	[25900] = { flaskId = 284, transformId = 23374 },
	[25903] = { flaskId = 285, transformId = 266 },
	[25904] = { flaskId = 283, transformId = 236 },
	[25905] = { flaskId = 284, transformId = 239 },
	[25906] = { flaskId = 284, transformId = 7643 },
	[25907] = { flaskId = 284, transformId = 23375 },
	[25908] = { flaskId = 285, transformId = 268 },
	[25909] = { flaskId = 283, transformId = 237 },
	[25910] = { flaskId = 284, transformId = 238 },
	[25911] = { flaskId = 284, transformId = 23373 },
	[25913] = { flaskId = 284, transformId = 7642 },
	[25914] = { flaskId = 284, transformId = 23374 },
}

local flasks = Action()

function flasks.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or not target:isItem() then
		return true
	end

	local charges = target:getCharges()
	local flaskCount = item:getCount()

	if flaskCount > charges then
		flaskCount = charges
	end

	local transformation = targetTransformationList[target:getId()]
	if not transformation or item:getId() ~= transformation.flaskId or charges <= 0 then
		return true
	end

	local storeInbox = player:getStoreInbox()
	if not storeInbox then
		return true
	end

	item:transform(transformation.transformId, flaskCount)
	charges = charges - flaskCount
	target:transform(target:getId(), charges)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Remaining %d charges.", charges))

	if charges <= 0 then
		target:remove()
	end

	local addedItem = storeInbox:addItem(transformation.transformId, flaskCount)
	if addedItem then
		addedItem:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
	else
		player:addItem(transformation.transformId, flaskCount)
	end

	item:remove(flaskCount)
	return true
end

flasks:id(283, 284, 285)
flasks:register()
