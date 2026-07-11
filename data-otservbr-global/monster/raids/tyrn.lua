local mType = Game.createMonsterType("Tyrn")
local monster = {}

monster.description = "Tyrn"
monster.experience = 6900
monster.outfit = {
	lookType = 562,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 966,
	bossRace = RARITY_NEMESIS,
}

monster.health = 12000
monster.maxHealth = 12000
monster.race = "blood"
monster.corpse = 18970
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "GRRR", yell = true },
	{ text = "GRROARR", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 99 }, -- Gold Coin
	{ id = 3583, chance = 74000, maxCount = 5 }, -- Dragon Ham
	{ id = 9665, chance = 74000 }, -- Wyrm Scale
	{ id = 3035, chance = 61000, maxCount = 9 }, -- Platinum Coin
	{ id = 3155, chance = 52000, maxCount = 9 }, -- Sudden Death Rune
	{ id = 237, chance = 43000, maxCount = 9 }, -- Strong Mana Potion
	{ id = 236, chance = 39000, maxCount = 9 }, -- Strong Health Potion
	{ id = 7368, chance = 30000, maxCount = 9 }, -- Assassin Star
	{ id = 3032, chance = 17400, maxCount = 9 }, -- Small Emerald
	{ id = 3033, chance = 13000, maxCount = 9 }, -- Small Amethyst
	{ id = 9057, chance = 13000, maxCount = 6 }, -- Small Topaz
	{ id = 3037, chance = 8700 }, -- Yellow Gem
	{ id = 3030, chance = 8700, maxCount = 8 }, -- Small Ruby
	{ id = 3028, chance = 4300, maxCount = 9 }, -- Small Diamond
	{ id = 3039, chance = 4300 }, -- Red Gem
	{ id = 3041, chance = 4300 }, -- Blue Gem
	{ id = 3029, chance = 4300, maxCount = 2 }, -- Small Sapphire
	{ id = 8092, chance = 4300 }, -- Wand of Starstorm
	{ id = 19083, chance = 33330 }, -- Silver Raid Token
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 70, attack = 130 },
	{ name = "drunk", interval = 2000, chance = 8, radius = 8, effect = CONST_ME_SOUND_YELLOW, target = false, duration = 25000 },
	{ name = "combat", interval = 2000, chance = 33, type = COMBAT_ENERGYDAMAGE, minDamage = -100, maxDamage = -190, range = 7, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_ENERGYAREA, target = true },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -300, range = 7, radius = 4, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_EXPLOSIONHIT, target = true },
	{ name = "tyrn electrify", interval = 2000, chance = 11, target = false },
	{ name = "tyrn skill reducer", interval = 2000, chance = 14, target = false },
}

monster.defenses = {
	defense = 68,
	armor = 58,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 33, type = COMBAT_HEALING, minDamage = 200, maxDamage = 300, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 2000, chance = 11, effect = CONST_ME_ENERGYHIT },
	{ name = "tyrn heal", interval = 1000, chance = 100, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 80 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
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
