local function revertItem(toPosition, getItemId, itemTransform)
	local tile = toPosition:getTile()
	if tile then
		local thing = tile:getItemById(getItemId)
		if thing then
			thing:transform(itemTransform)
		end
	end
end

local config = {
	[21088] = { transformedItemId = 21090, rewardItemId = 21089, revertTime = 10 * 60 * 1000 },
}

local itemTransformation = Action()

function itemTransformation.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local transformation = config[item.itemid]
	if transformation then
		item:transform(transformation.transformedItemId)

		player:addItem(transformation.rewardItemId, 1)

		local messages = {
			"Achoo! You spill the pollen into your bag.",
			"You collected the smelly pollen into a bag.",
		}
		player:say(messages[math.random(#messages)], TALKTYPE_MONSTER_SAY, false, player, toPosition)

		addEvent(revertItem, transformation.revertTime, toPosition, transformation.transformedItemId, item.itemid)

		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
	return true
end

for itemId, info in pairs(config) do
	itemTransformation:id(itemId)
end

itemTransformation:register()
