local requiredItems = { 283, 284, 285 }

local transformations = {
	{ fromItemId = 25879, toItemId = 266 },
	{ fromItemId = 25880, toItemId = 236 },
	{ fromItemId = 25881, toItemId = 239 },
	{ fromItemId = 25882, toItemId = 7643 },
	{ fromItemId = 25883, toItemId = 23375 },
	{ fromItemId = 25889, toItemId = 268 },
	{ fromItemId = 25890, toItemId = 237 },
	{ fromItemId = 25891, toItemId = 238 },
	{ fromItemId = 25892, toItemId = 23373 },
	{ fromItemId = 25899, toItemId = 7642 },
	{ fromItemId = 25900, toItemId = 23374 },
	{ fromItemId = 25903, toItemId = 266 },
	{ fromItemId = 25904, toItemId = 236 },
	{ fromItemId = 25905, toItemId = 239 },
	{ fromItemId = 25906, toItemId = 7643 },
	{ fromItemId = 25907, toItemId = 23375 },
	{ fromItemId = 25908, toItemId = 268 },
	{ fromItemId = 25909, toItemId = 237 },
	{ fromItemId = 25910, toItemId = 238 },
	{ fromItemId = 25911, toItemId = 23373 },
	{ fromItemId = 25913, toItemId = 7642 },
	{ fromItemId = 25914, toItemId = 23374 },
}

local function processTransformation(player, item, charges, transformation)
	local transformedCount = 0

	if charges <= 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The item has no charges remaining.")
		return false
	end

	for _, requiredItemId in ipairs(requiredItems) do
		local itemCount = player:getItemCount(requiredItemId)

		if itemCount > 0 then
			local transformable = math.min(itemCount, charges - transformedCount)

			if transformable > 0 then
				player:removeItem(requiredItemId, transformable)
				player:addItem(transformation.toItemId, transformable)

				transformedCount = transformedCount + transformable

				if transformedCount >= charges then
					break
				end
			end
		end
	end

	if transformedCount > 0 then
		local newCharges = charges - transformedCount

		if newCharges > 0 then
			item:setAttribute(ITEM_ATTRIBUTE_CHARGES, newCharges)
		else
			item:remove(1)
		end

		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Charges remaining: " .. newCharges)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need flasks to carry all that.")
	end

	return true
end

local function onUseTransformation(player, item, position, target, toPosition, isHotkey)
	local charges = item:getAttribute(ITEM_ATTRIBUTE_CHARGES) or 0

	for _, transformation in ipairs(transformations) do
		if item:getId() == transformation.fromItemId then
			return processTransformation(player, item, charges, transformation)
		end
	end

	return false
end

for _, transformation in ipairs(transformations) do
	local action = Action()
	action:id(transformation.fromItemId)
	action.onUse = onUseTransformation
	action:register()
end
