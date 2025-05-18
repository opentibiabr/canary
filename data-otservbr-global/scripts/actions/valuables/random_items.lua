local config = {
	[12413] = { -- belonging of a deceased
		chances = {
			{ from = 1, to = 1442, itemId = 3123 },
			{ from = 1443, to = 2856, itemId = 19148 },
			{ from = 2857, to = 4262, itemId = 2996 },
			{ from = 4263, to = 4819, itemId = 3031, count = 6 },
			{ from = 4820, to = 5325, itemId = 3723 },
			{ from = 5326, to = 5813, itemId = 5890 },
			{ from = 5814, to = 6283, itemId = 3492, count = 4 },
			{ from = 6284, to = 6751, itemId = 3606 },
			{ from = 6752, to = 7175, itemId = 5899 },
			{ from = 7176, to = 7576, itemId = 5894 },
			{ from = 7577, to = 7949, itemId = 9689 },
			{ from = 7950, to = 8315, itemId = 3291 },
			{ from = 8316, to = 8673, itemId = 8031 },
			{ from = 8674, to = 8972, itemId = 5902 },
			{ from = 8973, to = 9187 },
			{ from = 9188, to = 9328, itemId = 3572 },
			{ from = 9329, to = 9428, itemId = 3083 },
			{ from = 9429, to = 9515, itemId = 12787 },
			{ from = 9516, to = 9594, itemId = 3026 },
			{ from = 9595, to = 9666, itemId = 5879 },
			{ from = 9667, to = 9732, itemId = 2995 },
			{ from = 9733, to = 9791, itemId = 12786 },
			{ from = 9792, to = 9845, itemId = 9646 },
			{ from = 9846, to = 9891, itemId = 2991 },
			{ from = 9892, to = 9929, itemId = 5895 },
			{ from = 9930, to = 9967, itemId = 5880 },
			{ from = 9968, to = 9998, itemId = 12519 },
			{ from = 9999, to = 10001, itemId = 3079 },
		},
		effect = CONST_ME_POFF,
	},
	[14172] = { -- gooey mass
		chances = {
			{ from = 1, to = 2 },
			{ from = 3, to = 2167, itemId = 14084, count = 10 },
			{ from = 2168, to = 4243, itemId = 3035, count = 2 },
			{ from = 4244, to = 6196, itemId = 3027, count = 2 },
			{ from = 6197, to = 8149, itemId = 239, count = 2 },
			{ from = 8150, to = 9823, itemId = 238, count = 2 },
			{ from = 9824, to = 9923, itemId = 9058 },
			{ from = 9924, to = 9990, itemId = 14143 },
			{ from = 9991, to = 10001, itemId = 14089 },
		},
		effect = CONST_ME_HITBYPOISON,
	},
	[15698] = { -- gnomish supply package
		chances = {
			{ from = 1, to = 1440, itemId = 3723, count = 20 },
			{ from = 1441, to = 2434, itemId = 16103 },
			{ from = 2435, to = 3270, itemId = 16143, count = 15 },
			{ from = 3271, to = 4085, itemId = 15793, count = 15 },
			{ from = 4086, to = 4836, itemId = 16167 },
			{ from = 4837, to = 5447, itemId = 236, count = 2 },
			{ from = 5448, to = 6047, itemId = 237, count = 2 },
			{ from = 6048, to = 6576, itemId = 266, count = 4 },
			{ from = 6577, to = 7094, itemId = 268, count = 4 },
			{ from = 7095, to = 7559, itemId = 238 },
			{ from = 7560, to = 7963, itemId = 239 },
			{ from = 7964, to = 8317, itemId = 7443 },
			{ from = 8318, to = 8628, itemId = 7439 },
			{ from = 8629, to = 8932, itemId = 3035, count = 5 },
			{ from = 8933, to = 9232, itemId = 5911 },
			{ from = 9233, to = 9511, itemId = 7440 },
			{ from = 9512, to = 9636, itemId = 16165 },
			{ from = 9637, to = 9747, itemId = 16257 },
			{ from = 9748, to = 9836, itemId = 16254 },
			{ from = 9837, to = 9893, itemId = 3043 },
			{ from = 9894, to = 9929, itemId = 3039 },
			{ from = 9930, to = 9958, itemId = 16242 },
			{ from = 9959, to = 9987, itemId = 3037 },
			{ from = 9988, to = 9994, itemId = 3041 },
			{ from = 9995, to = 10001, itemId = 3038 },
		},
		effect = CONST_ME_CRAPS,
	},
	[20264] = { -- unrealized dream
		chances = {
			{ from = 1, to = 1081, itemId = 3108 }, -- Rubbish (10.81%)
			{ from = 1082, to = 2125, itemId = 2992 }, -- Snowball (10.44%)
			{ from = 2126, to = 3109, itemId = 5792 }, -- Die (9.83%)
			{ from = 3110, to = 4074, itemId = 2856 }, -- Present (9.64%)
			{ from = 4075, to = 5039, itemId = 3659 }, -- Blue Rose (9.64%)
			{ from = 5040, to = 6007, itemId = 3568 }, -- Simple Dress (9.67%)
			{ from = 6008, to = 6969, itemId = 3463 }, -- Mirror (9.61%)
			{ from = 6970, to = 7457, itemId = 2995 }, -- Piggy Bank (4.87%)
			{ from = 7458, to = 7945, itemId = 2950 }, -- Lute (4.87%)
			{ from = 7946, to = 8268, itemId = 651 }, -- Spellwand (4.22%)
			{ from = 8269, to = 8659, itemId = 5929 }, -- Goldfish Bowl (3.90%)
			{ from = 8660, to = 8984, itemId = 3577 }, -- Meat (3.24%)
			{ from = 8985, to = 9192, itemId = 20271 }, -- Copper Prision Key (2.07%)
			{ from = 9193, to = 9396, itemId = 20272 }, -- Bronze Prison Key (2.03%)
			{ from = 9397, to = 9588, itemId = 20270 }, -- Silver Prison Key (1.91%)
			{ from = 9589, to = 9719, itemId = 20062 }, -- Cluster of Solace (1.30%)
			{ from = 9720, to = 9780, itemId = 3004 }, -- Wedding Ring (0.60%)
			{ from = 9781, to = 9842, itemId = 7459 }, -- Pair of Earmuffs (0.61%)
			{ from = 9843, to = 9894, itemId = 20275 }, -- Dream Warden Claw (0.51%)
			{ from = 9895, to = 9946, itemId = 20273 }, -- Golden Prison Key (0.51%)
			{ from = 9947, to = 9987, itemId = 3242 }, -- Stuffed Bunny (0.40%)
			{ from = 9988, to = 10001, itemId = 12548 }, -- Bag of Apple Slices (0.13%)
		},
		effect = CONST_ME_BUBBLES,
	},
	[21333] = { -- Belongings of a Deceased (The Ravager) - Dark Trails Quest
		chances = {
			{ from = 1, to = 2500, itemId = 3043 }, -- crystal coins
			{ from = 2501, to = 5000, itemId = 3041 }, -- blue gem
			{ from = 5001, to = 7500, itemId = 3038 }, -- green gem
			{ from = 7501, to = 10001, itemId = 3331 }, -- ravager's axe
		},
		effect = CONST_ME_MAGIC_GREEN,
	},
	[21334] = { -- Belongings of a Deceased (Death Priest Shargon) - Dark Trails Quest
		chances = {
			{ from = 1, to = 2500, itemId = 3043 }, -- crystal coins
			{ from = 2501, to = 5000, itemId = 5741 }, -- skull helmet
			{ from = 5001, to = 7500, itemId = 3324 }, -- skull staff
			{ from = 7501, to = 10001, itemId = 9056 }, -- black skull
		},
		effect = CONST_ME_MAGIC_GREEN,
	},
	[22763] = { -- shaggy ogre bag
		chances = {
			{ from = 1, to = 1440, itemId = 22187, count = 5 },
			{ from = 1441, to = 2434, itemId = 22191 },
			{ from = 2435, to = 3270, itemId = 22184 },
			{ from = 3271, to = 4085, itemId = 22194, count = 2 },
			{ from = 4086, to = 4836, itemId = 22188 },
			{ from = 4837, to = 5447, itemId = 22193, count = 3 },
			{ from = 5448, to = 6047, itemId = 3403 },
			{ from = 6048, to = 6576, itemId = 3406 },
			{ from = 6577, to = 7094, itemId = 7432 },
			{ from = 7095, to = 7418, itemId = 22183 },
			{ from = 7419, to = 7741, itemId = 22172 },
			{ from = 7742, to = 8064, itemId = 22171 },
			{ from = 8065, to = 8387, itemId = 3443 },
			{ from = 8388, to = 8710, itemId = 3560 },
			{ from = 8711, to = 9033, itemId = 22192 },
			{ from = 9034, to = 9356, itemId = 7413 },
			{ from = 9357, to = 9679, itemId = 7452 },
			{ from = 9680, to = 10001, itemId = 5668 },
		},
		effect = CONST_ME_CRAPS,
	},
	[23509] = { -- mysterious remains
		chances = {
			{ from = 1, to = 1440, itemId = 3723, count = 10 },
			{ from = 1441, to = 2434, itemId = 2995 },
			{ from = 2435, to = 3270, itemId = 3572 },
			{ from = 3271, to = 4085, itemId = 5880 },
			{ from = 4086, to = 4836, itemId = 3044 },
			{ from = 4837, to = 5447, itemId = 3083 },
			{ from = 5448, to = 6047, itemId = 5879 },
			{ from = 6048, to = 6576, itemId = 6570 },
			{ from = 6577, to = 7094, itemId = 3049 },
			{ from = 7095, to = 7559, itemId = 5882 },
			{ from = 7560, to = 7963, itemId = 12548 },
			{ from = 7964, to = 8317, itemId = 15698 },
			{ from = 8318, to = 8628, itemId = 3046 },
			{ from = 8629, to = 8932, itemId = 22194 },
			{ from = 8933, to = 9232, itemId = 8899 },
			{ from = 9233, to = 9511, itemId = 2958 },
			{ from = 9512, to = 9636, itemId = 22763 },
			{ from = 9637, to = 9747, itemId = 3037 },
			{ from = 9748, to = 9836, itemId = 3036 },
			{ from = 9837, to = 9893, itemId = 9058 },
			{ from = 9894, to = 9929, itemId = 22737 },
			{ from = 9930, to = 9958, itemId = 23536 },
			{ from = 9959, to = 10001, itemId = 22731 },
		},
		effect = CONST_ME_CRAPS,
	},
	[26186] = { -- mystery box
		chances = {
			{ from = 0, to = 5001, itemId = 25361 }, -- blood of the mountain
			{ from = 5002, to = 10001, itemId = 25360 }, -- heart of the mountain
		},
		effect = CONST_ME_CRAPS,
	},
	[27654] = { -- surprise jar
		chances = {
			{ from = 0, to = 2500, itemId = 3041 },
			{ from = 2501, to = 5001, itemId = 3036 },
			{ from = 5002, to = 6668, itemId = 22721 },
			{ from = 6668, to = 8335, itemId = 22516 },
			{ from = 8336, to = 10001, itemId = 27653 },
		},
		effect = CONST_ME_CRAPS,
	},
}

local randomItems = Action()

function randomItems.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local useId = config[item.itemid]
	if not useId then
		return false
	end

	local chance = math.random(10001)
	for i = 1, #useId.chances do
		local randomItem = useId.chances[i]
		if chance >= randomItem.from and chance <= randomItem.to then
			if randomItem.itemId then
				local itemId, count = randomItem.itemId, randomItem.count or 1
				player:addItem(itemId, count)
				if item.itemid == 12413 then
					local itemType = ItemType(itemId)
					player:say("You found " .. (count > 1 and count or (itemType:getArticle() ~= "" and itemType:getArticle() or "")) .. " " .. (count > 1 and itemType:getPluralName() or itemType:getName()) .. " in the bag.", TALKTYPE_MONSTER_SAY)
				end
			else
				player:say("You found nothing useful.", TALKTYPE_MONSTER_SAY)
			end

			item:getPosition():sendMagicEffect(useId.effect)
			item:remove(1)
			break
		end
	end
	return true
end

for itemId, info in pairs(config) do
	randomItems:id(itemId)
end

randomItems:register()
