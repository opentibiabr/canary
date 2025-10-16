local mType = Game.createMonsterType("Hirintror")
local monster = {}

monster.description = "Hirintror"
monster.experience = 800
monster.outfit = {
	lookType = 261,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 967,
	bossRace = RARITY_NEMESIS,
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "undead"
monster.corpse = 7282
monster.speed = 95
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
	canPushCreatures = false,
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
	{ text = "Srk.", yell = false },
	{ text = "Krss!", yell = false },
	{ text = "Chrrk! Krk!", yell = false },
	{ text = "snirr!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 60 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 2 }, -- platinum coin
	{ id = 237, chance = 80000, maxCount = 3 }, -- strong mana potion
	{ id = 236, chance = 80000, maxCount = 3 }, -- strong health potion
	{ id = 3028, chance = 80000, maxCount = 5 }, -- small diamond
	{ id = 3029, chance = 80000 }, -- small sapphire
	{ id = 3027, chance = 80000 }, -- black pearl
	{ id = 7290, chance = 80000 }, -- shard
	{ id = 7741, chance = 80000 }, -- ice cube
	{ id = 9661, chance = 80000 }, -- frosty heart
	{ id = 5912, chance = 80000 }, -- blue piece of cloth
	{ id = 3373, chance = 80000 }, -- strange helmet
	{ id = 7449, chance = 80000 }, -- crystal sword
	{ id = 3284, chance = 80000 }, -- ice rapier
	{ id = 829, chance = 80000 }, -- glacier mask
	{ id = 819, chance = 80000 }, -- glacier shoes
	{ id = 19362, chance = 1000 }, -- icicle bow
	{ id = 19363, chance = 1000 }, -- runic ice shield
	{ id = 19083, chance = 1000 }, -- silver raid token
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 140, attack = 40 },
	{ name = "hirintror freeze", interval = 2000, chance = 15, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -75, maxDamage = -150, range = 7, radius = 3, shootEffect = CONST_ANI_ICE, effect = CONST_ME_BLOCKHIT, target = true },
	{ name = "ice golem paralyze", interval = 2000, chance = 11, target = false },
	{ name = "hirintror skill reducer", interval = 2000, chance = 10, target = false },
}

monster.defenses = {
	defense = 26,
	armor = 25,
	mitigation = 1.18,
	{ name = "hirintror summon", interval = 2000, chance = 18, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
