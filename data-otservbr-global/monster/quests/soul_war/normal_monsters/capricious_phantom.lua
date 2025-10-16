local mType = Game.createMonsterType("Capricious Phantom")
local monster = {}

monster.description = "a capricious phantom"
monster.experience = 19360
monster.outfit = {
	lookType = 1298,
	lookHead = 81,
	lookBody = 114,
	lookLegs = 85,
	lookFeet = 83,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1932
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Ebb and Flow.",
}

monster.events = {
	"FourthTaintBossesPrepareDeath",
}

monster.health = 30000
monster.maxHealth = 30000
monster.race = "undead"
monster.corpse = 34121
monster.speed = 240
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 0,
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
	{ text = "I hope you can't swim.", yell = false },
	{ text = "Troubled Water. Troubled you!", yell = false },
	{ text = "You should shiver!", yell = false },
	{ text = "You will leak blood.", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 7642, chance = 80000 }, -- great spirit potion
	{ id = 3041, chance = 23000 }, -- blue gem
	{ id = 9058, chance = 23000 }, -- gold ingot
	{ id = 3036, chance = 5000 }, -- violet gem
	{ id = 3575, chance = 5000 }, -- wood cape
	{ id = 23529, chance = 5000 }, -- ring of blue plasma
	{ id = 34138, chance = 5000 }, -- capricious heart
	{ id = 34145, chance = 5000 }, -- capricious robe
	{ id = 14247, chance = 1000 }, -- ornate crossbow
	{ id = 16118, chance = 1000 }, -- glacial rod
	{ id = 22085, chance = 1000 }, -- fur armor
	{ id = 23526, chance = 1000 }, -- collar of blue plasma
	{ id = 3081, chance = 260 }, -- stone skin amulet
	{ id = 34109, chance = 260 }, -- bag you desire
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -850, maxDamage = -1200, range = 7, radius = 3, shootEffect = CONST_ANI_POISONARROW, effect = CONST_ME_GREEN_RINGS, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -700, maxDamage = -1050, length = 6, spread = 4, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -850, maxDamage = -900, radius = 3, effect = CONST_ME_ICETORNADO, target = false },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -850, maxDamage = -1100, range = 7, radius = 4, effect = CONST_ME_ICEATTACK, target = true },
	{ name = "ice chain", interval = 2000, chance = 15, minDamage = -1100, maxDamage = -1300, range = 7 },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 2.45,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
