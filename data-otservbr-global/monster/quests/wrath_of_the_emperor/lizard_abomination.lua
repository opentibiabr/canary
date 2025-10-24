local mType = Game.createMonsterType("Lizard Abomination")
local monster = {}

monster.description = "a lizard abomination"
monster.experience = 9700
monster.outfit = {
	lookType = 364,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"ZalamonDeath",
}

monster.health = 95000
monster.maxHealth = 95000
monster.race = "blood"
monster.corpse = 0
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
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
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 4,
	color = 113,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "NOOOO! NOW YOU HERETICS WILL FACE MY GODLY WRATH!", yell = true },
	{ text = "RAAARRRR! I WILL DEVOL YOU!", yell = true },
	{ text = "I WILL MAKE YOU ZHEE!", yell = true },
}

monster.loot = {

}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550 },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -980, radius = 3, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_LIFEDRAIN, minDamage = -200, maxDamage = -300, length = 8, spread = 3, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "speed", interval = 2000, chance = 20, radius = 3, effect = CONST_ME_POISONAREA, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 55,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 50, maxDamage = 350, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
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
