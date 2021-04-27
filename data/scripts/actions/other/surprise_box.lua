local prize = {
    [1] = {chance = 1, id = 2358, amount = 1 },
    [2] = {chance = 2, id = 11144, amount = 1 },
    [3] = {chance = 3, id = 12544, amount = 1 },
    [4] = {chance = 4, id = 2640, amount = 1 },
    [5] = {chance = 5, id = 2520, amount = 1 },
    [6] = {chance = 10, id = ITEM_CRYSTAL_COIN, amount = 17 },
	[7] = {chance = 20, id = ITEM_GOLD_COIN, amount = 1 },
	[8] = {chance = 30, id = ITEM_CRYSTAL_COIN, amount = 1 },
	[9] = {chance = 40, id = ITEM_GOLD_COIN, amount = 50 },
	[10] = {chance = 50, id = ITEM_PLATINUM_COIN, amount = 15 },
	[11] = {chance = 90, id = ITEM_GOLD_COIN, amount = 80},
}

local surpriseBox = Action()

function surpriseBox.onUse(player, item, fromPosition, target, toPosition, isHotkey)

    for i = 1,#prize do local number = math.random() * 100
    if prize[i].chance>100-number then
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        player:addItem(prize[i].id, prize[i].amount)
        item:remove()
        break
    end
    end
    return true
end

surpriseBox:id(26333)
surpriseBox:register()
