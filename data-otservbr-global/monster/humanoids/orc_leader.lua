local mType = Game.createMonsterType("Orc Leader")
local monster = {}

monster.description = "an orc leader"
monster.experience = 270
monster.outfit = {
	lookType = 59,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 59
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Orc Fort, Edron Orc Cave, South of the temple in PoH, Maze of Lost Souls, Cyclopolis, Zao Orc Land.",
}

monster.health = 450
monster.maxHealth = 450
monster.race = "blood"
monster.corpse = 6001
monster.speed = 115
monster.manaCost = 640

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 15,
	damage = 15,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Ulderek futgyr human!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 35 }, -- gold coin
	{ id = 7885, chance = 80000 }, -- fish
	{ id = 3725, chance = 23000 }, -- brown mushroom
	{ id = 11479, chance = 23000 }, -- orc leather
	{ id = 3410, chance = 23000 }, -- plate shield
	{ id = 3298, chance = 23000, maxCount = 4 }, -- throwing knife
	{ id = 3372, chance = 5000 }, -- brass legs
	{ id = 3285, chance = 5000 }, -- longsword
	{ id = 7378, chance = 5000 }, -- royal spear
	{ id = 3091, chance = 5000 }, -- sword ring
	{ id = 3357, chance = 5000 }, -- plate armor
	{ id = 3307, chance = 5000 }, -- scimitar
	{ id = 11480, chance = 5000 }, -- skull belt
	{ id = 3301, chance = 1000 }, -- broadsword
	{ id = 10196, chance = 1000 }, -- orc tooth
	{ id = 266, chance = 1000 }, -- health potion
	{ id = 3557, chance = 260 }, -- plate legs
	{ id = 3369, chance = 260 }, -- warrior helmet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -185 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -70, range = 7, shootEffect = CONST_ANI_THROWINGKNIFE, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 20,
	mitigation = 1.18,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
