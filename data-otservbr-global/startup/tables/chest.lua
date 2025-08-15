--[[
	Look README.md for see the reserved action/unique numbers
	From range 5000 to 6000 is reserved for keys chest
	From range 6001 to 472 is reserved for script reward
	Path: data\scripts\actions\system\quest_reward_common.lua

	From range 473 to 15000 is reserved for others scripts (varied rewards)

	There is no need to tamper with the chests scripts, just register a new table and configure correctly
	So the quest will work in-game

	Example:
	[xxxx] = {
		-- For use of the map
		itemId = xxxx,
		itemPos = {x = xxxxx, y = xxxxx, z = x},
		-- For use of the script
		container = xxxx (it's for use reward in a container, only put the id of the container here)
		keyAction = xxxx, (it's for use one key in the chest and is reward in container, only put the key in reward and action here)
		reward = {{xxxx, x}},
		storage = xxxxx
	},

		Example using KV:
		[xxxx] = {
			useKV = true,
			itemId = xxxx,
			itemPos = {x = xxxxx, y = xxxxx, z = x},
			container = xxxx, (it's for use reward in a container, only put the id of the container here)
			reward = {{xxxx, x}},
			questName = "testkv",
		}

	Note:
	The "for use of the map" variables are only used to create the action or unique on the map during startup
	If the reward is an key, do not need to use "keyAction", only set the storage as same action id

	The "for use of the script" variables are used by the scripts
	To allow a single script to manage all rewards
]]

ChestAction = {
	--[[
	-- Example of usage
	[5000] = {
		itemId = xxxx,
		itemPos = {
			{x = xxxxx, y = xxxxx, z = x},
			{x = xxxxx, y = xxxxx, z = x}
		},
		action = xxxx,
		reward = {{xxxx, 1}},
		storage = storage
	},]]
	-- Keys quest
	[5000] = {
		itemId = false,
		itemPos = {
			{ x = 33057, y = 31029, z = 7 },
			{ x = 33055, y = 31029, z = 7 },
			{ x = 33053, y = 31029, z = 7 },
		},
	},
	-- The New Frontier Quest
	[5001] = { -- Reward Outfit
		itemId = 5862,
		itemPos = {
			{ x = 33053, y = 31020, z = 7 },
		},
	},
	-- Key  5010 (dead tree black knight quest)
	[5002] = {
		isKey = true,
		itemId = 3634,
		itemPos = {
			{ x = 32813, y = 31964, z = 7 },
			{ x = 32800, y = 31959, z = 7 },
		},
		reward = { { 2969, 1 } },
		storage = Storage.Quest.Key.ID5010,
	},
}

ChestUnique = {
	-- Keys quest
	-- data\scripts\actions\system\quest_reward_key.lua
	-- Deeper fibula quest key 3496
	[5000] = {
		isKey = true,
		itemId = 387,
		itemPos = { x = 32219, y = 32401, z = 10 },
		reward = { { 2972, 1 } },
		storage = Storage.Quest.Key.ID3980,
	},
	-- Panpipe quest key 3791
	[5001] = {
		isKey = true,
		itemId = 1777,
		itemPos = { x = 32652, y = 32107, z = 7 },
		reward = { { 2969, 1 } },
		storage = Storage.Quest.Key.ID4055,
	},
	-- Dawnport quest key 0010 chest
	[5002] = {
		isKey = true,
		itemId = 2434,
		itemPos = { x = 32068, y = 31895, z = 3 },
		reward = { { 21392, 1 } },
		storage = Storage.Quest.Key.ID0010,
	},
	-- Emperor's cookies quest
	[5003] = { --  key 3800
		isKey = true,
		itemId = 2472,
		itemPos = { x = 32605, y = 31908, z = 3 },
		reward = { { 2970, 1 } },
		storage = Storage.Quest.Key.ID3800,
	},
	-- Emperor's cookies quest
	[5004] = { -- bag with cookies and key 3801
		isKey = true,
		itemId = 2472,
		itemPos = { x = 32648, y = 31905, z = 3 },
		container = 2853,
		reward = { { 2970, 1 }, { 3598, 27 } },
		weight = 12.00,
		storage = Storage.Quest.U6_1.EmperorsCookies.Rewards.Cookies,
		keyAction = Storage.Quest.Key.ID3801,
	},
	-- Emperor's cookies quest
	[5005] = { --  key 3802
		isKey = true,
		itemId = 2472,
		itemPos = { x = 32599, y = 31923, z = 6 },
		reward = { { 2970, 1 } },
		storage = Storage.Quest.Key.ID3802,
	},
	-- Black knight quest key 5010
	[5006] = {
		isKey = true,
		itemId = 3634,
		itemPos = { x = 32800, y = 31959, z = 7 },
		reward = { { 2969, 1 } },
		storage = Storage.Quest.Key.ID5010,
	},
	[5007] = {
		isKey = true,
		itemId = 3634,
		itemPos = { x = 32813, y = 31964, z = 7 },
		reward = { { 2969, 1 } },
		storage = Storage.Quest.Key.ID5010,
	},
	[5008] = {
		isKey = true,
		itemId = 2472,
		itemPos = { x = 32201, y = 31571, z = 10 },
		container = 2853,
		reward = { { 2970, 1 }, { 3031, 23 }, { 3147, 1 }, { 3298, 4 }, { 3384, 1 } },
		weight = 80.00,
		storage = Storage.Quest.Key.ID4502,
		keyAction = Storage.Quest.Key.ID4502,
	},
	[5009] = {
		isKey = true,
		itemId = 2434,
		itemPos = { x = 32411, y = 32155, z = 15 },
		reward = { { 2969, 1 } },
		storage = Storage.Quest.Key.ID3620,
	},
	[5010] = {
		isKey = true,
		itemId = 2434,
		itemPos = { x = 32411, y = 32155, z = 15 },
		reward = { { 2969, 1 } },
		storage = Storage.Quest.Key.ID3620,
	},
	[5011] = {
		isKey = true,
		itemId = 3634,
		itemPos = { x = 32497, y = 31887, z = 7 },
		reward = { { 2970, 1 } },
		storage = Storage.Quest.Key.ID3899,
	},
	-- The Secret Library Quest
	[5012] = {
		isKey = true,
		itemId = 23740,
		itemPos = { x = 33377, y = 31321, z = 1 },
		reward = { { 2969, 1 } },
		storage = Storage.Quest.Key.ID0909,
	},
	-- Bear Room Quest (rookgaard) key 4601
	[5013] = {
		isKey = true,
		itemId = 2472,
		itemPos = { x = 32150, y = 32112, z = 12 },
		reward = { { 2970, 1 } },
		storage = Storage.Quest.Key.ID4601,
	},
	-- Katana Quest (rookgaard) key 4603
	[5014] = {
		isKey = true,
		itemId = 4240,
		itemPos = { x = 32176, y = 32132, z = 9 },
		reward = { { 2969, 1 } },
		storage = Storage.Quest.Key.ID4603,
	},
	-- Key 3600
	[5015] = {
		isKey = true,
		itemId = 4285,
		itemPos = { x = 32509, y = 32181, z = 13 },
		reward = { { 2969, 1 } },
		storage = Storage.Quest.Key.ID3600,
	},
	-- Key 3667
	[5016] = {
		isKey = true,
		itemId = 3204,
		itemPos = { x = 32576, y = 32216, z = 15 },
		reward = { { 2969, 1 } },
		storage = Storage.Quest.Key.ID3667,
	},
	-- Key 3610
	[5017] = {
		isKey = true,
		itemId = 387,
		itemPos = { x = 32589, y = 32100, z = 14 },
		reward = { { 2969, 1 } },
		storage = Storage.Quest.Key.ID3610,
	},
	-- Key 3520
	[5018] = {
		isKey = true,
		itemId = 2473,
		itemPos = { x = 32376, y = 31802, z = 7 },
		reward = { { 2973, 1 } },
		storage = Storage.Quest.Key.ID3520,
	},
	-- Key 3301 (outlaw camp key 1)
	[5019] = {
		isKey = true,
		itemId = 3634,
		itemPos = { x = 32617, y = 32250, z = 7 },
		reward = { { 2970, 1 } },
		storage = Storage.Quest.Key.ID3301,
	},
	-- Key 3302 (outlaw camp key 2)
	[5020] = {
		isKey = true,
		itemId = 3634,
		itemPos = { x = 32609, y = 32244, z = 7 },
		reward = { { 2969, 1 } },
		storage = Storage.Quest.Key.ID3302,
	},
	-- Key 3303 (outlaw camp key 3)
	[5021] = {
		isKey = true,
		itemId = 3634,
		itemPos = { x = 32651, y = 32244, z = 7 },
		reward = { { 2970, 1 } },
		storage = Storage.Quest.Key.ID3303,
	},
	-- Key 3304 (outlaw camp key 4)
	[5022] = {
		isKey = true,
		itemId = 2472,
		itemPos = { x = 32623, y = 32187, z = 9 },
		reward = { { 2972, 1 } },
		storage = Storage.Quest.Key.ID3304,
	},
	-- Key 3008 (Draconia Quest)
	[5023] = {
		isKey = true,
		itemId = 2435,
		itemPos = { x = 32800, y = 31582, z = 2 },
		reward = { { 2969, 1 } },
		storage = Storage.Quest.Key.ID3008,
	},
	-- The Pits of Inferno - Key 3700
	[5024] = {
		isKey = true,
		itemId = 2472,
		itemPos = { x = 32842, y = 32225, z = 8 },
		reward = { { 2971, 1 } },
		storage = Storage.Quest.Key.ID3700,
	},
	-- To add a reward inside a bag, you need to add the variable "container = bagId" before "reward"
	-- Just duplicate the table and configure correctly, the scripts already register the entire table automatically
	-- Path: data\scripts\actions\system\quest_reward_common.lua
	-- Halls of hope
	[6001] = {
		itemId = 23740,
		itemPos = { x = 32349, y = 32194, z = 9 },
		reward = { { 23986, 1 } },
		storage = Storage.HallsOfHope.Reward1,
	},
	[6002] = {
		itemId = 23740,
		itemPos = { x = 32382, y = 32368, z = 9 },
		reward = { { 23986, 1 } },
		storage = Storage.HallsOfHope.Reward2,
	},
	[6003] = {
		itemId = 23740,
		itemPos = { x = 32287, y = 32119, z = 7 },
		reward = { { 23986, 1 } },
		storage = Storage.HallsOfHope.Reward3,
	},
	[6004] = {
		itemId = 23741,
		itemPos = { x = 32389, y = 32001, z = 6 },
		reward = { { 23986, 1 } },
		storage = Storage.HallsOfHope.Reward4,
	},
	[6005] = {
		itemId = 23740,
		itemPos = { x = 32449, y = 32109, z = 8 },
		reward = { { 23986, 1 } },
		storage = Storage.HallsOfHope.Reward5,
	},
	-- Dawnport
	-- Legion helmet quest (dawnport)
	[6006] = {
		useKV = true,
		itemId = 4240,
		itemPos = { x = 32143, y = 31910, z = 8 },
		reward = { { 3374, 1 } },
		questName = "legiondawnport",
	},
	-- Dawnport quest
	-- Torn log book
	[6007] = {
		itemId = 2472,
		itemPos = { x = 32059, y = 31800, z = 10 },
		reward = { { 21378, 1 } },
		storage = Storage.Quest.U10_55.Dawnport.TornLogBook,
	},
	-- Deeper fibula quest
	[6008] = {
		useKV = true,
		itemId = 4024,
		itemPos = { x = 32239, y = 32471, z = 10 },
		reward = { { 3428, 1 } }, -- Tower shield
		questName = "deeperfibula1",
	},
	[6009] = {
		useKV = true,
		itemId = 4024,
		itemPos = { x = 32239, y = 32478, z = 10 },
		reward = { { 3369, 1 } }, -- Warrior helmet
		questName = "deeperfibula2",
	},
	[6010] = {
		useKV = true,
		itemId = 4240,
		itemPos = { x = 32233, y = 32491, z = 10 },
		reward = { { 3097, 1 } }, -- Dwarven ring
		questName = "deeperfibula3",
	},
	[6011] = {
		useKV = true,
		itemId = 4025,
		itemPos = { x = 32245, y = 32492, z = 10 },
		reward = { { 3082, 1 } }, -- Elven aulet
		questName = "deeperfibula4",
	},
	[6012] = {
		useKV = true,
		itemId = 4240,
		itemPos = { x = 32256, y = 32500, z = 10 },
		reward = { { 3318, 1 } }, -- Knight axe
		questName = "deeperfibula5",
	},
	-- Short sword quest
	-- Book
	[6013] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32171, y = 32197, z = 7 },
		reward = { { 2821, 1 } },
		questName = "shortswordbook",
	},
	-- Thais lighthouse quest
	-- Battle hammer
	[6014] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32225, y = 32265, z = 10 },
		reward = { { 3305, 1 } },
		questName = "lighthouse1",
	},
	-- Dark shield
	[6015] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32226, y = 32265, z = 10 },
		reward = { { 3421, 1 } },
		questName = "lighthouse2",
	},
	-- Studded shield quest (rookgaard)
	-- Banana free account area
	[6016] = {
		useKV = true,
		itemId = 3639,
		itemPos = { x = 32172, y = 32169, z = 7 },
		reward = { { 3587, 1 } },
		questName = "bananafree",
	},
	-- Banana premium account area
	[6017] = {
		useKV = true,
		itemId = 3639,
		itemPos = { x = 31983, y = 32193, z = 5 },
		reward = { { 3587, 1 } },
		questName = "bananapremium",
	},
	-- The Explorer Society - Explorer brooch (kazordoon)
	[6019] = {
		useKV = true,
		itemId = 4240,
		itemPos = { x = 32636, y = 31873, z = 10 },
		reward = { { 4871, 1 } },
		questName = "explorerbrooch",
	},
	-- Orc fortress quest
	[6020] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 32980, y = 31727, z = 9 },
		reward = { { 3318, 1 } }, -- Knight axe
		questName = "orcfortress1",
	},
	[6021] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 32981, y = 31727, z = 9 },
		reward = { { 3370, 1 } }, -- Knight armor
		questName = "orcfortress2",
	},
	[6022] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 32985, y = 31727, z = 9 },
		reward = { { 3280, 1 } }, -- Fire sword
		questName = "orcfortress3",
	},
	-- Draconia quest
	[6023] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32803, y = 31582, z = 2 },
		container = 2853,
		reward = { { 3284, 1 }, { 3297, 1 } }, -- bag with weapons
		weight = 64.00,
		questName = "draconia1",
	},
	[6024] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32804, y = 31582, z = 2 },
		container = 2853,
		reward = { { 3081, 5 }, { 3051, 1 } }, -- bag with amulets
		weight = 15.80,
		questName = "draconia2",
	},
	-- Adorned UH rune quest
	[6025] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 33136, y = 31601, z = 15 },
		reward = { { 11603, 1 } },
		questName = "adoreduh",
	},
	-- Barbarian axe quest
	[6026] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 33184, y = 31945, z = 11 },
		reward = { { 3317, 1 } }, -- Barbarian axe
		questName = "barbarianaxe1",
	},
	[6027] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 33185, y = 31945, z = 11 },
		reward = { { 3307, 1 } }, -- Scimitar
		questName = "barbarianaxe1",
	},
	-- Dark armor quest
	[6028] = {
		useKV = true,
		itemId = 4311,
		itemPos = { x = 33178, y = 31870, z = 12 },
		reward = { { 3383, 1 } },
		questName = "darkarmor",
	},
	-- Demon helmet quest
	-- Steel boots
	[6029] = {
		itemId = 2472,
		itemPos = { x = 33313, y = 31574, z = 15 },
		reward = { { 3554, 1 } },
		storage = Storage.Quest.U6_4.DemonHelmet.Rewards.SteelBoots,
	},
	-- Demon helmet
	[6030] = {
		itemId = 2472,
		itemPos = { x = 33313, y = 31575, z = 15 },
		reward = { { 3387, 1 } },
		storage = Storage.Quest.U6_4.DemonHelmet.Rewards.DemonHelmet,
	},
	-- Demon shield
	[6031] = {
		itemId = 2472,
		itemPos = { x = 33313, y = 31576, z = 15 },
		reward = { { 3420, 1 } },
		storage = Storage.Quest.U6_4.DemonHelmet.Rewards.DemonShield,
	},
	-- Double hero quest
	[6032] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 33109, y = 31679, z = 13 },
		reward = { { 3039, 1 } }, -- Red gem
		questName = "doublehero1",
	},
	[6033] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 33110, y = 31679, z = 13 },
		reward = { { 3093, 1 } }, -- Club ring
		questName = "doublehero2",
	},
	-- Edron goblin quest
	[6034] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 33095, y = 31800, z = 10 },
		reward = { { 3054, 200 } }, -- Silver amulet
		questName = "edrongoblin1",
	},
	[6035] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 33095, y = 31801, z = 10 },
		reward = { { 3409, 1 } }, -- Steel shield
		questName = "edrongoblin2",
	},
	-- Fire axe quest
	[6036] = {
		useKV = true,
		itemId = 4024,
		itemPos = { x = 33084, y = 31650, z = 12 },
		reward = { { 3320, 1 } }, -- Fire axe
		questName = "fireaxe2",
	},
	-- Ring Quest
	[6037] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 33131, y = 31624, z = 15 },
		reward = { { 3053, 1 } }, -- Time ring
		questName = "ringquest1",
	},
	[6038] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 33134, y = 31624, z = 15 },
		reward = { { 3091, 1 } }, -- Sword ring
		questName = "ringquest2",
	},
	-- Troll cave quest
	[6039] = {
		useKV = true,
		itemId = 2473,
		itemPos = { x = 33143, y = 31719, z = 10 },
		reward = { { 3083, 150 } }, -- Garlic necklace
		questName = "trollcave1",
	},
	[6040] = {
		useKV = true,
		itemId = 2473,
		itemPos = { x = 33143, y = 31721, z = 10 },
		reward = { { 3372, 1 } }, -- Brass legs
		questName = "trollcave1",
	},
	-- Vampire shield quest
	[6041] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 33189, y = 31688, z = 14 },
		reward = { { 3302, 1 } }, -- Dragon lance
		questName = "vampireshield2",
	},
	[6042] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 33195, y = 31688, z = 14 },
		reward = { { 3434, 1 } }, -- Vampire shield
		questName = "vampireshield3",
	},
	-- Wedding Ring Quest
	[6043] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 33158, y = 31621, z = 15 },
		reward = { { 3085, 200 } }, -- Dragon necklace
		questName = "weddingring1",
	},
	[6044] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 33158, y = 31622, z = 15 },
		reward = { { 3004, 1 } }, -- Weeding ring
		questName = "weddingring2",
	},
	-- Alawars vault quest
	[6045] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32105, y = 31567, z = 9 },
		reward = { { 3026, 3 } }, -- White pearl
		questName = "AlawarsVault1",
	},
	[6046] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32109, y = 31567, z = 9 },
		reward = { { 3301, 1 } }, -- Broadsword
		questName = "AlawarsVault2",
	},
	-- Black knight quest
	[6047] = {
		useKV = true,
		itemId = 3634,
		itemPos = { x = 32868, y = 31955, z = 11 },
		reward = { { 3381, 1 } }, -- Crown armor
		questName = "Blackknight1",
	},
	[6048] = {
		useKV = true,
		itemId = 3634,
		itemPos = { x = 32880, y = 31955, z = 11 },
		reward = { { 3419, 1 } }, -- Crown shield
		questName = "Blackknight2",
	},
	-- Time Ring Quest
	[6049] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 33038, y = 32171, z = 9 },
		reward = { { 3076, 1 } }, -- Crystal ball
		questName = "timering1",
	},
	[6050] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 33039, y = 32171, z = 9 },
		reward = { { 3053, 1 } }, -- Time ring
		questName = "timering2",
	},
	[6051] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 33040, y = 32171, z = 9 },
		reward = { { 3082, 50 } }, -- Elven amulet
		questName = "timering3",
	},
	-- Behemoth quest
	[6052] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 33295, y = 31658, z = 13 },
		reward = { { 3315, 1 } }, -- Guardian halberd
		questName = "behemothquest2",
	},
	[6053] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 33297, y = 31658, z = 13 },
		reward = { { 3420, 1 } }, -- Demon shield
		questName = "behemothquest3",
	},
	[6054] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 33298, y = 31658, z = 13 },
		reward = { { 3360, 1 } }, -- Golden armor
		questName = "behemothquest4",
	},
	-- Family brooch quest
	[6055] = {
		itemId = 2476,
		itemPos = { x = 32248, y = 31866, z = 8 },
		reward = { { 3205, 1 } },
		storage = Storage.Quest.U7_24.FamilyBrooch.Brooch,
	},
	-- The queen of the banshees quest
	-- Stone skin amulet
	[6056] = {
		itemId = 2472,
		itemPos = { x = 32212, y = 31896, z = 15 },
		reward = { { 3081, 1 } },
		storage = Storage.Quest.U7_2.TheQueenOfTheBanshees.Reward.StoneSkinAmulet,
	},
	-- Stone skin amulet
	[6057] = {
		itemId = 2472,
		itemPos = { x = 32226, y = 31896, z = 15 },
		reward = { { 3049, 1 } },
		storage = Storage.Quest.U7_2.TheQueenOfTheBanshees.Reward.StealthRing,
	},
	-- Tower shield
	[6058] = {
		itemId = 2472,
		itemPos = { x = 32212, y = 31910, z = 15 },
		reward = { { 3428, 1 } },
		storage = Storage.Quest.U7_2.TheQueenOfTheBanshees.Reward.TowerShield,
	},
	-- Giant sword
	[6059] = {
		itemId = 2472,
		itemPos = { x = 32226, y = 31910, z = 15 },
		reward = { { 3281, 1 } },
		storage = Storage.Quest.U7_2.TheQueenOfTheBanshees.Reward.GiantSword,
	},
	-- Boots of haste
	[6060] = {
		itemId = 2472,
		itemPos = { x = 32218, y = 31912, z = 15 },
		reward = { { 3079, 1 } },
		storage = Storage.Quest.U7_2.TheQueenOfTheBanshees.Reward.BootsOfHaste,
	},
	-- 100 platinum coins
	[6061] = {
		itemId = 2472,
		itemPos = { x = 32220, y = 31912, z = 15 },
		reward = { { 3035, 100 } },
		storage = Storage.Quest.U7_2.TheQueenOfTheBanshees.Reward.PlatinumCoin,
	},
	-- Ornamented shield quest
	[6062] = {
		itemId = 4024,
		itemPos = { x = 32778, y = 32282, z = 11 },
		container = 2853,
		keyAction = Storage.Quest.Key.ID3702,
		reward = { { 2971, 1 }, { 3509, 1 }, { 3351, 1 }, { 3424, 1 }, { 2821, 1 }, { 3271, 1 }, { 3085, 1 }, { 3048, 1 } },
		weight = 195.00,
		storage = Storage.Quest.PreU6_0.OrnamentedShield.Rewards.OrnamentedShield,
	},
	[6063] = {
		useKV = true,
		itemId = 2480,
		itemPos = { x = 32769, y = 32302, z = 10 },
		container = 2859,
		reward = { { 2949, 1 }, { 3059, 1 }, { 3083, 1 }, { 3035, 5 }, { 3053, 1 } },
		weight = 44.00,
		questName = "ornamentedshield",
	},
	--[6064] EMPTY
	[6065] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32644, y = 32131, z = 8 },
		container = 2853,
		reward = { { 3033, 2 }, { 3050, 1 }, { 2953, 1 } },
		weight = 18.00,
		questName = "panpipe",
	},
	[6066] = {
		itemId = 2469,
		itemPos = { x = 33199, y = 31923, z = 11 },
		container = 2853,
		reward = { { 3031, 98 }, { 3031, 77 }, { 3026, 3 } },
		weight = 27.00,
		storage = Storage.Quest.U6_4.BerserkerTreasure.Rewards.WhitePearls,
	},
	-- Fire axe quest
	[6067] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 33078, y = 31656, z = 11 },
		container = 2853,
		reward = { { 3098, 1 }, { 3085, 200 }, { 3028, 7 }, { 3320, 1 } }, -- Bag (Ring of Healing, Dragon Necklace, 7 Small Diamonds)
		weight = 56.00,
		questName = "fireaxe1",
	},
	-- Poison daggers quest
	[6068] = {
		useKV = true,
		itemId = 2473,
		itemPos = { x = 33155, y = 31880, z = 11 },
		container = 2854,
		reward = { { 3448, 30 }, { 3299, 1 } }, -- Backpack (2 Poison Daggers, 30 Poison Arrows)
		weight = 51.00,
		questName = "poisondaggers",
	},
	-- Shaman treasure quest
	[6069] = {
		useKV = true,
		itemId = 4024,
		itemPos = { x = 33127, y = 31885, z = 9 },
		container = 2853,
		reward = { { 3147, 3 } }, -- Bag with 3 blank runes
		weight = 15.00,
		questName = "shamantreasure",
	},
	-- Strong potions quest
	-- Green bag with 5 strong mana potions
	[6070] = {
		itemId = 2469,
		itemPos = { x = 33163, y = 31603, z = 15 },
		container = 2857,
		reward = { { 237, 5 } },
		weight = 23.00,
		storage = Storage.Quest.U8_1.StrongPotions.Reward,
	},
	-- Vampire shield quest
	[6071] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 33188, y = 31682, z = 14 },
		container = 2853,
		reward = { { 3058, 1 }, { 3027, 1 }, { 3078, 1 } }, -- Bag (Strange Symbol, Black Pearl and Mysterious Fetish)
		weight = 16.00,
		questName = "vampireshield1",
	},
	-- [6072] empty
	-- Dragon tower quest
	-- Backpack 1
	[6073] = {
		itemId = 2469,
		itemPos = { x = 33072, y = 32169, z = 2 },
		container = 2854,
		reward = { { 268, 1 }, { 266, 1 }, { 3449, 30 }, { 3448, 60 } },
		weight = 99.00,
		storage = Storage.Quest.U7_1.DragonTower.Rewards.Backpack1,
	},
	-- Backpack 2
	[6074] = {
		itemId = 2469,
		itemPos = { x = 33078, y = 32169, z = 2 },
		container = 2854,
		reward = { { 3350, 1 }, { 3029, 2 } },
		weight = 50.00,
		storage = Storage.Quest.U7_1.DragonTower.Rewards.Backpack2,
	},
	-- Behemoth quest
	-- Bag
	[6075] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 33294, y = 31658, z = 13 },
		container = 2853,
		reward = { { 3028, 3 }, { 3029, 4 }, { 3007, 1 }, { 3052, 1 }, { 3055, 1 } },
		weight = 17.00,
		questName = "behemothquest1",
	},
	-- Parchment room quest
	-- Bag
	[6076] = {
		itemId = 2474,
		itemPos = { x = 33063, y = 31624, z = 15 },
		container = 2853,
		keyAction = Storage.Quest.Key.ID6010,
		reward = { { 2972, 1 }, { 3114, 1 }, { 3034, 2 }, { 3049, 1 }, { 3115, 1 } },
		weight = 42,
		storage = Storage.Quest.U7_2.ParchmentRoom.Bag,
	},
	-- Giant smithhammer quest
	-- Talon
	[6077] = {
		itemId = 2472,
		itemPos = { x = 32774, y = 32253, z = 8 },
		reward = { { 3034, 1 } },
		storage = Storage.Quest.U7_6.ExplorerSociety.GiantSmithHammer.Talon,
	},
	-- Giant smithhammer
	[6078] = {
		itemId = 2472,
		itemPos = { x = 32776, y = 32253, z = 8 },
		reward = { { 12510, 1 } },
		storage = Storage.Quest.U7_6.ExplorerSociety.GiantSmithHammer.Hammer,
	},
	-- 100 gold coin
	[6079] = {
		itemId = 2472,
		itemPos = { x = 32778, y = 32253, z = 8 },
		reward = { { 3031, 100 } },
		storage = Storage.Quest.U7_6.ExplorerSociety.GiantSmithHammer.GoldCoin,
	},
	-- Mad Mage room quest
	[6080] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32578, y = 32195, z = 14 },
		reward = { { 3014, 1 } }, -- Star amulet
		questName = "madmageroom1",
	},
	[6081] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32575, y = 32195, z = 14 },
		reward = { { 3210, 1 } }, -- Hat of the mad
		questName = "madmageroom2",
	},
	[6082] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32572, y = 32195, z = 14 },
		reward = { { 3081, 5 } }, -- Stone skin amulet
		questName = "madmageroom3",
	},
	-- Skull of ratha quest
	-- Bag (white pearl, skull)
	[6083] = {
		itemId = 2469,
		itemPos = { x = 32845, y = 31917, z = 6 },
		container = 2853,
		weight = 31.00,
		reward = { { 3026, 1 }, { 3207, 1 } },
		storage = Storage.Quest.U7_6.ExplorerSociety.SkullOfRatha.Bag1,
	},
	-- Bag (wolf tooth chain/dwarven ring)
	[6084] = {
		itemId = 2469,
		itemPos = { x = 32847, y = 31917, z = 6 },
		container = 2853,
		weight = 13.00,
		reward = { { 3012, 1 }, { 3097, 1 } },
		storage = Storage.Quest.U7_6.ExplorerSociety.SkullOfRatha.Bag2,
	},
	-- The annihilator quest
	-- Demon armor
	[6085] = {
		itemId = 2472,
		itemPos = { x = 33227, y = 31656, z = 13 },
		reward = { { 3388, 1 } },
		storage = Storage.Quest.U7_24.TheAnnihilator.Reward,
	},
	-- Magic sword
	[6086] = {
		itemId = 2472,
		itemPos = { x = 33229, y = 31656, z = 13 },
		reward = { { 3288, 1 } },
		storage = Storage.Quest.U7_24.TheAnnihilator.Reward,
	},
	-- Stonecutter axe
	[6087] = {
		itemId = 2472,
		itemPos = { x = 33231, y = 31656, z = 13 },
		reward = { { 3319, 1 } },
		storage = Storage.Quest.U7_24.TheAnnihilator.Reward,
	},
	-- Present (annihilation bear)
	[6088] = {
		itemId = 2472,
		itemPos = { x = 33233, y = 31656, z = 13 },
		container = 2856,
		weight = 50.00,
		reward = { { 3213, 1 } },
		storage = Storage.Quest.U7_24.TheAnnihilator.Reward,
	},
	-- The paradox tower quest
	-- Phoenix egg
	[6089] = {
		itemId = 2472,
		itemPos = { x = 32477, y = 31900, z = 1 },
		reward = { { 3215, 1 } },
		storage = Storage.Quest.U7_24.TheParadoxTower.Reward.Egg,
	},
	-- 10.000 gold coins
	[6090] = {
		itemId = 2472,
		itemPos = { x = 32478, y = 31900, z = 1 },
		reward = { { 3035, 100 } },
		storage = Storage.Quest.U7_24.TheParadoxTower.Reward.Gold,
	},
	-- Talon
	[6091] = {
		itemId = 2472,
		itemPos = { x = 32479, y = 31900, z = 1 },
		reward = { { 3034, 32 } },
		storage = Storage.Quest.U7_24.TheParadoxTower.Reward.Talon,
	},
	-- Wand of energy cosmic
	[6092] = {
		itemId = 2472,
		itemPos = { x = 32480, y = 31900, z = 1 },
		reward = { { 3073, 1 } },
		storage = Storage.Quest.U7_24.TheParadoxTower.Reward.Wand,
	},
	[6093] = {
		itemId = 2474,
		reward = { { 2969, 1 } },
		keyAction = Storage.Quest.Key.ID3002,
		storage = keyAction,
		itemPos = { { x = 32802, y = 31576, z = 7 } },
	},
	-- Hidden Threats Quest
	[6094] = {
		itemId = 2469,
		itemPos = { x = 33078, y = 31980, z = 13 },
		reward = { { 27270, 1 } },
		weight = 5.09,
		storage = Storage.Quest.U11_50.HiddenThreats.Rewards.metalFile,
	},
	[6095] = {
		itemId = 2469,
		itemPos = { x = 33080, y = 32014, z = 13 },
		reward = { { 27262, 1 } },
		weight = 2.50,
		storage = Storage.Quest.U11_50.HiddenThreats.Rewards.keyFragment01,
	},
	[6096] = {
		itemId = 2469,
		itemPos = { x = 33031, y = 32050, z = 13 },
		reward = { { 27261, 1 } },
		weight = 2.50,
		storage = Storage.Quest.U11_50.HiddenThreats.Rewards.keyFragment02,
	},
	-- The New Frontier Quest
	[6097] = {
		itemId = 2472,
		itemPos = { x = 33057, y = 31029, z = 7 },
		container = 2854,
		weight = 25.00,
		reward = { { 7439, 1 }, { 7440, 1 }, { 7443, 1 } },
		storage = Storage.Quest.U8_54.TheNewFrontier.Reward.Potions,
	},
	[6098] = {
		itemId = 2472,
		itemPos = { x = 33055, y = 31029, z = 7 },
		reward = { { 9058, 2 } },
		weight = 36.00,
		storage = Storage.Quest.U8_54.TheNewFrontier.Reward.GoldIngot,
	},
	[6099] = {
		itemId = 2472,
		itemPos = { x = 33053, y = 31029, z = 7 },
		reward = { { 2995, 1 } },
		weight = 7.50,
		storage = Storage.Quest.U8_54.TheNewFrontier.Reward.PigBank,
	},
	-- Threatened Dreams Quest
	[6100] = {
		itemId = 12764, -- Poacher Book
		itemPos = { x = 32787, y = 31975, z = 11 },
		reward = { { 25235, 1 } },
		weight = 13.00,
		storage = Storage.Quest.U11_40.ThreatenedDreams.Mission01.PoacherChest,
	},
	[6101] = { -- Dark Moon Mirror
		itemId = 25762,
		itemPos = { x = 33594, y = 32214, z = 9 },
		reward = { { 25729, 1 } },
		weight = 2.00,
		storage = Storage.Quest.U11_40.ThreatenedDreams.Mission02.DarkMoonMirror,
	},
	[6102] = { -- Ape city
		itemId = 2469,
		itemPos = { x = 32782, y = 32910, z = 8 },
		reward = { { 4827, 1 } },
		weight = 0.20,
		storage = Storage.Quest.U7_6.WhisperMoss,
	},
	[6103] = { -- Ape city
		itemId = 2473,
		itemPos = { x = 32935, y = 32886, z = 7 },
		reward = { { 4831, 1 } },
		weight = 2.00,
		storage = Storage.Quest.U7_6.OldParchment,
	},
	[6104] = {
		itemId = 2472,
		itemPos = { x = 33154, y = 31297, z = 3 },
		reward = { { 10217, 1 } },
		weight = 15.00,
		storage = Storage.Quest.U8_54.TomesOfKnowledge.TopTower,
	},
	-- The Secret Library Quest
	[6105] = {
		itemId = 23741,
		itemPos = { x = 33352, y = 31318, z = 7 },
		randomReward = { { 9081, 1 }, { 28821, 1 }, { 28823, 1 }, { 9058, 1 }, { 6299, 1 }, { 3052, 1 }, { 3035, 10 } },
		reward = { { nil, nil } },
		storage = Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.ChestsTimer.Coast,
		time = 24, -- hour
	},
	[6106] = {
		itemId = 23740,
		itemPos = { x = 33384, y = 31285, z = 7 },
		randomReward = { { 9081, 1 }, { 28821, 1 }, { 28823, 1 }, { 9058, 1 }, { 6299, 1 }, { 3052, 1 }, { 3035, 10 } },
		reward = { { nil, nil } },
		storage = Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.ChestsTimer.Island,
		time = 24, -- hour
	},
	[6107] = {
		itemId = 23741,
		itemPos = { x = 33366, y = 31323, z = 5 },
		randomReward = { { 9081, 1 }, { 28821, 1 }, { 28823, 1 }, { 9058, 1 }, { 6299, 1 }, { 3052, 1 }, { 3035, 10 } },
		reward = { { nil, nil } },
		storage = Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.ChestsTimer.ThroneHall,
		time = 24, -- hour
	},
	[6108] = {
		itemId = 23741,
		itemPos = { x = 33374, y = 31340, z = 4 },
		randomReward = { { 9081, 1 }, { 28821, 1 }, { 28823, 1 }, { 9058, 1 }, { 6299, 1 }, { 3052, 1 }, { 3035, 10 } },
		reward = { { nil, nil } },
		storage = Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.ChestsTimer.Shortcut,
		time = 24, -- hour
	},
	[6109] = {
		itemId = 23740,
		itemPos = { x = 33324, y = 31268, z = 8 },
		randomReward = { { 9081, 1 }, { 28821, 1 }, { 28823, 1 }, { 9058, 1 }, { 6299, 1 }, { 3052, 1 }, { 3035, 10 } },
		reward = { { nil, nil } },
		storage = Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.ChestsTimer.LowerBastion,
		time = 24, -- hour
	},
	[6110] = {
		itemId = 23740,
		itemPos = { x = 33308, y = 31304, z = 9 },
		randomReward = { { 9081, 1 }, { 28821, 1 }, { 28823, 1 }, { 9058, 1 }, { 6299, 1 }, { 3052, 1 }, { 3035, 10 } },
		reward = { { nil, nil } },
		storage = Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.ChestsTimer.UndergroundBastion,
		time = 24, -- hour
	},
	-- Blood Herb Quest
	[6111] = {
		useKV = true,
		itemId = 3634,
		itemPos = { x = 32769, y = 31968, z = 7 },
		reward = { { 3734, 1 } },
		questName = "bloodherb",
	},
	-- Power Bolts Quest (book)
	[6112] = {
		useKV = true,
		itemId = 4240,
		itemPos = { x = 32814, y = 32281, z = 8 },
		reward = { { 2821, 1 } },
		questName = "powerbolt2",
	},
	-- Present Quest (rookgaard)
	[6113] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32149, y = 32105, z = 11 },
		container = 2854, -- backpack
		weight = 35.00,
		reward = { { 2882, 1 }, { 2856, 1 }, { 2881, 1 }, { 2905, 1 } }, -- Jug, Present Box, Cup and Plate
		questName = "presentBox",
	},
	-- Bear Room quest
	[6114] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32146, y = 32097, z = 11 },
		container = 2853, -- bag
		weight = 21.00,
		reward = { { 3447, 12 }, { 3031, 40 } }, -- bag: 12 arrows, 40 gold coin
		questName = "bearChest1",
	},
	[6115] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32144, y = 32096, z = 11 },
		reward = { { 3354, 1 } }, -- Brass Helmet
		questName = "bearChest2",
	},
	[6116] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32141, y = 32097, z = 11 },
		reward = { { 3358, 1 } }, -- Chain Armor
		questName = "bearChest3",
	},
	-- Captain Iglues Treasure Quest
	[6117] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32039, y = 32121, z = 13 },
		reward = { { 3579, 1 } }, -- 2x Salmon
		questName = "captainIglues",
	},
	-- Combat Knife Quest
	[6117] = {
		useKV = true,
		itemId = 2473,
		itemPos = { x = 32102, y = 32235, z = 8 },
		reward = { { 3292, 1 } }, -- Combat Knife
		questName = "combatknife",
	},
	-- Goblin Temple Quest
	[6118] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 31973, y = 32209, z = 12 },
		container = 2853, -- bag
		weight = 37.00,
		reward = { { 3551, 1 }, { 1781, 5 }, { 3031, 50 } }, -- sandals, 5 small stones, 50 gold coins
		questName = "goblintemple",
	},
	[6119] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 31977, y = 32209, z = 12 },
		container = 2853, -- bag
		weight = 31.00,
		reward = { { 3466, 1 }, { 2992, 4 }, { 2874, 1 } }, -- pan, 4 snowballs, vial of milk
		questName = "goblintemple2",
	},
	-- Minotaur Hell Quest
	[6120] = {
		useKV = true,
		itemId = 2473,
		itemPos = { x = 32130, y = 32066, z = 12 },
		reward = { { 3483, 1 } }, -- fishing rod
		questName = "minohell1",
	},
	[6121] = {
		useKV = true,
		itemId = 2473,
		itemPos = { x = 32127, y = 32065, z = 12 },
		container = 2853, -- bag
		weight = 19.00,
		reward = { { 3447, 10 }, { 3448, 4 } }, -- 10 arrows, 4 poison arrow
		questName = "minohell2",
	},
	[6121] = {
		useKV = true,
		itemId = 2473,
		itemPos = { x = 32124, y = 32064, z = 12 },
		reward = { { 3283, 1 } }, -- carlin sword
		questName = "minohell3",
	},
	-- Circle Room Quest
	[6122] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 32495, y = 31992, z = 14 },
		reward = { { 3279, 1 } }, -- war hammer
		questName = "circleroom1",
	},
	[6123] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 32497, y = 31992, z = 14 },
		reward = { { 3323, 1 } }, -- dwarven axe
		questName = "circleroom2",
	},
	-- Crystal Wand Quest
	[6124] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32479, y = 31611, z = 15 },
		reward = { { 3068, 1 } }, -- crystal wand
		questName = "crystalwand1",
	},
	[6125] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32481, y = 31611, z = 15 },
		reward = { { 11609, 1 } }, -- crystal wand
		questName = "crystalwand2",
	},
	-- Demona Ring Quest
	[6126] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32504, y = 31596, z = 14 },
		reward = { { 3049, 1 } }, -- steath ring
		questName = "demonaring1",
	},
	[6127] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32515, y = 31596, z = 14 },
		reward = { { 3051, 1 } }, -- energy ring
		questName = "demonaring2",
	},
	-- Purple Tome Quest
	[6128] = {
		useKV = true,
		itemId = 2436,
		itemPos = { x = 32424, y = 31591, z = 15 },
		reward = { { 2822, 1 } }, -- map
		questName = "purpletome1",
	},
	[6129] = {
		useKV = true,
		itemId = 2436,
		itemPos = { x = 32427, y = 31591, z = 15 },
		reward = { { 2823, 1 } }, -- map
		questName = "purpletome2",
	},
	[6130] = {
		useKV = true,
		itemId = 2438,
		itemPos = { x = 32421, y = 31594, z = 15 },
		reward = { { 2848, 1 } }, -- purple tome
		questName = "purpletome3",
	},
	-- Life Ring Quest
	[6131] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 32443, y = 32238, z = 11 },
		container = 2853, -- bag
		weight = 18.00,
		reward = { { 3052, 1 }, { 3085, 200 } }, -- life ring , dragon necklace
		questName = "lifering",
	},
	-- Noble Armor Quest
	[6132] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32451, y = 32048, z = 8 },
		reward = { { 3380, 1 } }, -- noble armor
		questName = "noblearmor1",
	},
	[6133] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32455, y = 32048, z = 8 },
		reward = { { 3385, 1 } }, -- crown helmet
		questName = "noblearmor2",
	},
	-- Geomancer Quest
	[6134] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 32456, y = 32008, z = 13 },
		container = 2853, -- bag
		weight = 10.00,
		reward = { { 3029, 1 }, { 3028, 1 }, { 3097, 1 } }, -- small sapphire, small diamond, dwarven ring
		questName = "geomancer",
	},
	-- Naginata Quest
	[6135] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32346, y = 32063, z = 12 },
		reward = { { 3314, 1 } }, -- naginata
		questName = "naginata",
	},
	-- Ghoul Room Quest
	[6136] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32500, y = 32175, z = 14 },
		reward = { { 3083, 150 } }, -- garlic necklac
		questName = "ghoulroom1",
	},
	-- Mintwallin Cyclops Quest
	[6137] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32500, y = 32177, z = 14 },
		reward = { { 3093, 1 } }, -- club ring
		questName = "ghoulroom2",
	},
	[6138] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32591, y = 32097, z = 14 },
		reward = { { 3028, 1 } }, -- small diamond
		questName = "mintwallincyclops",
	},
	-- Devil helmet Quest
	[6139] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32459, y = 32144, z = 15 },
		reward = { { 3029, 4 } }, -- small sapphire
		questName = "devilhemet1",
	},
	[6140] = {
		useKV = true,
		itemId = 2480,
		itemPos = { x = 32465, y = 32148, z = 15 },
		reward = { { 3356, 1 } }, -- devil helmet
		questName = "devilhemet2",
	},
	[6141] = {
		useKV = true,
		itemId = 2480,
		itemPos = { x = 32466, y = 32148, z = 15 },
		reward = { { 3269, 1 } }, -- halberd
		questName = "devilhemet3",
	},
	-- Fanfare Quest
	[6142] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32390, y = 31769, z = 9 },
		reward = { { 2955, 1 } }, -- fanfare
		questName = "fanfare",
	},
	-- Heaven Blossom Quest
	[6143] = {
		useKV = true,
		itemId = 2523,
		itemPos = { x = 33104, y = 32154, z = 8 },
		reward = { { 5921, 1 } }, -- heaven blossom
		questName = "heavenblossom",
	},
	-- Iron Ore Quest
	[6144] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32532, y = 31873, z = 8 },
		reward = { { 5880, 1 } }, -- iron ore
		questName = "ironore",
	},
	-- Isle of the Mists Quest
	[6145] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 32852, y = 32332, z = 7 },
		reward = { { 3032, 1 } }, -- small emerald
		questName = "isleofthemists",
	},
	-- Longsword Quest
	[6146] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32649, y = 31969, z = 9 },
		reward = { { 3285, 1 } }, -- longsword
		questName = "longsword1",
	},
	[6147] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32650, y = 31969, z = 9 },
		reward = { { 3004, 1 } }, -- weeding ring
		questName = "longsword2",
	},
	[6148] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32651, y = 31969, z = 9 },
		container = 2853, -- bag
		weight = 40.00,
		reward = { { 3147, 3 }, { 2989, 1 }, { 3031, 76 }, { 3463, 1 } }, -- 3 blank rune, wooden doll, 76 gold coin, mirror
		questName = "longsword3",
	},
	-- Minotaur Leather Quest
	[6149] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 32302, y = 32415, z = 7 },
		reward = { { 5878, 1 } }, -- minotaur leather
		questName = "minotaurleatherquest",
	},
	-- Orc Shaman Quest
	[6150] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 33089, y = 32030, z = 9 },
		container = 2853, -- bag
		weight = 26.00,
		reward = { { 3046, 1 }, { 3092, 1 }, { 3147, 1 } }, -- magic light wand, axe ring, blank rune
		questName = "orcshaman",
	},
	-- Power Ring Quest
	[6151] = {
		useKV = true,
		itemId = 2473,
		itemPos = { x = 32599, y = 31776, z = 9 },
		reward = { { 3031, 1 } }, -- power ring
		questName = "powerring1",
	},
	[6152] = {
		useKV = true,
		itemId = 2473,
		itemPos = { x = 32601, y = 31776, z = 9 },
		reward = { { 3056, 200 } }, -- bronze amulet
		questName = "powerring2",
	},
	-- Scale Armor Quest
	[6153] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32357, y = 32130, z = 9 },
		container = 2853, -- bag
		weight = 113.00,
		reward = { { 3377, 1 } }, -- scale armor
		questName = "scalearmor",
	},
	-- Silver Amulet Quest
	[6154] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 32506, y = 32269, z = 9 },
		reward = { { 3054, 200 } }, -- silver amulet
		questName = "silveramulet",
	},
	-- Silver Brooch Quest
	[6155] = {
		useKV = true,
		itemId = 2476,
		itemPos = { x = 32775, y = 32006, z = 11 },
		container = 2853, -- bag
		weight = 10.00,
		reward = { { 3017, 1 }, { 3030, 2 }, { 3028, 3 } }, -- Silver Brooch, 2 Small Rubies, 3 Small Diamonds
		questName = "silverbrooch",
	},
	-- Six Rubies Quest
	[6156] = {
		useKV = true,
		itemId = 387,
		itemPos = { x = 32371, y = 32262, z = 12 },
		reward = { { 3030, 6 } }, -- 6 small rubies
		questName = "sixrubies",
	},
	-- Desert Quest
	[6157] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32668, y = 32069, z = 8 },
		reward = { { 3035, 100 } }, -- 100 platinum coins
		questName = "desert1",
	},
	[6158] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32675, y = 32069, z = 8 },
		container = 2857, -- green bag
		weight = 34.00,
		reward = { { 3084, 250 }, { 3098, 1 }, { 3046, 1 }, { 3077, 1 } }, -- protection amulet, ring of healing, magic light wand and anhk
		questName = "desert2",
	},
	-- Throwing Star Quest
	[6159] = {
		useKV = true,
		itemId = 2473,
		itemPos = { x = 32522, y = 32111, z = 15 },
		reward = { { 3287, 10 } }, -- throwing star
		questName = "throwingstar",
	},
	-- Triangle Tower Quest
	[6160] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32565, y = 32119, z = 3 },
		container = 2853, -- bag
		weight = 14.00,
		reward = { { 3083, 150 }, { 3029, 2 }, { 3097, 1 } }, -- garlick necklace, small sapphire, dwarven ring
		questName = "triangletower",
	},
	-- Dragon Corpse Quest
	[6161] = {
		useKV = true,
		itemId = 4025,
		itemPos = { x = 32179, y = 32224, z = 9 },
		container = 2853, -- bag
		weight = 102.00,
		reward = { { 3374, 1 }, { 3430, 1 } }, -- Copper Shield and Legion Helmet
		questName = "dragoncorpse",
	},
	-- Katana Quest (rookgaard)
	[6162] = {
		useKV = true,
		itemId = 4240,
		itemPos = { x = 32175, y = 32145, z = 11 },
		reward = { { 3367, 1 } }, -- katana
		questName = "katanacorpse1",
	},
	[6163] = {
		useKV = true,
		itemId = 4240,
		itemPos = { x = 32174, y = 32149, z = 11 },
		reward = { { 3300, 1 } }, -- katana
		questName = "katanacorpse2",
	},
	-- Crusader Helmet Quest
	[6164] = {
		useKV = true,
		itemId = 3990,
		itemPos = { x = 32427, y = 31943, z = 14 },
		reward = { { 3391, 1 } }, -- crusader helmet
		questName = "crusaderhelmet",
	},
	[6165] = {
		useKV = true,
		itemId = 4240,
		itemPos = { x = 32498, y = 31721, z = 15 },
		reward = { { 3433, 1 } }, -- griffing shield (Griffin Shield Quest)
		questName = "griffinshield1",
	},
	[6166] = {
		useKV = true,
		itemId = 4024,
		itemPos = { x = 32500, y = 31721, z = 15 },
		reward = { { 3313, 1 } }, -- obsidian lance (Griffin Shield Quest)
		questName = "griffinshield2",
	},
	[6167] = {
		useKV = true,
		itemId = 4024,
		itemPos = { x = 32503, y = 31724, z = 15 },
		reward = { { 3323, 1 } }, -- dwarven axe (Griffin Shield Quest)
		questName = "griffinshield3",
	},
	-- Iron Helmet Quest
	[6168] = {
		useKV = true,
		itemId = 4240,
		itemPos = { x = 32769, y = 32225, z = 7 },
		container = 2854,
		weight = 162.00,
		reward = { { 3123, 1 }, { 3155, 3 }, { 3361, 1 }, { 3353, 1 }, { 3285, 1 }, { 3506, 1 } }, -- worn leather boots, sudden death rune, leather armor, iron helmet, longsword, stamped letter
		questName = "ironhelmet",
	},
	-- Dead Archer Quest
	[6169] = {
		useKV = true,
		itemId = 4240,
		itemPos = { x = 32514, y = 32303, z = 10 },
		container = 2853,
		weight = 49.00,
		reward = { { 3350, 1 }, { 3448, 5 }, { 268, 1 }, { 266, 1 } }, -- bow, 5 poison arrows, mana potion, health potion
		questName = "deadarcher",
	},
	-- Power Bolt Quest
	[6170] = {
		useKV = true,
		itemId = 4240,
		itemPos = { x = 32816, y = 32279, z = 8 },
		container = 2853,
		weight = 24.00,
		reward = { { 3450, 5 }, { 3449, 12 } }, -- 5 power bolt, 12 burst arrow
		questName = "powerbolt1",
	},
	-- Spike Sword Quest
	[6171] = {
		useKV = true,
		itemId = 3990,
		itemPos = { x = 32568, y = 32085, z = 12 },
		reward = { { 3271, 1 } }, -- 5 power bolt, 12 burst arrow
		questName = "spikesword",
	},
	-- Iron Hammer Quest
	[6172] = {
		useKV = true,
		itemId = 2473,
		itemPos = { x = 32434, y = 31938, z = 8 },
		reward = { { 3310, 1 } }, -- iron hammer
		questName = "ironhamer",
	},
	-- Plate Armor quest
	[6173] = {
		useKV = true,
		itemId = 2474,
		itemPos = { x = 33327, y = 32182, z = 7 },
		reward = { { 3357, 1 } }, -- plate armor
		questName = "platearmor",
	},
	-- Stealth Ring Quest
	[6174] = {
		useKV = true,
		itemId = 1983,
		itemPos = { x = 33315, y = 32277, z = 11 },
		reward = { { 3084, 250 } }, -- protection amulet
		questName = "stealhring1",
	},
	[6175] = {
		useKV = true,
		itemId = 1983,
		itemPos = { x = 33315, y = 32282, z = 11 },
		reward = { { 3049, 1 } }, -- stealth ring
		questName = "stealhring2",
	},
	-- Steel Helmet Quest
	[6176] = {
		useKV = true,
		itemId = 2434,
		itemPos = { x = 32460, y = 31951, z = 5 },
		reward = { { 3031, 56 } }, -- 56 gold coin
		questName = "steelhelmet1",
	},
	[6177] = {
		useKV = true,
		itemId = 2469,
		itemPos = { x = 32464, y = 31957, z = 5 },
		reward = { { 3031, 47 } }, -- 47 gold coin
		questName = "steelhelmet2",
	},
	[6178] = {
		useKV = true,
		itemId = 2473,
		itemPos = { x = 32462, y = 31947, z = 4 },
		reward = { { 3351, 1 } }, -- steel helmet
		questName = "steelhelmet3",
	},
	[6179] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32467, y = 31962, z = 4 },
		reward = { { 2815, 1 } }, -- scroll
		questName = "steelhelmet4",
	},
	-- Battle Axe Quest
	[6180] = {
		useKV = true,
		itemId = 4285,
		itemPos = { x = 32305, y = 32254, z = 9 },
		reward = { { 3266, 1 } }, -- battle axe
		questName = "battleaxe",
	},
	-- Doublet Quest
	[6181] = {
		useKV = true,
		itemId = 408,
		itemPos = { x = 32084, y = 32181, z = 8 },
		reward = { { 3379, 1 } }, -- doublet
		questName = "doublet",
	},
	-- Honey Flower Quest
	[6182] = {
		useKV = true,
		itemId = 9226,
		itemPos = { x = 32005, y = 32139, z = 3 },
		reward = { { 2984, 1 } }, -- honey
		questName = "honeyflower",
	},
	-- The Medusa Quest
	[6183] = {
		itemId = 1983,
		itemPos = { x = 33049, y = 32399, z = 10 },
		container = 2853,
		weight = 105.00,
		reward = { { 3436, 1 }, { 3567, 1 }, { 3324, 1 } },
		storage = Storage.Quest.U7_3.TheMedusaQuest,
	},
	-- Serpentine Tower Quest
	[6184] = {
		itemId = 2472,
		itemPos = { x = 33150, y = 32862, z = 7 },
		weight = 0.20,
		reward = { { 3026, 1 } },
		storage = Storage.Quest.U7_3.SerpentineTower.WhitePearl,
	},
	-- Elephant Tusk Quest
	[6185] = {
		itemId = 2472,
		itemPos = { x = 32922, y = 32755, z = 7 },
		weight = 0.20,
		reward = { { 3044, 2 } },
		storage = Storage.Quest.U7_5.ElephantTusk,
	},
	-- The Explorer Society - Books
	[6186] = {
		itemId = 2434,
		itemPos = { x = 32770, y = 32245, z = 8 },
		weight = 13,
		reward = { { 2821, 1 } },
		storage = Storage.Quest.U7_6.ExplorerSociety.Books.Cyclops,
	},
	[6187] = {
		itemId = 2523,
		itemPos = { x = 32786, y = 32254, z = 8 },
		weight = 13.00,
		reward = { { 2821, 1 } },
		storage = Storage.Quest.U7_6.ExplorerSociety.Books.Hengis,
	},
	-- Witch House Quest
	[6188] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32867, y = 31909, z = 8 },
		weight = 23.30,
		container = 2853,
		reward = { { 3027, 2 }, { 3008, 1 }, { 3031, 100 } },
		questName = "WitchHouseQuest",
	},
	-- Simon The Beggar's Favorite Staff
	[6189] = {
		useKV = true,
		itemId = 2482,
		itemPos = { x = 33167, y = 31600, z = 15 },
		weight = 38.00,
		reward = { { 6107, 1 } },
		questName = "SimonTheBeggarsFavoriteStaff",
	},
	-- Druid Outfit Quest - Wolf Tooth Chain
	[6190] = {
		itemId = 2480,
		itemPos = { x = 32939, y = 31776, z = 9 },
		weight = 3.30,
		reward = { { 5940, 1 } },
		storage = Storage.Quest.U7_8.DruidOutfits.WolfToothChain,
	},
	-- Hunter Outfits Quest - Elane Crossbow
	[6191] = {
		itemId = 2472,
		itemPos = { x = 32369, y = 32795, z = 10 },
		weight = 40.00,
		reward = { { 5947, 1 } },
		storage = Storage.Quest.U7_8.HunterOutfits.ElaneCrossbow,
	},
	-- Knight Outfits Quest - Ramsay the Reckless Helmet
	[6192] = {
		itemId = 2472,
		itemPos = { x = 32860, y = 32516, z = 11 },
		weight = 46.00,
		reward = { { 5924, 1 } },
		storage = Storage.Quest.U7_8.KnightOutfits.RamsaysHelmetChest,
	},
	-- Oriental Outfits Quest - Chest
	[6193] = {
		itemId = 2472,
		itemPos = { x = 32088, y = 32780, z = 11 },
		weight = 4.50,
		reward = { { 5945, 1 } },
		storage = Storage.Quest.U7_8.OrientalOutfits.CoralComb,
	},
	-- The Shattered Isles Quest - Dragahs Spellbook
	[6194] = {
		itemId = 4240,
		itemPos = { x = 32093, y = 32574, z = 8 },
		weight = 58.00,
		reward = { { 6120, 1 } },
		storage = Storage.Quest.U7_8.TheShatteredIsles.DragahsSpellbook,
	},
	-- Dreamer's Challenge Quest
	[6195] = {
		itemId = 4240,
		itemPos = { x = 32860, y = 32249, z = 9 },
		weight = 150.00,
		container = 2854,
		reward = { { 2816, 1 }, { 3285, 1 }, { 3352, 1 }, { 3558, 1 } },
		storage = Storage.Quest.U7_9.DreamersChallenge.BPLongSword,
	},
	[6196] = {
		itemId = 2472,
		itemPos = { x = 32850, y = 32285, z = 14 },
		weight = 13.00,
		reward = { { 2821, 1 } },
		storage = Storage.Quest.U7_9.DreamersChallenge.ChestBook,
	},
	[6197] = {
		itemId = 2469,
		itemPos = { x = 32749, y = 32341, z = 14 },
		weight = 15.30,
		container = 2853,
		reward = { { 6498, 1 }, { 2874, 1 }, { 3602, 1 } },
		storage = Storage.Quest.U7_9.DreamersChallenge.ChestsWine,
	},
	[6198] = {
		itemId = 2469,
		itemPos = { x = 32751, y = 32341, z = 14 },
		weight = 15.30,
		container = 2853,
		reward = { { 6498, 1 }, { 2874, 1 }, { 3602, 1 } },
		storage = Storage.Quest.U7_9.DreamersChallenge.ChestsWine,
	},
	[6199] = {
		itemId = 2469,
		itemPos = { x = 32753, y = 32341, z = 14 },
		weight = 15.30,
		container = 2853,
		reward = { { 6498, 1 }, { 2874, 1 }, { 3602, 1 } },
		storage = Storage.Quest.U7_9.DreamersChallenge.ChestsWine,
	},
	[6200] = {
		itemId = 2469,
		itemPos = { x = 32755, y = 32341, z = 14 },
		weight = 15.30,
		container = 2853,
		reward = { { 6498, 1 }, { 2874, 1 }, { 3602, 1 } },
		storage = Storage.Quest.U7_9.DreamersChallenge.ChestsWine,
	},
	[6201] = {
		itemId = 2469,
		itemPos = { x = 32835, y = 32223, z = 14 },
		weight = 0.30,
		reward = { { 3028, 3 } },
		storage = Storage.Quest.U7_9.DreamersChallenge.Chests3SmallDiamond,
	},
	-- The Pits of Inferno
	[6202] = {
		itemId = 2472,
		itemPos = { x = 32828, y = 32340, z = 7 },
		weight = 13.00,
		reward = { { 2836, 1 } },
		storage = Storage.Quest.U7_9.ThePitsOfInferno.ChestTible,
	},
	[6203] = {
		itemId = 5972,
		itemPos = { x = 32854, y = 32325, z = 11 },
		weight = 13.00,
		reward = { { 2816, 1 } },
		storage = Storage.Quest.U7_9.ThePitsOfInferno.CorpseBook,
	},
	[6204] = {
		itemId = 5972,
		itemPos = { x = 32832, y = 32277, z = 10 },
		weight = 40.90,
		container = 5926,
		reward = { { 6561, 1 }, { 6299, 1 }, { 3052, 1 }, { 5021, 3 }, { 3026, 5 }, { 3035, 11 }, { 5944, 2 }, { 3160, 3 }, { 3155, 2 }, { 3147, 1 }, { 238, 1 } },
		storage = Storage.Quest.U7_9.ThePitsOfInferno.CorpsePirateBP,
	},
	[6205] = {
		itemId = 2472,
		itemPos = { x = 32826, y = 32232, z = 11 },
		weight = 20.70,
		container = 3253,
		reward = { { 11605, 1 }, { 11607, 1 }, { 11609, 1 }, { 11603, 1 } },
		storage = Storage.Quest.U7_9.ThePitsOfInferno.RewardChestBP,
	},
	[6206] = {
		itemId = 2472,
		itemPos = { x = 32824, y = 32232, z = 11 },
		weight = 10.00,
		reward = { { 3035, 100 } },
		storage = Storage.Quest.U7_9.ThePitsOfInferno.RewardChestPlatinumCoins,
	},
	[6207] = {
		itemId = 2472,
		itemPos = { x = 32819, y = 32232, z = 11 },
		weight = 10.00,
		reward = { { 3249, 1 } },
		storage = Storage.Quest.U7_9.ThePitsOfInferno.RewardChestFrozenStarlight,
	},
	[6208] = {
		itemId = 2472,
		itemPos = { x = 32814, y = 32232, z = 11 },
		weight = 8.50,
		reward = { { 5791, 1 } },
		storage = Storage.Quest.U7_9.ThePitsOfInferno.RewardChestStuffed,
	},
	[6209] = {
		itemId = 2472,
		itemPos = { x = 32812, y = 32232, z = 11 },
		weight = 8.00,
		reward = { { 6529, 1 } },
		storage = Storage.Quest.U7_9.ThePitsOfInferno.RewardChestSoftBoots,
	},
	[6210] = {
		itemId = 2472,
		itemPos = { x = 32804, y = 32229, z = 11 },
		weight = 40.00,
		reward = { { 3341, 1 } },
		storage = Storage.Quest.U7_9.ThePitsOfInferno.RewardChestStaffAvengerArbalest,
	},
	[6211] = {
		itemId = 2472,
		itemPos = { x = 32806, y = 32229, z = 11 },
		weight = 64.00,
		reward = { { 6527, 1 } },
		storage = Storage.Quest.U7_9.ThePitsOfInferno.RewardChestStaffAvengerArbalest,
	},
	[6212] = {
		itemId = 2472,
		itemPos = { x = 32808, y = 32229, z = 11 },
		weight = 95.00,
		reward = { { 5803, 1 } },
		storage = Storage.Quest.U7_9.ThePitsOfInferno.RewardChestStaffAvengerArbalest,
	},
	-- The Ice Island Quest - Skeleton - Formorgar Glacier
	[6213] = {
		itemId = 4024,
		itemPos = { x = 32121, y = 31106, z = 12 },
		container = 2853,
		reward = { { 3450, 20 }, { 3349, 1 }, { 7443, 1 }, { 3031, 100 }, { 7290, 1 } },
		weight = 97.00,
		storage = Storage.Quest.U8_0.TheIceIslands.FormorgarGlacierSkeleton,
	},
	[6214] = {
		itemId = 2472,
		itemPos = { x = 32027, y = 31104, z = 11 },
		reward = { { 2820, 1 } },
		weight = 0.50,
		storage = Storage.Quest.U8_0.TheIceIslands.FormorgarGlacierChest,
	},
	-- Shards of Ancient Winters Quest
	[6215] = {
		itemId = 2523,
		itemPos = { x = 32483, y = 31110, z = 8 },
		container = 7343,
		reward = { { 7158, 3 }, { 3031, 48 }, { 7290, 1 } },
		weight = 67.80,
		storage = Storage.Quest.U8_0.ShardsofAncientWinters.Inukaya,
	},
	[6216] = {
		itemId = 2523,
		itemPos = { x = 32431, y = 31235, z = 8 },
		container = 2853,
		reward = { { 6525, 1 }, { 3031, 89 }, { 7290, 1 } },
		weight = 45.90,
		storage = Storage.Quest.U8_0.ShardsofAncientWinters.Tyrsung,
	},
	[6217] = {
		itemId = 2473,
		itemPos = { x = 32146, y = 31430, z = 8 },
		container = 2853,
		reward = { { 7443, 1 }, { 3035, 10 }, { 7290, 1 } },
		weight = 45.90,
		storage = Storage.Quest.U8_0.ShardsofAncientWinters.Okolnir,
	},
	[6218] = {
		itemId = 4024,
		itemPos = { x = 32490, y = 31192, z = 10 },
		container = 2853,
		reward = { { 7439, 1 }, { 3031, 200 }, { 6499, 3 }, { 7290, 1 } },
		weight = 52.00,
		storage = Storage.Quest.U8_0.ShardsofAncientWinters.Helheim,
	},
	[6219] = {
		itemId = 2472,
		itemPos = { x = 32154, y = 31116, z = 9 },
		container = 2853,
		reward = { { 7400, 1 }, { 3035, 2 }, { 7290, 1 } },
		weight = 32.20,
		storage = Storage.Quest.U8_0.ShardsofAncientWinters.FormorgarMines,
	},
	-- Barbarian Arena Quest - Greenhorn
	[6220] = {
		itemId = 2472,
		itemPos = { x = 32231, y = 31065, z = 7 },
		container = 2856,
		reward = { { 2995, 1 }, { 6570, 1 }, { 6574, 1 }, { 6569, 10 }, { 7377, 1 } },
		weight = 25.10,
		storage = Storage.Quest.U8_0.BarbarianArena.RewardGreenhornPresent,
	},
	[6221] = {
		itemId = 2480,
		itemPos = { x = 32231, y = 31068, z = 7 },
		container = 7342,
		reward = { { 7364, 100 }, { 7365, 100 } },
		weight = 158.00,
		storage = Storage.Quest.U8_0.BarbarianArena.RewardGreenhornBP,
	},
	[6222] = {
		itemId = 2482,
		itemPos = { x = 32235, y = 31068, z = 7 },
		reward = { { 7392, 1 } },
		weight = 54.00,
		storage = Storage.Quest.U8_0.BarbarianArena.RewardGreenhornWeapons,
	},
	[6223] = {
		itemId = 2482,
		itemPos = { x = 32235, y = 31066, z = 7 },
		reward = { { 7380, 1 } },
		weight = 45.00,
		storage = Storage.Quest.U8_0.BarbarianArena.RewardGreenhornWeapons,
	},
	[6224] = {
		itemId = 2482,
		itemPos = { x = 32235, y = 31064, z = 7 },
		reward = { { 7406, 1 } },
		weight = 59.00,
		storage = Storage.Quest.U8_0.BarbarianArena.RewardGreenhornWeapons,
	},
	-- Barbarian Arena Quest - Scrapper
	[6225] = {
		itemId = 2472,
		itemPos = { x = 32231, y = 31058, z = 7 },
		container = 2856,
		reward = { { 6569, 10 }, { 7375, 1 }, { 6574, 1 }, { 7183, 1 } },
		weight = 25.10,
		storage = Storage.Quest.U8_0.BarbarianArena.RewardScrapperPresent,
	},
	[6226] = {
		itemId = 2480,
		itemPos = { x = 32231, y = 31061, z = 7 },
		container = 7342,
		reward = { { 7365, 100 }, { 3450, 200 }, { 11605, 1 }, { 11615, 1 } },
		weight = 270.40,
		storage = Storage.Quest.U8_0.BarbarianArena.RewardScrapperBP,
	},
	[6227] = {
		itemId = 2482,
		itemPos = { x = 32235, y = 31061, z = 7 },
		reward = { { 7415, 1 } },
		weight = 78.00,
		storage = Storage.Quest.U8_0.BarbarianArena.RewardScrapperWeapons,
	},
	[6228] = {
		itemId = 2482,
		itemPos = { x = 32235, y = 31059, z = 7 },
		reward = { { 7389, 1 } },
		weight = 61.00,
		storage = Storage.Quest.U8_0.BarbarianArena.RewardScrapperWeapons,
	},
	[6229] = {
		itemId = 2482,
		itemPos = { x = 32235, y = 31057, z = 7 },
		reward = { { 7384, 1 } },
		weight = 35.00,
		storage = Storage.Quest.U8_0.BarbarianArena.RewardScrapperWeapons,
	},
	-- Barbarian Arena Quest - Warlord
	[6230] = {
		itemId = 2472,
		itemPos = { x = 32231, y = 31051, z = 7 },
		container = 2856,
		reward = { { 6569, 10 }, { 6574, 1 }, { 7372, 1 }, { 5080, 1 } },
		weight = 13.60,
		storage = Storage.Quest.U8_0.BarbarianArena.RewardWarlordPresent,
	},
	[6231] = {
		itemId = 2480,
		itemPos = { x = 32231, y = 31054, z = 7 },
		container = 7342,
		reward = { { 11603, 1 }, { 11609, 1 }, { 7443, 1 }, { 7440, 1 }, { 6528, 100 } },
		weight = 115.30,
		storage = Storage.Quest.U8_0.BarbarianArena.RewardWarlordBP,
	},
	[6232] = {
		itemId = 2482,
		itemPos = { x = 32235, y = 31054, z = 7 },
		reward = { { 7429, 1 } },
		weight = 39.00,
		storage = Storage.Quest.U8_0.BarbarianArena.RewardWarlordWeapons,
	},
	[6233] = {
		itemId = 2482,
		itemPos = { x = 32235, y = 31052, z = 7 },
		reward = { { 7434, 1 } },
		weight = 92.00,
		storage = Storage.Quest.U8_0.BarbarianArena.RewardWarlordWeapons,
	},
	[6234] = {
		itemId = 2482,
		itemPos = { x = 32235, y = 31050, z = 7 },
		reward = { { 7390, 1 } },
		weight = 50.00,
		storage = Storage.Quest.U8_0.BarbarianArena.RewardWarlordWeapons,
	},
	-- Fishing Box Quest
	[6235] = {
		itemId = 2473,
		itemPos = { x = 32015, y = 31409, z = 7 },
		container = 2853,
		reward = { { 3035, 5 }, { 7158, 3 }, { 7159, 3 } },
		weight = 68.50,
		storage = Storage.Quest.U8_0.FishingBox,
	},
	-- Koshei The Deathless Quest
	[6236] = {
		itemId = 408,
		itemPos = { x = 33194, y = 32458, z = 7 },
		reward = { { 7530, 1 } },
		weight = 1.00,
		storage = Storage.Quest.U8_1.KosheiTheDeathless.KosheiAmuletPart1,
	},
	[6237] = {
		itemId = 1983,
		itemPos = { x = 33305, y = 32277, z = 10 },
		reward = { { 7528, 1 } },
		weight = 1.00,
		storage = Storage.Quest.U8_1.KosheiTheDeathless.KosheiAmuletPart2,
	},
	[6238] = {
		itemId = 231,
		itemPos = { x = 33212, y = 32593, z = 7 },
		reward = { { 7531, 1 } },
		weight = 1.00,
		storage = Storage.Quest.U8_1.KosheiTheDeathless.KosheiAmuletPart3,
	},
	[6239] = {
		itemId = 1983,
		itemPos = { x = 33053, y = 32468, z = 11 },
		reward = { { 7529, 1 } },
		weight = 1.00,
		storage = Storage.Quest.U8_1.KosheiTheDeathless.KosheiAmuletPart4,
	},
	[6240] = {
		itemId = 2472,
		itemPos = { x = 33261, y = 32444, z = 12 },
		reward = { { 645, 1 } },
		weight = 18.00,
		storage = Storage.Quest.U8_1.KosheiTheDeathless.KosheiTheDeathlessLegs,
	},
	[6241] = {
		itemId = 2480,
		itemPos = { x = 33261, y = 32448, z = 12 },
		reward = { { 3035, 100 } },
		weight = 5.00,
		storage = Storage.Quest.U8_1.KosheiTheDeathless.KosheiTheDeathlessPlatinum,
	},
	[6242] = {
		itemId = 2469,
		itemPos = { x = 33273, y = 32470, z = 11 },
		reward = { { 3031, 100 } },
		weight = 10.00,
		storage = Storage.Quest.U8_1.KosheiTheDeathless.KosheiTheDeathlessGold,
	},
	-- Secret Service Quest
	[6243] = {
		itemId = 2433,
		itemPos = { x = 32311, y = 32177, z = 5 },
		reward = { { 403, 1 } },
		weight = 13.00,
		storage = Storage.Quest.U8_1.SecretService.AHX17L89,
	},
	[6244] = {
		itemId = 1983,
		itemPos = { x = 32156, y = 31954, z = 13 },
		reward = { { 406, 1 } },
		weight = 0.80,
		storage = Storage.Quest.U8_1.SecretService.FamilySignetRing,
	},
	[6245] = {
		itemId = 2433,
		itemPos = { x = 33271, y = 31839, z = 3 },
		reward = { { 648, 1 } },
		weight = 58.00,
		storage = Storage.Quest.U8_1.SecretService.MagicSpellbook,
	},
	[6246] = {
		itemId = 2473,
		itemPos = { x = 32907, y = 32012, z = 6 },
		reward = { { 399, 1 } },
		weight = 1.00,
		storage = Storage.Quest.U8_1.SecretService.BuildingPlans,
	},
	[6247] = {
		itemId = 2433,
		itemPos = { x = 32598, y = 32380, z = 10 },
		reward = { { 400, 1 } },
		weight = 1.50,
		storage = Storage.Quest.U8_1.SecretService.SuspiciousDocuments,
	},
	[6248] = {
		itemId = 2473,
		itemPos = { x = 32180, y = 31930, z = 11 },
		reward = { { 401, 1 } },
		weight = 13.00,
		storage = Storage.Quest.U8_1.SecretService.Book,
	},
	[6249] = {
		itemId = 3634,
		itemPos = { x = 32876, y = 31958, z = 11 },
		reward = { { 652, 1 } },
		weight = 45.00,
		storage = Storage.Quest.U8_1.SecretService.RottenHeartOfTree,
	},
	[6250] = {
		itemId = 2469,
		itemPos = { x = 32872, y = 31958, z = 11 },
		reward = { { 5956, 1 } },
		weight = 1.20,
		storage = Storage.Quest.U8_1.SecretService.LotteryTicket,
	},
	[6251] = {
		itemId = 2472,
		itemPos = { x = 32643, y = 32733, z = 7 },
		reward = { { 5952, 1 } },
		weight = 1.20,
		storage = Storage.Quest.U8_1.SecretService.PoemScroll,
	},
	[6252] = {
		itemId = 4240,
		itemPos = { x = 32773, y = 31582, z = 11 },
		reward = { { 348, 1 } },
		weight = 1.20,
		storage = Storage.Quest.U8_1.SecretService.IntelligenceReports,
	},
	-- To Blind the Enemy Quest
	[6253] = {
		itemId = 2472,
		itemPos = { x = 32591, y = 31647, z = 3 },
		reward = { { 3425, 1 } },
		weight = 55.00,
		storage = Storage.Quest.U8_1.ToBlindTheEnemy.DwarvenShield,
	},
	[6254] = {
		itemId = 2472,
		itemPos = { x = 32590, y = 31647, z = 3 },
		reward = { { 3282, 1 } },
		weight = 54.00,
		storage = Storage.Quest.U8_1.ToBlindTheEnemy.MorningStar,
	},
	[6255] = {
		itemId = 2434,
		itemPos = { x = 32588, y = 31645, z = 3 },
		container = 2853,
		reward = { { 237, 1 }, { 3147, 1 }, { 3059, 1 } },
		weight = 31.00,
		storage = Storage.Quest.U8_1.ToBlindTheEnemy.BP1,
	},
	[6256] = {
		itemId = 2434,
		itemPos = { x = 32588, y = 31644, z = 3 },
		container = 2853,
		reward = { { 3028, 2 }, { 3031, 100 } },
		weight = 18.20,
		storage = Storage.Quest.U8_1.ToBlindTheEnemy.BP2,
	},
	-- To Outfox a Fox Quest
	[6257] = {
		itemId = 2469,
		itemPos = { x = 32467, y = 31970, z = 5 },
		reward = { { 139, 1 } },
		weight = 7.00,
		storage = Storage.Quest.U8_1.ToOutfoxAFoxQuest.MiningHelmet,
	},
	-- Waterfall Quest
	[6258] = {
		itemId = 2472,
		itemPos = { x = 32970, y = 32646, z = 8 },
		container = 5926,
		reward = { { 6096, 1 }, { 3097, 1 } },
		weight = 7.00,
		storage = Storage.Quest.U8_1.WaterfallQuest,
	},
	-- What a Foolish Quest
	[6259] = {
		itemId = 2469,
		itemPos = { x = 32563, y = 32115, z = 4 },
		reward = { { 112, 1 } },
		weight = 0.50,
		storage = Storage.Quest.U8_1.WhatAFoolishQuest.MagicalWatch,
	},
	[6269] = {
		itemId = 2472,
		itemPos = { x = 32661, y = 31855, z = 13 },
		container = 2853,
		reward = { { 3469, 1 }, { 2821, 1 } },
		weight = 22.00,
		storage = Storage.Quest.U8_1.WhatAFoolishQuest.BagBookKnife,
	},
	-- The Inquisition Quest
	[6270] = {
		itemId = 2472,
		itemPos = { x = 32649, y = 31932, z = 1 },
		reward = { { 7874, 1 } },
		weight = 13.00,
		storage = Storage.Quest.U8_2.TheInquisitionQuest.WitchesGrimoire,
	},
	-- The Thieves Guild Quest
	[6271] = {
		itemId = 2473,
		itemPos = { x = 33131, y = 32661, z = 7 },
		reward = { { 235, 1 } },
		weight = 8.00,
		storage = Storage.Quest.U8_2.TheThievesGuildQuest.RewardOasis,
	},
	[6272] = {
		itemId = 2473,
		itemPos = { x = 32367, y = 31781, z = 8 },
		reward = { { 8117, 1 } },
		weight = 13.00,
		storage = Storage.Quest.U8_2.TheThievesGuildQuest.RewardBook,
	},
	[6273] = {
		itemId = 2469,
		itemPos = { x = 32551, y = 32652, z = 10 },
		reward = { { 7369, 1 } },
		weight = 5.00,
		storage = Storage.Quest.U8_2.TheThievesGuildQuest.GoldenGoblet,
	},
	[6274] = {
		itemId = 2433,
		itemPos = { x = 32902, y = 32143, z = 4 },
		reward = { { 7935, 1 } },
		weight = 0.10,
		storage = Storage.Quest.U8_2.TheThievesGuildQuest.CompromisingLetter,
	},
	[6275] = {
		itemId = 2434,
		itemPos = { x = 32309, y = 32209, z = 8 },
		reward = { { 8021, 1 } },
		weight = 35.00,
		storage = Storage.Quest.U8_2.TheThievesGuildQuest.RewardEnd,
	},
	[6276] = {
		itemId = 2434,
		itemPos = { x = 32309, y = 32211, z = 8 },
		reward = { { 7404, 1 } },
		weight = 17.00,
		storage = Storage.Quest.U8_2.TheThievesGuildQuest.RewardEnd,
	},
	[6277] = {
		itemId = 2434,
		itemPos = { x = 32309, y = 32213, z = 8 },
		reward = { { 8073, 1 } },
		weight = 21.00,
		storage = Storage.Quest.U8_2.TheThievesGuildQuest.RewardEnd,
	},
	-- Vampire Hunter Quest
	[6278] = {
		itemId = 1986,
		itemPos = { x = 32972, y = 31461, z = 10 },
		reward = { { 8532, 1 } },
		weight = 5.00,
		storage = Storage.Quest.U8_2.VampireHunterQuest.BloodSkull,
	},
	-- The Hidden City of Beregar Quest
	[6279] = {
		itemId = 4024,
		itemPos = { x = 32601, y = 31386, z = 14 },
		reward = { { 9058, 1 } },
		weight = 18.00,
		storage = Storage.Quest.U8_4.TheHiddenCityOfBeregar.CorpseGoldIngot,
	},
	[6280] = {
		itemId = 4240,
		itemPos = { x = 32588, y = 31406, z = 14 },
		reward = { { 9057, 3 } },
		weight = 0.30,
		storage = Storage.Quest.U8_4.TheHiddenCityOfBeregar.CorpseSmallTopazes,
	},
	[6281] = {
		itemId = 4024,
		itemPos = { x = 32650, y = 31467, z = 15 },
		reward = { { 8895, 1 } },
		weight = 120.00,
		storage = Storage.Quest.U8_4.TheHiddenCityOfBeregar.CorpseRustedArmor,
	},
	[6282] = {
		itemId = 2472,
		itemPos = { x = 32754, y = 31462, z = 15 },
		reward = { { 9172, 1 } },
		weight = 1.00,
		storage = Storage.Quest.U8_4.TheHiddenCityOfBeregar.PrisonCellKey,
	},
	[6283] = {
		itemId = 1983,
		itemPos = { x = 32546, y = 31522, z = 11 },
		container = 2867,
		reward = { { 3035, 13 }, { 3003, 1 }, { 3457, 1 }, { 268, 1 }, { 239, 2 } },
		weight = 82.00,
		storage = Storage.Quest.U8_4.TheHiddenCityOfBeregar.BPTheUndeathStare,
	},
	[6284] = {
		itemId = 2472,
		itemPos = { x = 32582, y = 31405, z = 15 },
		reward = { { 9019, 1 } },
		weight = 10.00,
		storage = Storage.Quest.U8_4.TheHiddenCityOfBeregar.FirewalkerBoots,
	},
	-- Darashia Dragon Quest
	[6285] = {
		itemId = 4286,
		itemPos = { x = 33233, y = 32280, z = 12 },
		reward = { { 3052, 1 } },
		weight = 1.00,
		storage = Storage.Quest.U8_5.DarashiaDragon,
	},
	-- Lone Medusa Quest
	[6286] = {
		itemId = 3990,
		itemPos = { x = 32406, y = 32764, z = 1 },
		reward = { { 3027, 4 } },
		weight = 1.00,
		storage = Storage.Quest.U8_5.LoneMedusa,
	},
	-- The New Frontier Quest
	[6287] = {
		itemId = 2472,
		itemPos = { x = 33164, y = 31257, z = 10 },
		reward = { { 10217, 1 } },
		weight = 15.00,
		storage = Storage.Quest.U8_54.TheNewFrontier.ChestTomeOfKnowledge1,
	},
	[6288] = {
		itemId = 2472,
		itemPos = { x = 33057, y = 31019, z = 2 },
		reward = { { 10217, 1 } },
		weight = 15.00,
		storage = Storage.Quest.U8_54.TheNewFrontier.ChestTomeOfKnowledge2,
	},
	-- Children of the Revolution Quest
	[6289] = {
		itemId = 2472,
		itemPos = { x = 33247, y = 31161, z = 6 },
		reward = { { 10217, 1 } },
		weight = 15.00,
		storage = Storage.Quest.U8_54.ChildrenOfTheRevolution.ChestTomeOfKnowledge1,
	},
	[6290] = {
		itemId = 1895,
		itemPos = { x = 33327, y = 31410, z = 8 },
		reward = { { 10189, 1 } },
		weight = 2.00,
		storage = Storage.Quest.U8_54.ChildrenOfTheRevolution.FlaskOfExtraGreasyOil,
	},
	[6291] = {
		itemId = 2472,
		itemPos = { x = 33264, y = 31130, z = 7 },
		reward = { { 10217, 1 } },
		weight = 15.00,
		storage = Storage.Quest.U8_54.ChildrenOfTheRevolution.ChestTomeOfKnowledge2,
	},
	-- Tomes of Knowledge Quest
	[6292] = {
		itemId = 2472,
		itemPos = { x = 33009, y = 31251, z = 8 },
		reward = { { 10217, 1 } },
		weight = 15.00,
		storage = Storage.Quest.U8_54.TomesOfKnowledge.ChestTomeOfKnowledge1,
	},
	[6293] = {
		itemId = 2472,
		itemPos = { x = 32978, y = 31427, z = 2 },
		reward = { { 10217, 1 } },
		weight = 15.00,
		storage = Storage.Quest.U8_54.TomesOfKnowledge.ChestTomeOfKnowledge2,
	},
	[6294] = {
		itemId = 2472,
		itemPos = { x = 33306, y = 31125, z = 9 },
		reward = { { 10217, 1 } },
		weight = 15.00,
		storage = Storage.Quest.U8_54.TomesOfKnowledge.ChestTomeOfKnowledge3,
	},
	[6295] = {
		itemId = 2480,
		itemPos = { x = 33157, y = 31229, z = 15 },
		reward = { { 10217, 1 } },
		weight = 15.00,
		storage = Storage.Quest.U8_54.TomesOfKnowledge.ChestTomeOfKnowledge4,
	},
	-- An Interest In Botany Quest
	[6296] = {
		itemId = 2469,
		itemPos = { x = 33004, y = 31530, z = 10 },
		reward = { { 11699, 1 } },
		weight = 15.00,
		storage = Storage.Quest.U8_6.AnInterestInBotany.BotanyAlmanach,
	},
	-- Wrath of the Emperor Quest
	[6297] = {
		itemId = 2469,
		itemPos = { x = 33073, y = 31169, z = 8 },
		reward = { { 3035, 100 } },
		weight = 10.00,
		storage = Storage.Quest.U8_6.WrathOfTheEmperor.Chest100PlatinumCoins,
	},
	[6298] = {
		itemId = 2472,
		itemPos = { x = 33074, y = 31169, z = 8 },
		container = 2853,
		reward = { { 11695, 1 }, { 10326, 1 }, { 5801, 1 }, { 3041, 1 }, { 3027, 10 }, { 9058, 5 }, { 5882, 10 }, { 3043, 10 } },
		weight = 151.00,
		storage = Storage.Quest.U8_6.WrathOfTheEmperor.ChestBag,
	},
	[6299] = {
		itemId = 2473,
		itemPos = { x = 33076, y = 31170, z = 8 },
		reward = { { 11687, 1 } },
		weight = 45.00,
		storage = Storage.Quest.U8_6.WrathOfTheEmperor.ChestItems,
	},
	[6300] = {
		itemId = 2473,
		itemPos = { x = 33078, y = 31170, z = 8 },
		reward = { { 11686, 1 } },
		weight = 130.00,
		storage = Storage.Quest.U8_6.WrathOfTheEmperor.ChestItems,
	},
	[6301] = {
		itemId = 2473,
		itemPos = { x = 33080, y = 31170, z = 8 },
		reward = { { 11689, 1 } },
		weight = 43.00,
		storage = Storage.Quest.U8_6.WrathOfTheEmperor.ChestItems,
	},
	-- Rookgaard
	-- 05 Brown Mushrooms
	[6302] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32138, y = 32171, z = 3 },
		reward = { { 3725, 5 } },
		questName = "Rookgaard05BrownMushrooms",
	},
	-- Dark Trails Quest
	[6303] = {
		itemId = 2469,
		itemPos = { x = 33457, y = 32073, z = 8 },
		reward = { { 11450, 1 } },
		weight = 1.00,
		storage = Storage.Quest.U10_50.DarkTrails.RewardSmallNotebook,
	},
	[6304] = {
		itemId = 2478,
		itemPos = { x = 33468, y = 32083, z = 8 },
		container = 2853,
		reward = { { 21203, 5 }, { 21333, 1 } },
		weight = 189.00,
		storage = Storage.Quest.U10_50.DarkTrails.Reward05GlothAndBelongings,
	},
	[6305] = {
		itemId = 2478,
		itemPos = { x = 33487, y = 32085, z = 9 },
		container = 2853,
		reward = { { 21203, 10 }, { 21334, 1 } },
		weight = 338.00,
		storage = Storage.Quest.U10_50.DarkTrails.Reward10GlothAndBelongings,
	},
	-- Nightmare Teddy Quest
	[6306] = {
		useKV = true,
		itemId = 2433,
		itemPos = { x = 33444, y = 32605, z = 11 },
		reward = { { 21982, 1 } },
		weight = 6.00,
		questName = "NightmareTeddyQuest",
	},
	-- Ferumbras' Ascension Quest
	[6307] = {
		itemId = 1983,
		itemPos = { x = 33384, y = 32323, z = 12 },
		reward = { { 22160, 1 } },
		weight = 1.00,
		storage = Storage.Quest.U10_90.FerumbrasAscension.TheRiteOfEternalNight,
	},
	[6308] = {
		itemId = 1986,
		itemPos = { x = 33393, y = 32373, z = 11 },
		reward = { { 22158, 1 } },
		weight = 15.00,
		storage = Storage.Quest.U10_90.FerumbrasAscension.StoneCoffinsBones,
	},
	[6309] = {
		itemId = 21818,
		itemPos = { x = 33408, y = 32396, z = 11 },
		reward = { { 9685, 1 } },
		weight = 1.00,
		storage = Storage.Quest.U10_90.FerumbrasAscension.VampireTeeth,
	},
	-- Forgotten Knowledge Quest
	[6310] = {
		useKV = true,
		itemId = 23736,
		itemPos = { x = 32825, y = 31664, z = 9 },
		reward = { { 23734, 1 } },
		weight = 6.00,
		questName = "GhostsilverLanternQuest",
	},
	[6311] = {
		useKV = true,
		itemId = 21858,
		itemPos = { x = 32883, y = 31686, z = 10 },
		reward = { { 23732, 1 } },
		weight = 4.00,
		questName = "PaintingOfAGirlQuest",
	},
	[6312] = {
		useKV = true,
		itemId = 9253,
		itemPos = { x = 33026, y = 31662, z = 14 },
		reward = { { 24964, 1 } },
		weight = 3.00,
		questName = "ImbuingCrystalQuest",
	},
	-- Cults of Tibia Quest
	[6313] = {
		useKV = true,
		itemId = 2472,
		itemPos = { x = 32739, y = 31426, z = 8 },
		reward = { { 10420, 5 } },
		weight = 8.00,
		questName = "PetrifiedScreamQuest",
	},
	-- The Secret Library Quest
	[6314] = {
		itemId = 2472,
		itemPos = { x = 33231, y = 32017, z = 8 },
		reward = { { 27874, 1 } },
		weight = 1.00,
		storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.SampleBlood,
	},
	[6315] = {
		itemId = 2472,
		itemPos = { x = 33212, y = 32081, z = 9 },
		reward = { { 27847, 1 } },
		weight = 2.00,
		storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.BonyRod,
	},
	[6316] = {
		itemId = 2472,
		itemPos = { x = 33342, y = 32120, z = 10 },
		reward = { { 25746, 1 } },
		weight = 2.00,
		storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.BrokenCompass,
	},
	[6317] = {
		itemId = 28517,
		itemPos = { x = 32826, y = 32772, z = 10 },
		reward = { { 28518, 1 } },
		weight = 1.00,
		storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.SkeletonNotes,
	},
	[6318] = {
		itemId = 28522,
		itemPos = { x = 32828, y = 32772, z = 10 },
		reward = { { 28490, 1 } },
		weight = 1.00,
		storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.StrandHair,
	},
	[6319] = {
		itemId = 1992,
		itemPos = { x = 32874, y = 32760, z = 10 },
		reward = { { 28476, 1 } },
		weight = 1.00,
		storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.LotusKey,
	},
	[6320] = {
		itemId = 27490,
		itemPos = { x = 32836, y = 32820, z = 10 },
		reward = { { 28477, 1 } },
		weight = 1.00,
		storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.EyeKey,
	},
	[6321] = {
		itemId = 6560,
		itemPos = { x = 32872, y = 32817, z = 10 },
		reward = { { 28515, 1 } },
		weight = 1.00,
		storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.ScribbledNotes,
	},
	[6322] = {
		itemId = 4077,
		itemPos = { x = 32877, y = 32795, z = 11 },
		reward = { { 28491, 1 } },
		weight = 9.00,
		storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.EbonyPiece,
	},
	[6323] = {
		itemId = 23741,
		itemPos = { x = 32833, y = 32759, z = 11 },
		reward = { { 28710, 1 } },
		weight = 1.00,
		storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.PeacockBallad,
	},
	[6324] = {
		itemId = 9794,
		itemPos = { x = 32890, y = 32768, z = 9 },
		reward = { { 28494, 1 } },
		weight = 3.00,
		storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.SilverChimes,
	},
	[6325] = {
		itemId = 23741,
		itemPos = { x = 32852, y = 32744, z = 11 },
		reward = { { 28489, 1 } },
		weight = 20.00,
		storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.BlackSkull,
	},
	[6326] = {
		itemId = 28828,
		itemPos = { x = 32013, y = 32447, z = 8 },
		reward = { { 28650, 1 } },
		weight = 2.00,
		storage = Storage.Quest.U11_80.TheSecretLibrary.SmallIslands.Parchment,
	},
	[6327] = {
		itemId = 2523,
		itemPos = { x = 32096, y = 31757, z = 8 },
		reward = { { 675, 2 } },
		weight = 1.00,
		storage = Storage.Quest.U11_80.TheSecretLibrary.SmallIslands.Sapphire,
	},
	[6328] = {
		itemId = 4242,
		itemPos = { x = 32460, y = 32934, z = 8 },
		reward = { { 3483, 1 } },
		weight = 9.00,
		storage = Storage.Quest.U11_80.TheSecretLibrary.SmallIslands.Fishing,
	},
	[6329] = {
		itemId = 6560,
		itemPos = { x = 32460, y = 32940, z = 7 },
		reward = { { 3457, 1 } },
		weight = 35.00,
		storage = Storage.Quest.U11_80.TheSecretLibrary.SmallIslands.Shovel,
	},
	[6330] = {
		itemId = 5951,
		itemPos = { x = 32025, y = 32469, z = 7 },
		reward = { { 28707, 1 } },
		weight = 6.00,
		storage = Storage.Quest.U11_80.TheSecretLibrary.SmallIslands.Hawser,
	},
	-- Reward of others scrips files (varied rewards)
	-- The First dragon Quest
	-- Treasure chests (data\scripts\actions\quests\first_dragon\treasure_chests.lua)
	[14001] = {
		itemId = 24877,
		itemPos = { x = 32809, y = 32546, z = 6 },
	},
	[14002] = {
		itemId = 24877,
		itemPos = { x = 32765, y = 31019, z = 9 },
	},
	[14003] = {
		itemId = 24877,
		itemPos = { x = 32046, y = 32894, z = 10 },
	},
	[14004] = {
		itemId = 24875,
		itemPos = { x = 32808, y = 31580, z = 3 },
	},
	[14005] = {
		itemId = 24875,
		itemPos = { x = 33260, y = 32228, z = 10 },
	},
	[14006] = {
		itemId = 24875,
		itemPos = { x = 33016, y = 32614, z = 6 },
	},
	[14007] = {
		itemId = 24875,
		itemPos = { x = 33054, y = 32393, z = 10 },
	},
	[14008] = {
		itemId = 24875,
		itemPos = { x = 32208, y = 31849, z = 10 },
	},
	[14009] = {
		itemId = 24875,
		itemPos = { x = 32024, y = 32602, z = 10 },
	},
	[14010] = {
		itemId = 24875,
		itemPos = { x = 33224, y = 31647, z = 7 },
	},
	[14011] = {
		itemId = 24875,
		itemPos = { x = 32701, y = 31458, z = 5 },
	},
	[14012] = {
		itemId = 24875,
		itemPos = { x = 32647, y = 32091, z = 8 },
	},
	[14013] = {
		itemId = 24877,
		itemPos = { x = 32577, y = 31896, z = 7 },
	},
	[14014] = {
		itemId = 24875,
		itemPos = { x = 33676, y = 31753, z = 6 },
	},
	[14015] = {
		itemId = 24877,
		itemPos = { x = 32242, y = 31390, z = 5 },
	},
	[14016] = {
		itemId = 24875,
		itemPos = { x = 33613, y = 31811, z = 9 },
	},
	[14017] = {
		itemId = 24875,
		itemPos = { x = 32873, y = 32900, z = 9 },
	},
	[14018] = {
		itemId = 24875,
		itemPos = { x = 32171, y = 32974, z = 7 },
	},
	[14019] = {
		itemId = 24877,
		itemPos = { x = 32960, y = 31461, z = 3 },
	},
	[14020] = {
		itemId = 24875,
		itemPos = { x = 33340, y = 31411, z = 7 },
	},
	-- Final reward (data\scripts\actions\quests\first_dragon\rewards.lua)
	[14021] = {
		itemId = 2478,
		itemPos = { x = 33616, y = 31015, z = 13 },
	},
	[14022] = {
		itemId = 24863,
		itemPos = { x = 33617, y = 31015, z = 13 },
	},
	[14023] = {
		itemId = 2478,
		itemPos = { x = 33618, y = 31015, z = 13 },
	},
	-- The shattered isles
	[14024] = {
		itemId = 5677,
		itemPos = { x = 31938, y = 32837, z = 7 },
	},
	-- Dawnport vocation rewards
	-- Path: data\scripts\actions\quests\dawnport\vocation_reward.lua
	-- Sorcerer
	[14025] = {
		itemId = 2472,
		itemPos = { x = 32054, y = 31882, z = 6 },
	},
	-- Druid
	[14026] = {
		itemId = 2472,
		itemPos = { x = 32073, y = 31882, z = 6 },
	},
	-- Paladin
	[14027] = {
		itemId = 2472,
		itemPos = { x = 32059, y = 31882, z = 6 },
	},
	-- Knight
	[14028] = {
		itemId = 2472,
		itemPos = { x = 32068, y = 31882, z = 6 },
	},
	-- Explorer Society Missions
	-- Path: data\scripts\actions\quests\explorer_society\findings.lua
	-- Uzgod Family Brooch (Dwacatra)
	[14029] = {
		itemId = 2473,
		itemPos = { x = 32598, y = 31934, z = 15 },
	},
	-- The Bonelord Secret Chest (Dark Pyramid)
	[14030] = {
		itemId = 2469,
		itemPos = { x = 33308, y = 32279, z = 12 },
	},
	-- The Orc Powder (Orc Fortress)
	[14031] = {
		itemId = 2473,
		itemPos = { x = 32967, y = 31719, z = 2 },
	},
	-- The Elven Poetry (Hell Gate)
	[14032] = {
		itemId = 2472,
		itemPos = { x = 32704, y = 31605, z = 14 },
	},
	-- The Memory Stone (Edron)
	[14033] = {
		itemId = 2469,
		itemPos = { x = 33152, y = 31640, z = 11 },
	},
	-- The Spectral Dress (Isle of the Kings)
	[14034] = {
		itemId = 2469,
		itemPos = { x = 32259, y = 31949, z = 14 },
	},
	-- The Undersea Kingdom (Calassa)
	[14035] = {
		itemId = 2473,
		itemPos = { x = 31937, y = 32771, z = 13 },
	},
	-- Others uniques
	-- Threatened Dreams Quest
	[14036] = {
		itemId = 12764,
		itemPos = { x = 32787, y = 31975, z = 11 },
	},
	-- In Service of Yalahar Quest
	[14037] = {
		itemId = 2469,
		itemPos = { x = 32796, y = 31226, z = 7 },
	},
	[14038] = {
		itemId = 2469,
		itemPos = { x = 32795, y = 31185, z = 7 },
	},
	[14039] = {
		itemId = 2469,
		itemPos = { x = 32701, y = 31082, z = 8 },
	},
	-- Royal Rescue Quest
	[14040] = {
		itemId = 2435,
		itemPos = { x = 32621, y = 31404, z = 10 },
	},
	[14041] = {
		itemId = 11810,
		itemPos = { x = 33195, y = 31765, z = 1 },
	},
	[14042] = {
		itemId = 2473,
		itemPos = { x = 32099, y = 32198, z = 9 },
	},
	-- The Outlaw Camp Quest (Bright Sword Quest)
	[14091] = {
		itemId = 2472,
		itemPos = { x = 32620, y = 32198, z = 10 },
	},
}
