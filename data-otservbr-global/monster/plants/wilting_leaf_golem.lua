local mType = Game.createMonsterType("Wilting Leaf Golem")
local monster = {}

monster.description = "a wilting leaf golem"
monster.experience = 225
monster.outfit = {
	lookType = 573,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 982
monster.Bestiary = {
	class = "Plant",
	race = BESTY_RACE_PLANT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Forest Fury Camp, Lair of the Treeling Witch and in the Forest Fury version of the Forsaken Mine.",
}

monster.health = 380
monster.maxHealth = 380
monster.race = "blood"
monster.corpse = 19117
monster.speed = 74
monster.manaCost = 390

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
	{ text = "*crackle*", yell = false },
	{ text = "*swwwwishhhh*", yell = false },
}

monster.loot = {
	{ name = "gold coin", chance = 97540, maxCount = 45 },
	{ name = "fir cone", chance = 14950 },
	{ name = "dowser", chance = 11880 },
	{ name = "small emerald", chance = 1050 },
	{ name = "white mushroom", chance = 5040, maxCount = 3 },
	{ name = "swampling club", chance = 4890 },
}

monster.attacks = {
	{ name = "melee", interval = 1500, chance = 100, minDamage = 0, maxDamage = -120, condition = { type = CONDITION_POISON, totalDamage = 300, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -50, range = 7, radius = 1, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_EXPLOSIONHIT, target = true },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 15, minDamage = -150, maxDamage = -200, radius = 4, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -600, radius = 3, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
}

monster.defenses = {
	defense = 0,
	armor = 20,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
