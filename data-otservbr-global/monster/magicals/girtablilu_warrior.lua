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
	{ id = 3035, chance = 74000, maxCount = 16 }, -- Platinum Coin
	{ id = 7643, chance = 15700, maxCount = 4 }, -- Ultimate Health Potion
	{ id = 9058, chance = 14000 }, -- Gold Ingot
	{ id = 16121, chance = 6200 }, -- Green Crystal Shard
	{ id = 16125, chance = 5500 }, -- Cyan Crystal Fragment
	{ id = 36822, chance = 4500 }, -- Scorpion Charm
	{ id = 3036, chance = 4200 }, -- Violet Gem
	{ id = 3304, chance = 3400 }, -- Crowbar
	{ id = 3038, chance = 3200 }, -- Green Gem
	{ id = 16126, chance = 3200 }, -- Red Crystal Fragment
	{ id = 3037, chance = 2800 }, -- Yellow Gem
	{ id = 36971, chance = 2600 }, -- Girtablilu Warrior Carapace
	{ id = 3039, chance = 2500 }, -- Red Gem
	{ id = 826, chance = 2300 }, -- Magma Coat
	{ id = 3326, chance = 2300 }, -- Epee
	{ id = 16119, chance = 2300 }, -- Blue Crystal Shard
	{ id = 3041, chance = 2100 }, -- Blue Gem
	{ id = 16120, chance = 2100 }, -- Violet Crystal Shard
	{ id = 3284, chance = 1900 }, -- Ice Rapier
	{ id = 7387, chance = 1900 }, -- Diamond Sceptre
	{ id = 3344, chance = 1700 }, -- Beastslayer Axe
	{ id = 16127, chance = 1700 }, -- Green Crystal Fragment
	{ id = 3318, chance = 1500 }, -- Knight Axe
	{ id = 3567, chance = 1300 }, -- Blue Robe
	{ id = 8043, chance = 1300 }, -- Focus Cape
	{ id = 7430, chance = 1100 }, -- Dragonbone Staff
	{ id = 22085, chance = 750 }, -- Fur Armor
	{ id = 824, chance = 750 }, -- Glacier Robe
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
