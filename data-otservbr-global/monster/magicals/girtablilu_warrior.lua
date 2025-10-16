local mType = Game.createMonsterType("Girtablilu Warrior")
local monster = {}

monster.description = "a girtablilu warrior"
monster.experience = 5800
monster.outfit = {
	lookType = 1407,
	lookHead = 114,
	lookBody = 39,
	lookLegs = 113,
	lookFeet = 114,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 2099
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Ruins of Nuur.",
}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "blood"
monster.corpse = 36800
monster.speed = 180
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	rewardBoss = false,
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
	{ id = 3035, chance = 80000, maxCount = 16 }, -- platinum coin
	{ id = 7643, chance = 23000, maxCount = 4 }, -- ultimate health potion
	{ id = 9058, chance = 23000 }, -- gold ingot
	{ id = 16121, chance = 23000 }, -- green crystal shard
	{ id = 826, chance = 5000 }, -- magma coat
	{ id = 3036, chance = 5000 }, -- violet gem
	{ id = 3037, chance = 5000 }, -- yellow gem
	{ id = 3038, chance = 5000 }, -- green gem
	{ id = 36706, chance = 5000 }, -- red gem
	{ id = 3041, chance = 5000 }, -- blue gem
	{ id = 3284, chance = 5000 }, -- ice rapier
	{ id = 3304, chance = 5000 }, -- crowbar
	{ id = 3318, chance = 5000 }, -- knight axe
	{ id = 3326, chance = 5000 }, -- epee
	{ id = 3344, chance = 5000 }, -- beastslayer axe
	{ id = 3567, chance = 5000 }, -- blue robe
	{ id = 7387, chance = 5000 }, -- diamond sceptre
	{ id = 7430, chance = 5000 }, -- dragonbone staff
	{ id = 16119, chance = 5000 }, -- blue crystal shard
	{ id = 16120, chance = 5000 }, -- violet crystal shard
	{ id = 16125, chance = 5000 }, -- cyan crystal fragment
	{ id = 16126, chance = 5000 }, -- red crystal fragment
	{ id = 16127, chance = 5000 }, -- green crystal fragment
	{ id = 22085, chance = 5000 }, -- fur armor
	{ id = 36822, chance = 5000 }, -- scorpion charm
	{ id = 36971, chance = 5000 }, -- girtablilu warrior carapace
	{ id = 824, chance = 1000 }, -- glacier robe
	{ id = 8043, chance = 1000 }, -- focus cape
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -450 },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -650, radius = 4, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -450, range = 5, shootEffect = CONST_ANI_POISONARROW, target = true },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -400, length = 3, spread = 2, effect = CONST_ME_GREEN_RINGS, target = false },
}

monster.defenses = {
	defense = 76,
	armor = 76,
	mitigation = 2.22,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 150, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
