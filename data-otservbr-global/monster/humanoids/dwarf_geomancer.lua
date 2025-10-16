local mType = Game.createMonsterType("Dwarf Geomancer")
local monster = {}

monster.description = "a dwarf geomancer"
monster.experience = 265
monster.outfit = {
	lookType = 66,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 66
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Mount Sternum Undead Cave, Dwarf Mines, Circle Room in Kazordoon, Triangle Tower, \z
		Tiquanda Dwarf Cave, Cormaya Dwarven Cave, Beregar Mines.",
}

monster.health = 380
monster.maxHealth = 380
monster.race = "blood"
monster.corpse = 6015
monster.speed = 100
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 4,
	runHealth = 110,
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
	{ text = "Hail Durin!", yell = false },
	{ text = "Earth is the strongest element.", yell = false },
	{ text = "Dust to dust.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 45 }, -- gold coin
	{ id = 3147, chance = 80000 }, -- blank rune
	{ id = 3584, chance = 80000 }, -- pear
	{ id = 3723, chance = 80000, maxCount = 2 }, -- white mushroom
	{ id = 3047, chance = 23000 }, -- magic light wand
	{ id = 11458, chance = 23000 }, -- geomancers robe
	{ id = 11463, chance = 23000 }, -- geomancers staff
	{ id = 3311, chance = 1000 }, -- clerical mace
	{ id = 3097, chance = 1000 }, -- dwarven ring
	{ id = 3029, chance = 1000 }, -- small sapphire
	{ id = 813, chance = 260 }, -- terra boots
	{ id = 5880, chance = 260 }, -- iron ore
	{ id = 3101, chance = 260 }, -- spellbook
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -50, maxDamage = -110, range = 7, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -50, maxDamage = -80, range = 7, target = false },
}

monster.defenses = {
	defense = 15,
	armor = 15,
	mitigation = 0.91,
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_HEALING, minDamage = 75, maxDamage = 125, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 60 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
