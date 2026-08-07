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
	{ id = 3035, chance = 75000, maxCount = 17 }, -- Platinum Coin
	{ id = 7643, chance = 36000, maxCount = 3 }, -- Ultimate Health Potion
	{ id = 3031, chance = 36000, maxCount = 194 }, -- Gold Coin
	{ id = 5954, chance = 28000, maxCount = 3 }, -- Demon Horn
	{ id = 238, chance = 28000, maxCount = 9 }, -- Great Mana Potion
	{ id = 6499, chance = 25000 }, -- Demonic Essence
	{ id = 3048, chance = 22000 }, -- Might Ring
	{ id = 7364, chance = 19400, maxCount = 73 }, -- Sniper Arrow
	{ id = 763, chance = 19400, maxCount = 74 }, -- Flaming Arrow
	{ id = 3033, chance = 19400, maxCount = 9 }, -- Small Amethyst
	{ id = 3051, chance = 19400 }, -- Energy Ring
	{ id = 7368, chance = 19400, maxCount = 12 }, -- Assassin Star
	{ id = 3062, chance = 16700 }, -- Mind Stone
	{ id = 3032, chance = 16700, maxCount = 9 }, -- Small Emerald
	{ id = 3058, chance = 16700 }, -- Strange Symbol
	{ id = 2903, chance = 16700 }, -- Golden Mug
	{ id = 3007, chance = 16700 }, -- Crystal Ring
	{ id = 761, chance = 16700, maxCount = 93 }, -- Flash Arrow
	{ id = 3049, chance = 13900 }, -- Stealth Ring
	{ id = 762, chance = 13900, maxCount = 87 }, -- Shiver Arrow
	{ id = 239, chance = 13900, maxCount = 7 }, -- Great Health Potion
	{ id = 3034, chance = 13900, maxCount = 13 }, -- Talon
	{ id = 3027, chance = 13900, maxCount = 9 }, -- Black Pearl
	{ id = 6299, chance = 13900 }, -- Death Ring
	{ id = 7428, chance = 11100 }, -- Bonebreaker
	{ id = 3098, chance = 11100 }, -- Ring of Healing
	{ id = 3029, chance = 11100, maxCount = 8 }, -- Small Sapphire
	{ id = 3060, chance = 11100 }, -- Orb
	{ id = 7365, chance = 11100, maxCount = 46 }, -- Onyx Arrow
	{ id = 3061, chance = 11100 }, -- Life Crystal
	{ id = 3063, chance = 11100 }, -- Gold Ring
	{ id = 3076, chance = 11100 }, -- Crystal Ball
	{ id = 8073, chance = 8300 }, -- Spellbook of Warding
	{ id = 8074, chance = 8300 }, -- Spellbook of Mind Control
	{ id = 3046, chance = 8300 }, -- Magic Light Wand
	{ id = 7454, chance = 8300 }, -- Glorious Axe
	{ id = 3038, chance = 8300 }, -- Green Gem
	{ id = 3028, chance = 5600, maxCount = 6 }, -- Small Diamond
	{ id = 3026, chance = 5600, maxCount = 7 }, -- White Pearl
	{ id = 7642, chance = 5600, maxCount = 6 }, -- Great Spirit Potion
	{ id = 3006, chance = 5600 }, -- Ring of the Sky
	{ id = 9058, chance = 5600 }, -- Gold Ingot
	{ id = 3360, chance = 5600 }, -- Golden Armor
	{ id = 8050, chance = 2800 }, -- Crystalline Armor
	{ id = 3041, chance = 2800 }, -- Blue Gem
	{ id = 823, chance = 2800 }, -- Glacier Kilt
	{ id = 3364, chance = 2800 }, -- Golden Legs
	{ id = 3366, chance = 8700 }, -- Magic Plate Armor
	{ id = 8056, chance = 17390 }, -- Oceanborn Leviathan Armor
	{ id = 8038, chance = 8700 }, -- Robe of the Ice Queen
	{ id = 8059, chance = 8700 }, -- Frozen Plate
	{ id = 3414, chance = 2170 }, -- Mastermind Shield
	{ id = 3281, chance = 4350 }, -- Giant Sword
	{ id = 8076, chance = 26090 }, -- Spellscroll of Prophecies
	{ id = 8090, chance = 21740 }, -- Spellbook of Dark Mysteries
	{ id = 8075, chance = 17390 }, -- Spellbook of Lost Souls
	{ id = 3420, chance = 13040 }, -- Demon Shield
	{ id = 3335, chance = 10870 }, -- Twin Axe
	{ id = 7405, chance = 17390 }, -- Havoc Blade
	{ id = 3555, chance = 8700 }, -- Golden Boots
	{ id = 2993, chance = 15220 }, -- Teddy Bear
	{ id = 2850, chance = 21740 }, -- Blue Tome
	{ id = 6553, chance = 15220 }, -- Ruthless Axe
	{ id = 7433, chance = 15220 }, -- Ravenwing
	{ id = 7455, chance = 6520 }, -- Mythril Axe
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
