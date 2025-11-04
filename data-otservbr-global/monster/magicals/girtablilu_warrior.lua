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
	{ id = 3035, chance = 79977, maxCount = 16 }, -- Platinum Coin
	{ id = 7643, chance = 16863, maxCount = 4 }, -- Ultimate Health Potion
	{ id = 9058, chance = 14221 }, -- Gold Ingot
	{ id = 16121, chance = 6175 }, -- Green Crystal Shard
	{ id = 826, chance = 2311 }, -- Magma Coat
	{ id = 3036, chance = 3337 }, -- Violet Gem
	{ id = 3037, chance = 3169 }, -- Yellow Gem
	{ id = 3038, chance = 4052 }, -- Green Gem
	{ id = 3039, chance = 2562 }, -- Red Gem
	{ id = 3041, chance = 1592 }, -- Blue Gem
	{ id = 3284, chance = 3238 }, -- Ice Rapier
	{ id = 3304, chance = 3377 }, -- Crowbar
	{ id = 3318, chance = 1814 }, -- Knight Axe
	{ id = 3326, chance = 2041 }, -- Epee
	{ id = 3344, chance = 1565 }, -- Beastslayer Axe
	{ id = 3567, chance = 1147 }, -- Blue Robe
	{ id = 7387, chance = 2045 }, -- Diamond Sceptre
	{ id = 7430, chance = 1832 }, -- Dragonbone Staff
	{ id = 16119, chance = 2678 }, -- Blue Crystal Shard
	{ id = 16120, chance = 2318 }, -- Violet Crystal Shard
	{ id = 16125, chance = 4727 }, -- Cyan Crystal Fragment
	{ id = 16126, chance = 4709 }, -- Red Crystal Fragment
	{ id = 16127, chance = 1611 }, -- Green Crystal Fragment
	{ id = 22085, chance = 971 }, -- Fur Armor
	{ id = 36822, chance = 4636 }, -- Scorpion Charm
	{ id = 36971, chance = 4328 }, -- Girtablilu Warrior Carapace
	{ id = 824, chance = 1270 }, -- Glacier Robe
	{ id = 8043, chance = 985 }, -- Focus Cape
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
