local mType = Game.createMonsterType("Thawing Dragon Lord")
local monster = {}

monster.description = "a thawing dragon lord"
monster.experience = 2100
monster.outfit = {
	lookType = 1077,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1585,
	bossRace = RARITY_BANE,
}

monster.health = 25000
monster.maxHealth = 25000
monster.race = "fire"
monster.corpse = 28639
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	rewardBoss = true,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
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
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 9058, chance = 50000, maxCount = 4 }, -- gold ingot
	{ id = 7741, chance = 5560 }, -- ice cube
	{ id = 7377, chance = 5560 }, -- ice cream cone
	{ id = 14112, chance = 50 }, -- bar of gold
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{ name = "ice crystal bomb", interval = 2000, chance = 30, minDamage = -600, maxDamage = -700, target = true },
	{ name = "fire wave", interval = 2000, chance = 30, minDamage = -800, maxDamage = -1200, length = 1, spread = 1, effect = CONST_ME_FIREAREA, target = true },
	{ name = "speed", interval = 1000, chance = 12, speedChange = -250, radius = 6, effect = CONST_ME_HITBYFIRE, target = false, duration = 60000 },
	{ name = "firefield", interval = 1000, chance = 10, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, target = true },
}

monster.defenses = {
	defense = 40,
	armor = 80,
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
