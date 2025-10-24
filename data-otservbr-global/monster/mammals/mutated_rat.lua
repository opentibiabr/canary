local mType = Game.createMonsterType("Mutated Rat")
local monster = {}

monster.description = "a mutated rat"
monster.experience = 450
monster.outfit = {
	lookType = 305,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 502
monster.Bestiary = {
	class = "Mammal",
	race = BESTY_RACE_MAMMAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Alchemist Quarter, Arena and Zoo Quarter (Inside the arena with other mutated creatures), \z
		Razzachai, Vampire Castle on Vengoth, Robson's Isle, Mushroom Gardens, Souleater Mountains, \z
		Northern Zao Plantations, Middle Spike.",
}

monster.health = 550
monster.maxHealth = 550
monster.race = "blood"
monster.corpse = 8957
monster.speed = 115
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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Grrrrrrrrrrrrrr!", yell = false },
	{ text = "Fcccccchhhhhh", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 78720, maxCount = 130 }, -- Gold Coin
	{ id = 3114, chance = 18732 }, -- Skull (Item)
	{ id = 3735, chance = 4445 }, -- Stone Herb
	{ id = 9668, chance = 4225 }, -- Mutated Rat Tail
	{ id = 3410, chance = 4855 }, -- Plate Shield
	{ id = 3269, chance = 3083 }, -- Halberd
	{ id = 3732, chance = 1216 }, -- Green Mushroom
	{ id = 3120, chance = 940 }, -- Mouldy Cheese
	{ id = 266, chance = 699 }, -- Health Potion
	{ id = 3049, chance = 602 }, -- Stealth Ring
	{ id = 8072, chance = 360 }, -- Spellbook of Enlightenment
	{ id = 3428, chance = 99 }, -- Tower Shield
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -158, condition = { type = CONDITION_POISON, totalDamage = 100, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -45, maxDamage = -85, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -80, maxDamage = -100, length = 5, spread = 3, effect = CONST_ME_POISONAREA, target = false },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -600, range = 7, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -30, maxDamage = -70, range = 7, radius = 3, effect = CONST_ME_MAGIC_RED, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 10, range = 7, radius = 3, effect = CONST_ME_POISONAREA, target = false },
}

monster.defenses = {
	defense = 15,
	armor = 32,
	mitigation = 0.99,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 80, maxDamage = 95, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
