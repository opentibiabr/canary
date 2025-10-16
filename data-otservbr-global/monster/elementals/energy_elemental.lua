local mType = Game.createMonsterType("Energy Elemental")
local monster = {}

monster.description = "an energy elemental"
monster.experience = 550
monster.outfit = {
	lookType = 293,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 457
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Khazeel, Energy Elemental Lair, Vandura Mountain, Vengoths mountain.",
}

monster.health = 500
monster.maxHealth = 500
monster.race = "venom"
monster.corpse = 8138
monster.speed = 115
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 85,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 4,
	color = 143,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 170 }, -- gold coin
	{ id = 268, chance = 23000 }, -- mana potion
	{ id = 761, chance = 23000, maxCount = 10 }, -- flash arrow
	{ id = 3287, chance = 23000, maxCount = 5 }, -- throwing star
	{ id = 237, chance = 23000 }, -- strong mana potion
	{ id = 7449, chance = 23000 }, -- crystal sword
	{ id = 3033, chance = 5000, maxCount = 2 }, -- small amethyst
	{ id = 3313, chance = 5000 }, -- obsidian lance
	{ id = 6093, chance = 5000 }, -- crystal ring
	{ id = 3048, chance = 5000 }, -- might ring
	{ id = 3054, chance = 5000 }, -- silver amulet
	{ id = 3051, chance = 1000 }, -- energy ring
	{ id = 3073, chance = 1000 }, -- wand of cosmic energy
	{ id = 3415, chance = 260 }, -- guardian shield
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -175 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -125, maxDamage = -252, range = 7, radius = 2, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -100, maxDamage = -130, range = 7, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "energy elemental electrify", interval = 2000, chance = 20, target = false },
}

monster.defenses = {
	defense = 15,
	armor = 25,
	mitigation = 0.72,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 90, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 35 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
