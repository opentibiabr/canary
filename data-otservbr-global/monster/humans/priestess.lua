local mType = Game.createMonsterType("Priestess")
local monster = {}

monster.description = "a priestess"
monster.experience = 420
monster.outfit = {
	lookType = 58,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 58
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Hero Cave, Drefia ruins, Lich Hell, Tombs, Magician Quarter in Yalahar, Vengoth Castle.",
}

monster.health = 390
monster.maxHealth = 390
monster.race = "blood"
monster.corpse = 18210
monster.speed = 85
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
	staticAttackChance = 90,
	targetDistance = 4,
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

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "ghoul", chance = 10, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Your energy is mine.", yell = false },
	{ text = "Now your life is come to the end, hahahaha!", yell = false },
	{ text = "Throw the soul on the altar!", yell = false },
}

monster.loot = {
	{ id = 10303, chance = 23000 }, -- dark rosary
	{ id = 3674, chance = 23000 }, -- goat grass
	{ id = 3739, chance = 23000 }, -- powder herb
	{ id = 3585, chance = 23000, maxCount = 2 }, -- red apple
	{ id = 3738, chance = 23000 }, -- sling herb
	{ id = 9645, chance = 5000 }, -- black hood
	{ id = 3727, chance = 5000 }, -- wood mushroom
	{ id = 3311, chance = 5000 }, -- clerical mace
	{ id = 22196, chance = 5000 }, -- crystal ball
	{ id = 9639, chance = 5000 }, -- cultish robe
	{ id = 3262, chance = 5000 }, -- wooden flute
	{ id = 3008, chance = 1000 }, -- crystal necklace
	{ id = 3067, chance = 1000 }, -- hailstorm rod
	{ id = 268, chance = 1000 }, -- mana potion
	{ id = 3034, chance = 1000 }, -- talon
	{ id = 3429, chance = 260 }, -- black shield
	{ id = 2995, chance = 260 }, -- piggy bank
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -75 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -55, maxDamage = -120, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -2, maxDamage = -170, range = 7, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 15, range = 7, shootEffect = CONST_ANI_POISON, target = false },
}

monster.defenses = {
	defense = 15,
	armor = 30,
	mitigation = 1.32,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 80, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 70 },
	{ type = COMBAT_FIREDAMAGE, percent = 40 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
