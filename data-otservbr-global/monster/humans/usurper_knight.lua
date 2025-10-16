local mType = Game.createMonsterType("Usurper Knight")
local monster = {}

monster.description = "an usurper knight"
monster.experience = 6900
monster.outfit = {
	lookType = 1316,
	lookHead = 76,
	lookBody = 57,
	lookLegs = 76,
	lookFeet = 95,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 1972
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Bounac, the Order of the Lion settlement.",
}

monster.health = 8200
monster.maxHealth = 8200
monster.race = "blood"
monster.corpse = 33977
monster.speed = 130
monster.manaCost = 0

monster.faction = FACTION_LIONUSURPERS
monster.enemyFactions = { FACTION_PLAYER, FACTION_LION }

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	{ text = "This town is ours now!", yell = false },
	{ text = "Do you really think you can stand?", yell = false },
	{ text = "You don't deserve Bounac!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 3559, chance = 80000 }, -- leather legs
	{ id = 3371, chance = 23000 }, -- knight legs
	{ id = 3036, chance = 23000 }, -- violet gem
	{ id = 34162, chance = 23000 }, -- lion cloak patch
	{ id = 3577, chance = 23000 }, -- meat
	{ id = 34160, chance = 23000 }, -- lion crest
	{ id = 238, chance = 5000 }, -- great mana potion
	{ id = 9058, chance = 5000 }, -- gold ingot
	{ id = 3041, chance = 5000 }, -- blue gem
	{ id = 3038, chance = 5000 }, -- green gem
	{ id = 821, chance = 5000 }, -- magma legs
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", interval = 6000, chance = 14, type = COMBAT_DEATHDAMAGE, minDamage = -150, maxDamage = -300, radius = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 6000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -150, maxDamage = -400, length = 4, spread = 0, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "singlecloudchain", interval = 8000, chance = 17, minDamage = -200, maxDamage = -450, range = 4, effect = CONST_ME_ENERGYHIT, target = true },
}

monster.defenses = {
	defense = 86,
	armor = 83,
	mitigation = 2.40,
	{ name = "combat", interval = 4000, chance = 40, type = COMBAT_HEALING, minDamage = 200, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 35 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = -15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
