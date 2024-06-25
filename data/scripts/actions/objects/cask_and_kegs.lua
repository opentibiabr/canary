local targetTransformationList = {
	[25879] = 266,
	[25880] = 236,
	[25881] = 239,
	[25882] = 7643,
	[25883] = 23375,
	[25889] = 268,
	[25890] = 237,
	[25891] = 238,
	[25892] = 23373,
	[25899] = 7642,
	[25900] = 23374,
	[25903] = 266,
	[25904] = 236,
	[25905] = 239,
	[25906] = 7643,
	[25907] = 23375,
	[25908] = 268,
	[25909] = 237,
	[25910] = 238,
	[25911] = 23373,
	[25913] = 7642,
	[25914] = 23374,
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

	local transformId = targetTransformationList[target:getId()]
	if not transformId or charges <= 0 then
		return true
	end

	local storeInbox = player:getStoreInbox()
	if not storeInbox then
		return true
	end

	item:transform(transformId, flaskCount)
	charges = charges - flaskCount
	target:transform(target:getId(), charges)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Remaining %d charges.", charges))

	if charges <= 0 then
		target:remove()
	end

	local addedItem = storeInbox:addItem(transformId, flaskCount)
	if addedItem then
		addedItem:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
	else
		player:addItem(transformId, flaskCount)
	end

	item:remove(flaskCount)
	return true
end

flasks:id(283, 284, 285)
flasks:register()
