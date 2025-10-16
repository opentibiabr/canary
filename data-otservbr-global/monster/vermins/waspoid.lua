local mType = Game.createMonsterType("Waspoid")
local monster = {}

monster.description = "a Waspoid"
monster.experience = 830
monster.outfit = {
	lookType = 462,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 792
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "The Hive, Hive Outpost.",
}

monster.health = 1100
monster.maxHealth = 1100
monster.race = "venom"
monster.corpse = 13983
monster.speed = 155
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
	canPushCreatures = false,
	staticAttackChance = 95,
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
	{ text = "Peeex!", yell = false },
	{ text = "Bzzzzzzzrrrrzzzzzzrrrrr!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 135 }, -- gold coin
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 14083, chance = 80000 }, -- compound eye
	{ id = 14080, chance = 80000 }, -- waspoid claw
	{ id = 14081, chance = 80000 }, -- waspoid wing
	{ id = 3027, chance = 5000 }, -- black pearl
	{ id = 3010, chance = 1000 }, -- emerald bangle
	{ id = 3037, chance = 1000 }, -- yellow gem
	{ id = 14088, chance = 260 }, -- carapace shield
	{ id = 14087, chance = 260 }, -- grasshopper legs
	{ id = 14089, chance = 260 }, -- hive scythe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -248, condition = { type = CONDITION_POISON, totalDamage = 400, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -110, maxDamage = -180, radius = 3, effect = CONST_ME_POISONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -80, maxDamage = -100, range = 7, shootEffect = CONST_ANI_POISON, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 36,
	mitigation = 1.54,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -2 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -7 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
