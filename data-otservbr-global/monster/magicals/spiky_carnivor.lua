local mType = Game.createMonsterType("Spiky Carnivor")
local monster = {}

monster.description = "a spiky carnivor"
monster.experience = 1650
monster.outfit = {
	lookType = 1139,
	lookHead = 79,
	lookBody = 121,
	lookLegs = 23,
	lookFeet = 86,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 1722
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Carnivora's Rocks.",
}

monster.health = 2800
monster.maxHealth = 2800
monster.race = "blood"
monster.corpse = 30099
monster.speed = 160
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
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 4,
	color = 32,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 6 }, -- platinum coin
	{ id = 3383, chance = 23000 }, -- dark armor
	{ id = 16123, chance = 23000 }, -- brown crystal splinter
	{ id = 16124, chance = 23000 }, -- blue crystal splinter
	{ id = 29346, chance = 23000, maxCount = 2 }, -- green glass plate
	{ id = 3415, chance = 5000 }, -- guardian shield
	{ id = 814, chance = 5000 }, -- terra amulet
	{ id = 815, chance = 5000 }, -- glacier amulet
	{ id = 3034, chance = 5000 }, -- talon
	{ id = 3369, chance = 5000 }, -- warrior helmet
	{ id = 3567, chance = 5000 }, -- blue robe
	{ id = 24962, chance = 5000 }, -- prismatic quartz
	{ id = 25737, chance = 5000, maxCount = 2 }, -- rainbow quartz
	{ id = 816, chance = 1000 }, -- lightning pendant
	{ id = 811, chance = 260 }, -- terra mantle
	{ id = 9304, chance = 260 }, -- shockwave amulet
	{ id = 3379, chance = 260 }, -- doublet
	{ id = 17829, chance = 260 }, -- buckle
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -400 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -230, maxDamage = -380, radius = 4, effect = CONST_ME_GROUNDSHAKER, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 71,
	mitigation = 1.94,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.reflects = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 40 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -30 },
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
