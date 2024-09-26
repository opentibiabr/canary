local prize = {
    [1] = {chance = 10, id = 2867, amount = 1},
    [2] = {chance = 10, id = 2869, amount = 1},
    [3] = {chance = 10, id = 5949, amount = 1},
    [4] = {chance = 10, id = 2872, amount = 1},
    [5] = {chance = 10, id = 8860, amount = 1},
    [6] = {chance = 10, id = 5926, amount = 1},
	[7] = {chance = 10, id = 9602, amount = 1},
	[8] = {chance = 10, id = 2865, amount = 1},
	[9] = {chance = 10, id = 2870, amount = 1},
	[10] = {chance = 10, id = 2866, amount = 1},
	[11] = {chance = 10, id = 9601, amount = 1},
	[12] = {chance = 10, id = 2868, amount = 1},
	[13] = {chance = 10, id = 9605, amount = 1},
	[14] = {chance = 10, id = 10202, amount = 1},
	[15] = {chance = 10, id = 10327, amount = 1},
	[16] = {chance = 10, id = 14248, amount = 1},
	[17] = {chance = 10, id = 5801, amount = 1},
	[18] = {chance = 10, id = 7342, amount = 1},
	[19] = {chance = 10, id = 16099, amount = 1},
	[20] = {chance = 10, id = 10324, amount = 1},
	[21] = {chance = 10, id = 2871, amount = 1},
	[22] = {chance = 10, id = 10326, amount = 1},
	[23] = {chance = 10, id = 21295, amount = 1},
	[24] = {chance = 2, id = 3253, amount = 1},
	[25] = {chance = 2, id = 9604, amount = 1},
	[26] = {chance = 2, id = 28571, amount = 1},
	[27] = {chance = 2, id = 31625, amount = 1},
	[28] = {chance = 1, id = 35577, amount = 1},
	[29] = {chance = 1, id = 22084, amount = 1},
	[30] = {chance = 1, id = 14249, amount = 1},
	[31] = {chance = 1, id = 21292, amount = 1},
	[32] = {chance = 1, id = 23525, amount = 1},
	[33] = {chance = 1, id = 16100, amount = 1},
	[34] = {chance = 1, id = 10346, amount = 1},
	[35] = {chance = 1, id = 19159, amount = 1},
	[36] = {chance = 1, id = 32620, amount = 1},
}

local luckyPig = Action()

function luckyPig.onUse(player, item, fromPosition, target, toPosition, isHotkey)

    for i = 1,#prize do local number = math.random() * 100
    if prize[i].chance>100-number then
        player:getPosition():sendMagicEffect(52)
        player:addItem(prize[i].id, prize[i].amount)
        item:remove()
        break
    end
    end
    return true
end

luckyPig:id(30320)
luckyPig:register()