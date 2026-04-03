local mType = Game.createMonsterType("Spirit Overlord")
local monster = {}

monster.description = "Spirit Overlord"
monster.experience = 2800
monster.outfit = {
	lookType = 1840,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"ElementalOverlordDeath",
}

monster.health = 4000
monster.maxHealth = 4000
monster.race = "undead"
monster.corpse = 8105
monster.speed = 165
monster.manaCost = 0

monster.changeTarget = {
	interval = 20000,
	chance = 30,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 1,
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
}

monster.loot = {
	{ name = "gold coin", chance = 44000, maxCount = 120 },
	{ name = "platinum coin", chance = 29000, maxCount = 3 },
	{ name = "holy ash", chance = 10800 },
	{ name = "great spirit potion", chance = 8750, maxCount = 2 },
	{ name = "moonlight rod", chance = 8300 },
	{ name = "spirited soil", chance = 7000 },
	{ name = "holy orchid", chance = 6000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -800, length = 7, spread = 0, effect = CONST_ME_STONES, target = false },
	{ name = "combat", interval = 1000, chance = 9, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -490, radius = 6, effect = CONST_ME_BIGPLANTS, target = false },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -750, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000 },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
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
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
