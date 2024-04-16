local mType = Game.createMonsterType("True Midnight Asura")
local monster = {}

monster.description = "a true midnight asura"
monster.experience = 7313
monster.outfit = {
	lookType = 1068,
	lookHead = 0,
	lookBody = 76,
	lookLegs = 53,
	lookFeet = 0,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 1621
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Asura Palace, Asura Vaults.",
}

monster.health = 9000
monster.maxHealth = 9000
monster.race = "blood"
monster.corpse = 28617
monster.speed = 170
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 80,
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
	{ name = "violet gem", chance = 1390 },
	{ name = "crystal coin", chance = 5760, maxCount = 1 },
	{ name = "royal star", chance = 4090, maxCount = 3 },
	{ id = 3035, chance = 100000, maxCount = 8 }, -- platinum coin
	{ id = 7368, chance = 9210, maxCount = 5 }, -- assassin star
	{ id = 3027, chance = 9870, maxCount = 2 }, -- black pearl
	{ id = 6558, chance = 20540 }, -- flask of demonic blood
	{ id = 6499, chance = 10730 }, -- demonic essence
	{ id = 3028, chance = 15630, maxCount = 2 }, -- small diamond
	{ id = 3032, chance = 7750, maxCount = 2 }, -- small emerald
	{ id = 3030, chance = 7830, maxCount = 2 }, -- small ruby
	{ id = 3029, chance = 12690, maxCount = 2 }, -- small sapphire
	{ id = 9057, chance = 8120, maxCount = 2 }, -- small topaz
	{ id = 239, chance = 19960, maxCount = 2 }, -- great health potion
	{ id = 3026, chance = 8170, maxCount = 2 }, -- white pearl
	{ id = 7404, chance = 980 }, -- assassin dagger
	{ id = 3041, chance = 1020 }, -- blue gem
	{ id = 3567, chance = 900 }, -- blue robe
	{ id = 9058, chance = 900 }, -- gold ingot
	{ id = 21974, chance = 12440 }, -- golden lotus brooch
	{ id = 3069, chance = 3610 }, -- necrotic rod
	{ id = 21981, chance = 1820 }, -- oriental shoes
	{ id = 21975, chance = 12790 }, -- peacock feather fan
	{ id = 8061, chance = 930 }, -- skullcracker armor
	{ id = 3017, chance = 10060 }, -- silver brooch
	{ id = 3054, chance = 2020 }, -- silver amulet
	{ id = 5944, chance = 10020 }, -- soul orb
	{ id = 8074, chance = 900 }, -- spellbook of mind control
	{ id = 3403, chance = 2290 }, -- tribal mask
	{ id = 8082, chance = 990 }, -- underworld rod
	{ id = 3037, chance = 900 }, -- yellow gem
	{ id = 3007, chance = 930 }, -- crystal ring
	{ name = "small enchanted amethyst", chance = 1441, maxCount = 3 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -650, range = 5, effect = CONST_ME_MORTAREA, target = true }, --Death Missile
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -50, maxDamage = -280, range = 7, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -240, length = 8, spread = 0, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -700, length = 8, spread = 0, effect = CONST_ME_BLACKSMOKE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -100, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000 },
}

monster.defenses = {
	defense = 55,
	armor = 75,
	mitigation = 2.16,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
	{ name = "invisible", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
