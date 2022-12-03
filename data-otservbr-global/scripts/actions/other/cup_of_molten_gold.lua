local items = {
	[0] = {id = 3035, count = 3, chance = 100},
	[1] = {id = 2881, count = 1, chance = 80},
	[2] = {id = 12550, count = 1, chance = 25},
}

local cupOfMoltenGold = Action()

function cupOfMoltenGold.onUse(cid, item, fromPosition, itemEx, toPosition)

	if itemEx.itemid == 3614 or itemEx.itemid == 19111 then
		doRemoveItem(item.uid, 1)
		for i = 0, #items do
			if (items[i].chance > math.random(1, 100)) then
				doPlayerAddItem(cid, items[i].id, items[i].count)
				doSendMagicEffect(toPosition, CONST_ME_EXPLOSIONAREA)
			end
		end
	end
	return true
end

cupOfMoltenGold:id(12804)
cupOfMoltenGold:register()
