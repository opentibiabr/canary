local mType = Game.createMonsterType("Stone Devourer")
local monster = {}

monster.description = "a stone devourer"
monster.experience = 2900
monster.outfit = {
	lookType = 486,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 879
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Warzone 1.",
}

monster.health = 4200
monster.maxHealth = 4200
monster.race = "undead"
monster.corpse = 15865
monster.speed = 150
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
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 1,
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
	{ text = "Rumble!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 7 }, -- platinum coin
	{ id = 9632, chance = 23000 }, -- ancient stone
	{ id = 12600, chance = 23000 }, -- coal
	{ id = 15793, chance = 23000, maxCount = 10 }, -- crystalline arrow
	{ id = 16138, chance = 23000 }, -- crystalline spikes
	{ id = 16125, chance = 23000 }, -- cyan crystal fragment
	{ id = 238, chance = 23000, maxCount = 2 }, -- great mana potion
	{ id = 16122, chance = 23000 }, -- green crystal splinter
	{ id = 268, chance = 23000, maxCount = 2 }, -- mana potion
	{ id = 16137, chance = 23000 }, -- stone nose
	{ id = 236, chance = 23000, maxCount = 2 }, -- strong health potion
	{ id = 237, chance = 23000, maxCount = 2 }, -- strong mana potion
	{ id = 7643, chance = 23000 }, -- ultimate health potion
	{ id = 3097, chance = 5000 }, -- dwarven ring
	{ id = 7454, chance = 5000 }, -- glorious axe
	{ id = 3081, chance = 5000 }, -- stone skin amulet
	{ id = 7437, chance = 5000 }, -- sapphire hammer
	{ id = 7452, chance = 5000 }, -- spiked squelcher
	{ id = 3333, chance = 1000 }, -- crystal mace
	{ id = 3342, chance = 1000 }, -- war axe
	{ id = 3281, chance = 260 }, -- giant sword
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -990 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -230, maxDamage = -460, range = 7, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_STONES, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -650, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -150, maxDamage = -260, length = 5, spread = 0, effect = CONST_ME_STONES, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 75,
	mitigation = 2.31,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
