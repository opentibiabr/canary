local mType = Game.createMonsterType("The Nightmare Beast")
local monster = {}

monster.description = "The Nightmare Beast"
monster.experience = 75000
monster.outfit = {
	lookType = 1144,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"DreamCourtsBossDeath",
}

monster.health = 850000
monster.maxHealth = 850000
monster.race = "blood"
monster.corpse = 30159
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1718,
	bossRace = RARITY_ARCHFOE,
	storage = Storage.Quest.U12_00.TheDreamCourts.NightmareBeastTimer,
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
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 23542, chance = 6450 }, -- collar of blue plasma
	{ id = 23529, chance = 3230 }, -- ring of blue plasma
	{ id = 23531, chance = 16129 }, -- ring of green plasma
	{ id = 23533, chance = 9680 }, -- ring of red plasma
	{ id = 23543, chance = 9680 }, -- collar of green plasma
	{ id = 23544, chance = 12900 }, -- collar of red plasma
	{ id = 30342, chance = 2830 }, -- enchanted sleep shawl
	{ id = 3039, chance = 41940, maxCount = 2 }, -- red gem
	{ name = "abyss hammer", chance = 2830 },
	{ id = 3341, chance = 3130 }, -- arcane staff
	{ name = "beast's nightmare-cushion", chance = 3770 },
	{ name = "berserk potion", chance = 16129, maxCount = 9 },
	{ name = "blue gem", chance = 6450 },
	{ name = "bullseye potion", chance = 32259, maxCount = 19 },
	{ name = "chaos mace", chance = 10380 },
	{ name = "crystal coin", chance = 22580, maxCount = 3 },
	{ name = "dark whispers", chance = 3230 },
	{ name = "dragon figurine", chance = 7550 },
	{ name = "energy bar", chance = 91510 },
	{ name = "giant emerald", chance = 1890 },
	{ name = "giant ruby", chance = 6450 },
	{ name = "giant sapphire", chance = 2830 },
	{ id = 282, chance = 9680 }, -- giant shimmering pearl
	{ name = "gold ingot", chance = 16129 },
	{ name = "gold token", chance = 64150 },
	{ name = "green gem", chance = 19350 },
	{ name = "huge chunk of crude iron", chance = 38710 },
	{ name = "ice shield", chance = 9680 },
	{ name = "magic sulphur", chance = 8490 },
	{ name = "mastermind potion", chance = 12900, maxCount = 18 },
	{ name = "mysterious remains", chance = 93400 },
	{ name = "piggy bank", chance = 100000 },
	{ name = "piggy bank", chance = 94340 },
	{ name = "platinum coin", chance = 100000, maxCount = 9 },
	{ name = "purple tendril lantern", chance = 6600 },
	{ name = "ring of the sky", chance = 4720 },
	{ name = "royal star", chance = 48390, maxCount = 193 },
	{ name = "silver token", chance = 98110, maxCount = 4 },
	{ name = "skull staff", chance = 12900 },
	{ name = "soul stone", chance = 4720 },
	{ name = "supreme health potion", chance = 58060, maxCount = 29 },
	{ name = "turquoise tendril lantern", chance = 7550 },
	{ name = "ultimate mana potion", chance = 64519, maxCount = 29 },
	{ name = "ultimate spirit potion", chance = 58060, maxCount = 24 },
	{ name = "violet gem", chance = 6450 },
	{ name = "yellow gem", chance = 45160, maxCount = 2 },
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_PHYSICALDAMAGE, minDamage = -1000, maxDamage = -3500, target = true }, -- basic attack (1000-3500)
	{ name = "death beam", interval = 2000, chance = 25, minDamage = -1000, maxDamage = -2100, target = false }, -- -_death_beam(1000-2100)
	{ name = "big death wave", interval = 2000, chance = 25, minDamage = -1000, maxDamage = -2000, target = false }, -- -_death_wave(1000-2000)
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -700, maxDamage = -1000, radius = 5, effect = CONST_ME_MORTAREA, target = false }, -- -_great_death_bomb(700-1000)
}

monster.defenses = {
	defense = 160,
	armor = 160,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 35 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
