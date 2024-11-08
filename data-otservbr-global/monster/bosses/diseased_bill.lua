local mType = Game.createMonsterType("Diseased Bill")
local monster = {}

monster.description = "Diseased Bill"
monster.experience = 300
monster.outfit = {
	lookType = 299,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"DiseasedTrioDeath",
}

monster.bosstiary = {
	bossRaceId = 485,
	bossRace = RARITY_BANE,
}

monster.health = 1000
monster.maxHealth = 1000
monster.race = "venom"
monster.corpse = 8123
monster.speed = 75
monster.manaCost = 0

monster.changeTarget = {
	interval = 60000,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 1,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 4,
	color = 30,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "People like you are the plague and I'll be the cure!", yell = false },
	{ text = "You all will pay for not helping me!", yell = false },
	{ text = "Cough! Cough!", yell = false },
	{ text = "Desolate! Everything is so desolate!", yell = false },
}

monster.loot = {
	{ name = "gold coin", chance = 28000, maxCount = 20 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -207, condition = { type = CONDITION_POISON, totalDamage = 4, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_LIFEDRAIN, minDamage = -90, maxDamage = -140, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", interval = 1000, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -175, radius = 2, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "speed", interval = 3000, chance = 40, speedChange = -900, effect = CONST_ME_MAGIC_RED, target = true, duration = 20000 },
}

monster.defenses = {
	defense = 15,
	armor = 10,
	--	mitigation = ???,
	{ name = "speed", interval = 10000, chance = 40, speedChange = 310, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 20000 },
	{ name = "combat", interval = 5000, chance = 60, type = COMBAT_HEALING, minDamage = 50, maxDamage = 80, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 25 },
	{ type = COMBAT_HOLYDAMAGE, percent = 25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 75 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
