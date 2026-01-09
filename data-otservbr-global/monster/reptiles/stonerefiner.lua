local mType = Game.createMonsterType("Stonerefiner")
local monster = {}

monster.description = "a stonerefiner"
monster.experience = 500
monster.outfit = {
	lookType = 1032,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1525
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Corym Mines.",
}

monster.health = 800
monster.maxHealth = 800
monster.race = "blood"
monster.corpse = 27536
monster.speed = 110
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
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "knak knak knak", yell = false },
	{ text = "nomnomnom", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 50710, maxCount = 4 }, -- Platinum Coin
	{ id = 9054, chance = 24820 }, -- Glob of Acid Slime
	{ id = 12600, chance = 30090 }, -- Coal
	{ id = 27301, chance = 40130 }, -- Rare Earth
	{ id = 9640, chance = 19560, maxCount = 3 }, -- Poisonous Slime
	{ id = 27369, chance = 14840, maxCount = 5 }, -- Half-Digested Stones
	{ id = 17821, chance = 10410 }, -- Rat Cheese
	{ id = 27606, chance = 19970 }, -- Stonerefiner's Skull
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100 },
	{ name = "berserk", interval = 2000, chance = 15, minDamage = 0, maxDamage = -70, target = false },
	{ name = "stone shower rune", interval = 2000, chance = 10, minDamage = -40, maxDamage = -80, range = 7, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 20,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
