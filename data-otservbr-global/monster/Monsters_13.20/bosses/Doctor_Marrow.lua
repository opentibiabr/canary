local mType = Game.createMonsterType("Doctor Marrow")
local monster = {}

monster.description = "doctor marrow"
monster.experience = 65000
monster.outfit = {
	lookType = 1611,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 175000
monster.maxHealth = 175000
monster.race = "undead"
monster.corpse = 0
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 20
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
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.events = {
}

monster.light = {
	level = 0,
	color = 0
}

monster.summon = {
}

monster.voices = {
}

monster.loot = {
}

monster.attacks = {
	{ name ="melee", interval = 2000, chance = 100, minDamage = -270, maxDamage = -700 },
	{ name ="combat", interval = 2000, chance = 70, type = COMBAT_EARTHDAMAGE, minDamage = -1000, maxDamage = -1400, length = 7, spread = 0, effect = CONST_ME_SMALLPLANTS, target = false },
	{ name ="combat", interval = 2000, chance = 17, type = COMBAT_PHYSICALDAMAGE, minDamage = -500, maxDamage = -1200, radius = 5, effect = 252, target = false },
	{ name ="combat", interval = 2000, chance = 17, type = COMBAT_ICEDAMAGE, minDamage = -500, maxDamage = -900, radius = 2, effect = 243, target = false },
	{ name ="stone shower rune", interval = 2000, chance = 10, minDamage = -230, maxDamage = -450, range = 7, target = false }
}

monster.defenses = {
	defense = 105,
	armor = 105,
	{ name ="combat", interval = 3000, chance = 15, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 2000, effect = 236, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE , percent = 15 },
	{ type = COMBAT_DEATHDAMAGE , percent = 15 }
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false }
}

mType:register(monster)