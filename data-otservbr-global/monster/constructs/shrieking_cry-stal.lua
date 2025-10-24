local mType = Game.createMonsterType("Shrieking Cry-Stal")
local monster = {}

monster.description = "a shrieking cry-stal"
monster.experience = 13560
monster.outfit = {
	lookType = 1560,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2278
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Crystal Enigma",
}

monster.health = 20650
monster.maxHealth = 20650
monster.race = "energy"
monster.corpse = 39331
monster.speed = 207
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
	staticAttackChance = 90,
	targetDistance = 3,
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
	{ text = "La-la-la..AAAHHHH!!!", yell = false },
	{ text = "SCREEECH...", yell = true },
}

monster.loot = {
	{ id = 3043, chance = 23797, maxCount = 2 }, -- Crystal Coin
	{ id = 7642, chance = 20718 }, -- Great Spirit Potion
	{ id = 39394, chance = 12503, maxCount = 2 }, -- Cry-Stal
	{ id = 3028, chance = 5808, maxCount = 3 }, -- Small Diamond
	{ id = 8895, chance = 5316 }, -- Rusted Armor
	{ id = 16127, chance = 4414 }, -- Green Crystal Fragment
	{ id = 813, chance = 4625 }, -- Terra Boots
	{ id = 3084, chance = 2272 }, -- Protection Amulet
	{ id = 3036, chance = 1280 }, -- Violet Gem
	{ id = 3063, chance = 694 }, -- Gold Ring
	{ id = 3038, chance = 420 }, -- Green Gem
	{ id = 3006, chance = 220 }, -- Ring of the Sky
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 5000, chance = 47, type = COMBAT_ENERGYDAMAGE, minDamage = -650, maxDamage = -900, range = 6, shootEffect = CONST_ANI_ENERGYBALL },
	{ name = "combat", interval = 3500, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -700, radius = 6, effect = CONST_ME_MORTAREA, target = false },
	{ name = "energy chain", interval = 2000, chance = 20, minDamage = -425, maxDamage = -550, range = 3, target = true },
	{ name = "combat", interval = 3000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -700, maxDamage = -1000, length = 5, spread = 2, effect = CONST_ME_SOUND_PURPLE, target = false },
	{ name = "fear", interval = 2000, chance = 1, target = true },
}

monster.defenses = {
	defense = 110,
	armor = 95,
	mitigation = 2.45,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -5 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
