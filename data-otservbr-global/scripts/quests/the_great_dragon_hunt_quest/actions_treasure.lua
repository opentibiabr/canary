local items = {
	{ description = "a platinum coins", items = { { id = ITEM_PLATINUM_COIN, count = 5 } } },
	{
		description = "some gems",
		items = {
			{ id = 3029, count = 1 },
			{ id = 3032, count = 1 },
			{ id = 3030, count = 1 },
		},
	},
	{ description = "a life ring", items = { { id = 3089, count = 1 } } },
	{ description = "a red gem", items = { { id = 3039, count = 1 } } },
	{ description = "a mana potion", items = { { id = 237, count = 10 } } },
	{ description = "a health potion", items = { { id = 236, count = 8 } } },
}

local adventurersTreasure = Action()

function adventurersTreasure.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U10_80.TheGreatDragonHunt.DragonCounter) >= 50 then
		local treasure = items[math.random(#items)]
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is impossible to take along all of the treasures here. But you pick out " .. treasure.description)
		for _, item in ipairs(treasure.items) do
			player:addItem(item.id, item.count)
		end

		player:setStorageValue(Storage.Quest.U10_80.TheGreatDragonHunt.DragonCounter, 0)

		local times = player:getStorageValue(Storage.Quest.U10_80.TheGreatDragonHunt.Achievement)
		if times < 0 then
			times = 0
		end
		times = times + 1
		player:setStorageValue(Storage.Quest.U10_80.TheGreatDragonHunt.Achievement, times)

		if times == 10 then
			player:addAchievement("Hoard of the Dragon")
		end
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You try to pick a treasure, but you hear further dragons approaching. You should kill some more before picking out something.")
	end

	return true
end

adventurersTreasure:aid(50808)
adventurersTreasure:register()
