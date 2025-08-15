local mType = Game.createMonsterType("Guardian of Tales")
local monster = {}

monster.description = "a guardian of tales"
monster.experience = 10600
monster.outfit = {
	lookType = 1063,
	lookHead = 92,
	lookBody = 52,
	lookLegs = 0,
	lookFeet = 79,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 1659
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Secret Library (fire section).",
}

monster.health = 15000
monster.maxHealth = 15000
monster.race = "ink"
monster.corpse = 28770
monster.speed = 210
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
}

monster.loot = {
	{ name = "platinum coin", chance = 10000, maxCount = 10 },
	{ name = "book page", chance = 10000, maxCount = 5 },
	{ name = "burnt scroll", chance = 10000, maxCount = 5 },
	{ name = "glowing rune", chance = 10000, maxCount = 5 },
	{ name = "small diamond", chance = 10000, maxCount = 5 },
	{ name = "fire axe", chance = 250 },
	{ name = "soul orb", chance = 260, maxCount = 5 },
	{ name = "spellbook of warding", chance = 250 },
	{ name = "wand of inferno", chance = 250 },
	{ name = "fire sword", chance = 250 },
	{ name = "magma coat", chance = 350 },
	{ name = "magma legs", chance = 250 },
	{ name = "piece of hellfire armor", chance = 500, maxCount = 5 },
	{ id = 12600, chance = 10000, maxCount = 5 }, -- coal
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -550 },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -605, radius = 3, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -375, maxDamage = -500, length = 5, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_FIREDAMAGE, minDamage = -400, maxDamage = -775, radius = 3, effect = CONST_ME_HITBYFIRE, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 77,
	mitigation = 1.94,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -12 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
