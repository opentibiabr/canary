local mType = Game.createMonsterType("Poor Soul")
local monster = {}

monster.description = "a poor soul"
monster.experience = 0
monster.outfit = {
	lookType = 1296,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 500
monster.maxHealth = 500
monster.race = "undead"
monster.corpse = 33891
monster.speed = 140
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 5,
}

monster.strategiesTarget = {
	nearest = 60,
	health = 10,
	damage = 10,
	random = 20,
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
	{ text = "I have a head start.", yell = false },
	{ text = "Look into my eyes! No, the other ones!", yell = false },
	{ text = "The mirrors can't contain the night!", yell = false },
}

monster.loot = {
	{ name = "crystal coin", chance = 70540 },
	{ name = "ultimate health potion", chance = 12220, maxCount = 7 },
	{ name = "violet gem", chance = 4560 },
	{ name = "green gem", chance = 5760 },
	{ name = "blue gem", chance = 4960 },
	{ name = "northwind rod", chance = 5920 },
	{ name = "sacred tree amulet", chance = 5520 },
	{ id = 33933, chance = 7920 }, -- apron
	{ id = 3067, chance = 7220 }, -- hailstorm rod
	{ name = "glacier shoes", chance = 2520 },
	{ name = "glacier robe", chance = 2220 },
	{ name = "stone skin amulet", chance = 5920 },
	{ id = 23533, chance = 4892 }, -- ring of red plasma
	{ id = 33932, chance = 3520 }, -- head
	{ name = "glacial rod", chance = 620 },
	{ id = 34024, chance = 650 }, -- gruesome fan
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -250, maxDamage = -450 },
}

monster.defenses = {
	defense = 90,
	armor = 105,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 100 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = -300 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
