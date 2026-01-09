local mType = Game.createMonsterType("Ghazbaran")
local monster = {}

monster.description = "Ghazbaran"
monster.experience = 15000
monster.outfit = {
	lookType = 12,
	lookHead = 0,
	lookBody = 85,
	lookLegs = 78,
	lookFeet = 94,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 312,
	bossRace = RARITY_NEMESIS,
}

monster.health = 77000
monster.maxHealth = 77000
monster.race = "undead"
monster.corpse = 6068
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 20,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 3500,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 4,
	summons = {
		{ name = "Deathslicer", chance = 20, interval = 4000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "COME AND GIVE ME SOME AMUSEMENT", yell = true },
	{ text = "IS THAT THE BEST YOU HAVE TO OFFER, TIBIANS?", yell = true },
	{ text = "I AM GHAZBARAN OF THE TRIANGLE... AND I AM HERE TO CHALLENGE YOU ALL.", yell = true },
	{ text = "FLAWLESS VICTORY!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 43243, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 86746, maxCount = 73 }, -- Platinum Coin
	{ id = 3043, chance = 1000, maxCount = 2 }, -- Crystal Coin
	{ id = 3033, chance = 28569, maxCount = 15 }, -- Small Amethyst
	{ id = 3032, chance = 20480, maxCount = 6 }, -- Small Emerald
	{ id = 3028, chance = 19733, maxCount = 5 }, -- Small Diamond
	{ id = 3029, chance = 22619, maxCount = 9 }, -- Small Sapphire
	{ id = 3034, chance = 14455, maxCount = 4 }, -- Talon
	{ id = 3026, chance = 19278, maxCount = 15 }, -- White Pearl
	{ id = 3027, chance = 17857, maxCount = 15 }, -- Black Pearl
	{ id = 6499, chance = 71428, maxCount = 500 }, -- Demonic Essence
	{ id = 5954, chance = 30953, maxCount = 2 }, -- Demon Horn
	{ id = 7365, chance = 9636, maxCount = 82 }, -- Onyx Arrow
	{ id = 7368, chance = 18422, maxCount = 47 }, -- Assassin Star
	{ id = 9058, chance = 9889 }, -- Gold Ingot
	{ id = 3076, chance = 8334 }, -- Crystal Ball
	{ id = 3038, chance = 16667 }, -- Green Gem
	{ id = 3041, chance = 16395 }, -- Blue Gem
	{ id = 3061, chance = 11902 }, -- Life Crystal
	{ id = 3060, chance = 18421 }, -- Orb
	{ id = 3366, chance = 8700 }, -- Magic Plate Armor
	{ id = 8056, chance = 17390 }, -- Oceanborn Leviathan Armor
	{ id = 8038, chance = 9262 }, -- Robe of the Ice Queen
	{ id = 8059, chance = 8700 }, -- Frozen Plate
	{ id = 8050, chance = 7691 }, -- Crystalline Armor
	{ id = 3414, chance = 2170 }, -- Mastermind Shield
	{ id = 3281, chance = 4350 }, -- Giant Sword
	{ id = 8076, chance = 24076 }, -- Spellscroll of Prophecies
	{ id = 8073, chance = 18681 }, -- Spellbook of Warding
	{ id = 8090, chance = 19672 }, -- Spellbook of Dark Mysteries
	{ id = 8075, chance = 18031 }, -- Spellbook of Lost Souls
	{ id = 8074, chance = 11905 }, -- Spellbook of Mind Control
	{ id = 823, chance = 11111 }, -- Glacier Kilt
	{ id = 3420, chance = 13112 }, -- Demon Shield
	{ id = 3275, chance = 1000 }, -- Double Axe
	{ id = 3324, chance = 1000 }, -- Skull Staff
	{ id = 3335, chance = 10870 }, -- Twin Axe
	{ id = 7454, chance = 8432 }, -- Glorious Axe
	{ id = 7405, chance = 16665 }, -- Havoc Blade
	{ id = 7428, chance = 9522 }, -- Bonebreaker
	{ id = 7431, chance = 1000 }, -- Demonbone
	{ id = 3360, chance = 8436 }, -- Golden Armor
	{ id = 3364, chance = 8332 }, -- Golden Legs
	{ id = 3555, chance = 9262 }, -- Golden Boots
	{ id = 2903, chance = 13185 }, -- Golden Mug
	{ id = 3116, chance = 1000 }, -- Big Bone
	{ id = 3058, chance = 15384 }, -- Strange Symbol
	{ id = 3062, chance = 18679 }, -- Mind Stone
	{ id = 3046, chance = 8332 }, -- Magic Light Wand
	{ id = 3054, chance = 1000 }, -- Silver Amulet
	{ id = 3084, chance = 1000 }, -- Protection Amulet
	{ id = 3055, chance = 1000 }, -- Platinum Amulet
	{ id = 3025, chance = 1000 }, -- Ancient Amulet
	{ id = 3006, chance = 3948 }, -- Ring of the Sky
	{ id = 3051, chance = 12089 }, -- Energy Ring
	{ id = 3048, chance = 18679 }, -- Might Ring
	{ id = 3063, chance = 16870 }, -- Gold Ring
	{ id = 6299, chance = 26190 }, -- Death Ring
	{ id = 3098, chance = 19275 }, -- Ring of Healing
	{ id = 3049, chance = 13093 }, -- Stealth Ring
	{ id = 3007, chance = 13253 }, -- Crystal Ring
	{ id = 7643, chance = 28949 }, -- Ultimate Health Potion
	{ id = 7642, chance = 18183, maxCount = 2 }, -- Great Spirit Potion
	{ id = 239, chance = 23078, maxCount = 6 }, -- Great Health Potion
	{ id = 238, chance = 25275, maxCount = 4 }, -- Great Mana Potion
	{ id = 236, chance = 1000 }, -- Strong Health Potion
	{ id = 7439, chance = 1000 }, -- Berserk Potion
	{ id = 2993, chance = 16668 }, -- Teddy Bear
	{ id = 2850, chance = 21740 }, -- Blue Tome
	{ id = 6553, chance = 15220 }, -- Ruthless Axe
	{ id = 7433, chance = 16668 }, -- Ravenwing
	{ id = 7455, chance = 7405 }, -- Mythril Axe
	{ id = 762, chance = 16216, maxCount = 46 }, -- Shiver Arrow
	{ id = 761, chance = 16216, maxCount = 74 }, -- Flash Arrow
	{ id = 7364, chance = 16666, maxCount = 85 }, -- Sniper Arrow
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -2191 },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -500, range = 7, radius = 6, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 3000, chance = 34, type = COMBAT_PHYSICALDAMAGE, minDamage = -120, maxDamage = -500, range = 7, radius = 1, shootEffect = CONST_ANI_WHIRLWINDSWORD, target = true },
	{ name = "combat", interval = 4000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -100, maxDamage = -800, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -480, range = 14, radius = 5, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -650, range = 7, radius = 13, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 4000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -600, radius = 14, effect = CONST_ME_LOSEENERGY, target = false },
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -750, range = 7, radius = 4, effect = CONST_ME_ENERGYAREA, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 55,
	--	mitigation = ???,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 300, maxDamage = 800, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 4000, chance = 80, speedChange = 440, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 1 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
