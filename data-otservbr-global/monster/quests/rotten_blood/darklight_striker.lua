local mType = Game.createMonsterType("Darklight Striker")
local monster = {}

monster.description = "a Darklight Striker"
monster.experience = 20550
monster.outfit = {
	lookType = 1661,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 29700
monster.maxHealth = 29700
monster.race = "undead"
monster.corpse = 43844
monster.speed = 220
monster.manaCost = 0

monster.raceId = 2399
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 5000,
	FirstUnlock = 25,
	SecondUnlock = 3394,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Sanctuary.",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	runHealth = 800,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {}

monster.loot = {
	{ name = "crystal coin", chance = 14380, maxCount = 1 },
	{ name = "unstable darklight matter", chance = 14492, maxCount = 1 },
	{ name = "darklight core", chance = 9783, maxCount = 1 },
	{ name = "small topaz", chance = 11140, maxCount = 3 },
	{ name = "ice rapier", chance = 5104, maxCount = 1 },
	{ name = "dark obsidian splinter", chance = 14185, maxCount = 1 },
	{ name = "blue gem", chance = 7355, maxCount = 1 },
	{ name = "crystal mace", chance = 8812, maxCount = 1 },
	{ name = "zaoan helmet", chance = 5572, maxCount = 1 },
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 17, type = COMBAT_ICEDAMAGE, minDamage = -600, maxDamage = -1100, range = 7, shootEffect = CONST_ANI_FLASHARROW, effect = CONST_ME_GROUNDSHAKER, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HOLYDAMAGE, minDamage = -700, maxDamage = -1100, range = 7, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_HOLYDAMAGE, target = true },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_HOLYDAMAGE, minDamage = -650, maxDamage = -900, radius = 4, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_ICEDAMAGE, minDamage = -600, maxDamage = -1000, range = 7, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICETORNADO, target = true },
}

monster.defenses = {
	defense = 112,
	armor = 112,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 35 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
