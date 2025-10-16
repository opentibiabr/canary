local mType = Game.createMonsterType("Dwarf Guard")
local monster = {}

monster.description = "a dwarf guard"
monster.experience = 165
monster.outfit = {
	lookType = 70,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 70
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Kazordoon Dwarf Mines, Dwacatra, Ferngrims Gate, Cyclopolis, Mount Sternum Undead Cave, \z
		Stonehome Rotworm cave (near Edron), Maze of Lost Souls, Tiquanda Dwarf Cave, Beregar, Cormaya Dwarf Cave.",
}

monster.health = 245
monster.maxHealth = 245
monster.race = "blood"
monster.corpse = 6013
monster.speed = 103
monster.manaCost = 650

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 20,
	random = 10,
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
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Hail Durin!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 30 }, -- gold coin
	{ id = 3552, chance = 80000 }, -- leather boots
	{ id = 3723, chance = 80000, maxCount = 2 }, -- white mushroom
	{ id = 3377, chance = 23000 }, -- scale armor
	{ id = 3413, chance = 23000 }, -- battle shield
	{ id = 3305, chance = 5000 }, -- battle hammer
	{ id = 3351, chance = 5000 }, -- steel helmet
	{ id = 3275, chance = 1000 }, -- double axe
	{ id = 5880, chance = 1000 }, -- iron ore
	{ id = 266, chance = 260 }, -- health potion
	{ id = 3033, chance = 260 }, -- small amethyst
	{ id = 3092, chance = 260 }, -- axe ring
	{ id = 12600, chance = 260 }, -- coal
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -140 },
}

monster.defenses = {
	defense = 30,
	armor = 15,
	mitigation = 1.02,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
