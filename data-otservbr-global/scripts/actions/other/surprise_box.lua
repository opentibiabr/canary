local prize = {
	[1] = { chance = 30, id = 12308, amount = 1 },
	[2] = { chance = 30, id = 12548, amount = 1 },
	[3] = { chance = 100, id = ITEM_CRYSTAL_COIN, amount = 60 },
}

local surpriseBox = Action()

function surpriseBox.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for i = 1, #prize do
		local number = math.random() * 100
		if prize[i].chance > 100 - number then
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			player:addItem(prize[i].id, prize[i].amount)
			item:remove()
			break
		end
	end
	return true
end

surpriseBox:id(12045)
surpriseBox:register()
