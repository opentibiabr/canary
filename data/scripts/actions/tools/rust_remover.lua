local CHAIN_ARMOR, SCALE_ARMOR, BRASS_ARMOR, PLATE_ARMOR, KNIGHT_ARMOR, PALADIN_ARMOR, CROWN_ARMOR, GOLDEN_ARMOR, DRAGON_SCALE_MAIL, MAGIC_PLATE_ARMOR = 2464, 2483, 2465, 2463, 2476, 8891, 2487, 2466, 2492, 2472
local STUDDED_LEGS, CHAIN_LEGS, BRASS_LEGS, PLATE_LEGS, KNIGHT_LEGS, CROWN_LEGS, GOLDEN_LEGS = 2468, 2648, 2478, 2647, 2477, 2488, 2470
local BRASS_HELMET, IRON_HELMET, STEEL_HELMET, CROWN_HELMET, CRUSADER_HELMET, ROYAL_HELMET = 2460, 2459, 2457, 2491, 2497, 2498

local config = {
	[9808] = { -- common rusty armor
		{{1, 30000}},
		{{30001, 60000}, CHAIN_ARMOR},
		{{60001, 90000}, SCALE_ARMOR},
		{{90001, 97000}, BRASS_ARMOR},
		{{97001, 99000}, PLATE_ARMOR},
		{{99001, 100000}, KNIGHT_ARMOR}
	},

	[9820] = { -- semi-rare rusty helmet
		{{1, 40000}},
		{{40001, 57500}, BRASS_HELMET},
		{{57501, 70000}, IRON_HELMET},
		{{70001, 81000}, STEEL_HELMET},
		{{81001, 94000}, CROWN_HELMET},
		{{94001, 98500}, CRUSADER_HELMET},
		{{98501, 100000}, ROYAL_HELMET}
	},


	[9809] = { -- semi-rare rusty armor
		{{1, 40000}},
		{{40001, 57500}, CHAIN_ARMOR},
		{{57501, 70000}, SCALE_ARMOR},
		{{70001, 81000}, BRASS_ARMOR},
		{{81001, 90000}, PLATE_ARMOR},
		{{90001, 96500}, KNIGHT_ARMOR},
		{{96501, 99500}, PALADIN_ARMOR},
		{{99501, 100000}, CROWN_ARMOR}
	},
	[9810] = { -- rare rusty armor
		{{1, 50000}},
		{{50001, 60000}, CHAIN_ARMOR},
		{{60001, 70000}, SCALE_ARMOR},
		{{70001, 80000}, BRASS_ARMOR},
		{{80001, 87500}, PLATE_ARMOR},
		{{87501, 93000}, KNIGHT_ARMOR},
		{{93001, 96000}, PALADIN_ARMOR},
		{{96000, 97000}, CROWN_ARMOR},
		{{96001, 98500}, GOLDEN_ARMOR},
		{{98501, 99500}, DRAGON_SCALE_MAIL},
		{{99501, 100000}, MAGIC_PLATE_ARMOR}
	},
	[9811] = { -- common rusty legs
		{{1, 30000}},
		{{30001, 60000}, STUDDED_LEGS},
		{{60001, 85000}, CHAIN_LEGS},
		{{85001, 98000}, BRASS_LEGS},
		{{98001, 99500}, PLATE_LEGS},
		{{99501, 100000}, KNIGHT_LEGS}
	},
	[9812] = { -- semi-rare rusty legs
		{{1, 40000}},
		{{40001, 60000}, STUDDED_LEGS},
		{{60001, 75000}, CHAIN_LEGS},
		{{75001, 87500}, BRASS_LEGS},
		{{87501, 95500}, PLATE_LEGS},
		{{95501, 98250}, KNIGHT_LEGS},
		{{98251, 99250}, CROWN_LEGS},
		{{99251, 100000}, GOLDEN_LEGS}
	},
	[9813] = { -- rare rusty legs
		{{1, 50000}},
		{{50001, 75000}, BRASS_LEGS},
		{{75001, 90000}, PLATE_LEGS},
		{{90001, 97500}, KNIGHT_LEGS},
		{{97501, 99000}, CROWN_LEGS},
		{{99001, 100000}, GOLDEN_LEGS}
	}
}

local rustRemover = Action()

function rustRemover.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetItem = config[target.itemid]
	if not targetItem then
		return true
	end

	local chance = math.random(100000)
	for i = 1, #targetItem do
		if chance >= targetItem[i][1][1] and chance <= targetItem[i][1][2] then
			if targetItem[i][2] then
				target:transform(targetItem[i][2])
				toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
			else
				player:say((isInArray({9808, 9809, 9810}, target.itemid) and "The item was already damaged so badly that it broke when you tried to clean it." or "The item were already damaged so badly that they broke when you tried to clean them."),TALKTYPE_MONSTER_SAY)
				target:remove()
				toPosition:sendMagicEffect(CONST_ME_BLOCKHIT)
			end
			return item:remove(1)
		end
	end
end

rustRemover:id(9930)
rustRemover:register()
