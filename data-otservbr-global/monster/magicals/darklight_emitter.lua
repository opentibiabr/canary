local mType = Game.createMonsterType("Darklight Emitter")
local monster = {}

monster.description = "a darklight emitter"
monster.experience = 55000
monster.outfit = {
	lookType = 1627,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2382
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Darklight Core",
}

monster.health = 275000
monster.maxHealth = 275000
monster.race = "undead"
monster.corpse = 43583
monster.speed = 250
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
	targetDistance = 0,
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

monster.loot = {
	{ name = "crystal coin", chance = 64330, maxCount = 3 },
	{ name = "dark obsidian splinter", chance = 10190 },
	{ name = "darklight core", chance = 10190 },
	{ name = "small sapphire", chance = 7010, maxCount = 2 },
	{ name = "blue gem", chance = 640 },
	{ name = "twiceslicer", chance = 640 },
	{ name = "white gem", chance = 640 },
	{ id = 43895, chance = 1 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -2200, maxDamage = -4250 },
	{ name = "combat", interval = 2600, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -2200, maxDamage = -4750, length = 8, spread = 3, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 3100, chance = 20, type = COMBAT_HOLYDAMAGE, minDamage = -2400, maxDamage = -4900, length = 8, spread = 3, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "combat", interval = 2600, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -2500, maxDamage = -4550, radius = 5, effect = CONST_ME_HITBYFIRE, target = true },
	{ name = "largefirering", interval = 2000, chance = 10, minDamage = -2100, maxDamage = -4400, target = false },
}

monster.defenses = {
	defense = 120,
	armor = 120,
	mitigation = 3.04,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 5 },
	{ type = COMBAT_FIREDAMAGE, percent = 40 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 25 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
