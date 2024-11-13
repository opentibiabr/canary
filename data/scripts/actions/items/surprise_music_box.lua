local prize = {
	{ chance = 1, id = 3246, amount = 1 },
	{ chance = 2, id = 10227, amount = 1 },
	{ chance = 3, id = 11588, amount = 1 },
	{ chance = 4, id = 3549, amount = 1 },
	{ chance = 5, id = 3420, amount = 1 },
	{ chance = 10, id = ITEM_CRYSTAL_COIN, amount = 17 },
	{ chance = 20, id = ITEM_GOLD_COIN, amount = 1 },
	{ chance = 30, id = ITEM_CRYSTAL_COIN, amount = 1 },
	{ chance = 40, id = ITEM_GOLD_COIN, amount = 50 },
	{ chance = 50, id = ITEM_PLATINUM_COIN, amount = 15 },
	{ chance = 90, id = ITEM_GOLD_COIN, amount = 80 },
}

local surpriseBox = Action()

function surpriseBox.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local number = math.random(1, 100)
	local cumulativeChance = 0

	for _, prizeEntry in ipairs(prize) do
		cumulativeChance = cumulativeChance + prizeEntry.chance
		if number <= cumulativeChance then
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			player:addItem(prizeEntry.id, prizeEntry.amount)
			item:remove()
			break
		end
	end
	return true
end

surpriseBox:id(12045)
surpriseBox:register()
