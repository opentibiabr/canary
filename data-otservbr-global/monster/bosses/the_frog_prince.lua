local mType = Game.createMonsterType("The Frog Prince")
local monster = {}

monster.description = "The Frog Prince"
monster.experience = 1
monster.outfit = {
	lookType = 224,
	lookHead = 69,
	lookBody = 66,
	lookLegs = 69,
	lookFeet = 66,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 420,
	bossRace = RARITY_NEMESIS,
}

monster.health = 55
monster.maxHealth = 55
monster.race = "venom"
monster.corpse = 6079
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 20,
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
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Don't Kill me!!!", yell = false },
	{ text = "Have mercy!", yell = false },
	{ text = "Perhaps a kiss might release me!", yell = false },
}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 10, attack = 1 },
}

monster.defenses = {
	defense = 2,
	armor = 3,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 98 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 90 },
	{ type = COMBAT_EARTHDAMAGE, percent = 80 },
	{ type = COMBAT_FIREDAMAGE, percent = 90 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 90 },
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
