local items = {
	[0] = {id = 2152, count = 3, chance = 100},
	[1] = {id = 2013, count = 1, chance = 80},
	[2] = {id = 13539, count = 1, chance = 25},
}

local cupOfMoltenGold = Action()

function cupOfMoltenGold.onUse(cid, item, fromPosition, itemEx, toPosition)

	if itemEx.itemid == 2700 or itemEx.itemid == 21428 then
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

cupOfMoltenGold:id(13941)
cupOfMoltenGold:register()
