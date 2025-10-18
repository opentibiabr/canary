local mType = Game.createMonsterType("The Scourge of Oblivion")
local monster = {}

monster.description = "The Scourge Of Oblivion"
monster.experience = 75000
monster.outfit = {
	lookType = 875,
	lookHead = 79,
	lookBody = 3,
	lookLegs = 4,
	lookFeet = 2,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"SecretLibraryBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1642,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 800000
monster.maxHealth = 800000
monster.race = "venom"
monster.corpse = 23561
monster.speed = 225
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 25,
}

monster.strategiesTarget = {
	nearest = 100,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
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
	maxSummons = 8,
	summons = {
		{ name = "Charger", chance = 15, interval = 1000, count = 3 },
		{ name = "Spark of Destruction", chance = 15, interval = 1000, count = 5 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "The Scourge Of Oblivion prepares a devestating attack!", yell = false },
	{ text = "The Scourge Of Oblivion activates its reflective shields!", yell = false },
}

monster.loot = {
	{ id = 25759, chance = 38202, maxCount = 100 }, -- Royal Star
	{ id = 3043, chance = 96441, maxCount = 13 }, -- Crystal Coin
	{ id = 3035, chance = 99626, maxCount = 15 }, -- Platinum Coin
	{ id = 23374, chance = 31716, maxCount = 20 }, -- Ultimate Spirit Potion
	{ id = 3033, chance = 21722, maxCount = 12 }, -- Small Amethyst
	{ id = 3028, chance = 20522, maxCount = 12 }, -- Small Diamond
	{ id = 3032, chance = 18097, maxCount = 12 }, -- Small Emerald
	{ id = 3030, chance = 18352, maxCount = 12 }, -- Small Ruby
	{ id = 22516, chance = 94402, maxCount = 22 }, -- Silver Token
	{ id = 7443, chance = 22388, maxCount = 10 }, -- Bullseye Potion
	{ id = 7440, chance = 20599, maxCount = 10 }, -- Mastermind Potion
	{ id = 22721, chance = 42350, maxCount = 8 }, -- Gold Token
	{ id = 23375, chance = 34831, maxCount = 6 }, -- Supreme Health Potion
	{ id = 23373, chance = 33395, maxCount = 6 }, -- Ultimate Mana Potion
	{ id = 16119, chance = 66292, maxCount = 3 }, -- Blue Crystal Shard
	{ id = 16121, chance = 63992, maxCount = 3 }, -- Green Crystal Shard
	{ id = 16120, chance = 62126, maxCount = 3 }, -- Violet Crystal Shard
	{ id = 30060, chance = 18726 }, -- Giant Emerald
	{ id = 30061, chance = 45692 }, -- Giant Sapphire
	{ id = 30059, chance = 32022 }, -- Giant Ruby
	{ id = 3039, chance = 19850 }, -- Red Gem
	{ id = 3038, chance = 9888 }, -- Green Gem
	{ id = 23526, chance = 13857 }, -- Collar of Blue Plasma
	{ id = 22726, chance = 7276 }, -- Rift Shield
	{ id = 282, chance = 13670 }, -- Giant Shimmering Pearl (Brown)
	{ id = 3341, chance = 2325 }, -- Arcane Staff
	{ id = 5892, chance = 37686 }, -- Huge Chunk of Crude Iron
	{ id = 5904, chance = 6741 }, -- Magic Sulphur
	{ id = 3006, chance = 7490 }, -- Ring of the Sky
	{ id = 8061, chance = 2425 }, -- Skullcracker Armor
	{ id = 7427, chance = 9888 }, -- Chaos Mace
	{ id = 23518, chance = 99626 }, -- Spark Sphere
	{ id = 23520, chance = 99626 }, -- Plasmatic Lightning
	{ id = 3010, chance = 99626 }, -- Emerald Bangle
	{ id = 5479, chance = 8582 }, -- Cat's Paw
	{ id = 2995, chance = 100000 }, -- Piggy Bank
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 23535, chance = 100000 }, -- Energy Bar
	{ id = 23543, chance = 10486 }, -- Collar of Green Plasma
	{ id = 9058, chance = 18726 }, -- Gold Ingot
	{ id = 3037, chance = 19288 }, -- Yellow Gem
	{ id = 23544, chance = 9737 }, -- Collar of Red Plasma
	{ id = 5809, chance = 5056 }, -- Soul Stone
	{ id = 9057, chance = 17977 }, -- Small Topaz
	{ id = 23529, chance = 7490 }, -- Ring of Blue Plasma
	{ id = 23476, 23477, chance = 6367 }, -- Void Boots
	{ id = 7439, chance = 17602 }, -- Berserk Potion
	{ id = 3324, chance = 20973 }, -- Skull Staff
	{ id = 3041, chance = 10486 }, -- Blue Gem
	{ id = 23533, chance = 7116 }, -- Ring of Red Plasma
	{ id = 22867, chance = 6741 }, -- Rift Crossbow
	{ id = 23531, chance = 6741 }, -- Ring of Green Plasma
	{ id = 22727, chance = 2673 }, -- Rift Lance
	{ id = 22866, chance = 5805 }, -- Rift Bow
	{ id = 3036, chance = 4681 }, -- Violet Gem
	{ id = 28791, chance = 1685 }, -- Library Ticket
	{ id = 8104, chance = 534 }, -- The Calamity
	{ id = 8075, chance = 5617 }, -- Spellbook of Lost Souls
	{ id = 7414, chance = 1123 }, -- Abyss Hammer
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 250, attack = 350 },
	{ name = "combat", interval = 1000, chance = 7, type = COMBAT_MANADRAIN, minDamage = -900, maxDamage = -1500, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_POFF, target = false },
	{ name = "drunk", interval = 2000, chance = 20, radius = 5, effect = CONST_ME_SMALLCLOUDS, target = false, duration = 9000 },
	{ name = "strength", interval = 1000, chance = 9, range = 7, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "energy strike", interval = 2000, chance = 30, minDamage = -2000, maxDamage = -2700, range = 1, target = false },
	{ name = "combat", interval = 2000, chance = 8, type = COMBAT_FIREDAMAGE, minDamage = -1550, maxDamage = -2550, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -1075, maxDamage = -2405, range = 7, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -600, maxDamage = -1500, radius = 8, effect = CONST_ME_LOSEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -750, maxDamage = -1200, length = 8, spread = 0, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "choking fear drown", interval = 2000, chance = 20, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -450, maxDamage = -1400, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -800, maxDamage = -2300, radius = 8, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "speed", interval = 1000, chance = 12, speedChange = -800, radius = 6, effect = CONST_ME_POISONAREA, target = false, duration = 60000 },
	{ name = "strength", interval = 1000, chance = 8, radius = 5, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 1000, chance = 34, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -700, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -950, length = 8, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.defenses = {
	defense = 160,
	armor = 160,
	--	mitigation = ???,
	{ name = "combat", interval = 6000, chance = 25, type = COMBAT_HEALING, minDamage = 2000, maxDamage = 5000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 8, speedChange = 1901, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
	{ name = "invisible", interval = 1000, chance = 4, effect = CONST_ME_MAGIC_BLUE },
	{ name = "invisible", interval = 1000, chance = 17, effect = CONST_ME_MAGIC_BLUE },
}

monster.reflects = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 100 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
