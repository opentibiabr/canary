local mType = Game.createMonsterType("Werecrocodile")
local monster = {}

monster.description = "a werecrocodile"
monster.experience = 3900
monster.outfit = {
	lookType = 1647,
	lookHead = 95,
	lookBody = 117,
	lookLegs = 4,
	lookFeet = 116,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 5280
monster.maxHealth = 5280
monster.race = "undead"
monster.corpse = 43754
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.raceId = 2388
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 2500,
	FirstUnlock = 25,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 3,
	Occurrence = 0,
	Locations = "Sanctuary."
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
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {

}

monster.loot = {
	{ name = "gold coin", chance = 13548, maxCount = 100 },
	{ name = "platinum coin", chance = 12875, maxCount = 13 },
	{ name = "werecrocodile tongue", chance = 11692, maxCount = 1 },
	{ name = "serpent sword", chance = 6694, maxCount = 1 },
	{ name = "crocodile boots", chance = 6240, maxCount = 1 },
	{ name = "meat", chance = 12266, maxCount = 4 },
	{ id = 3039, chance = 14768, maxCount = 1 }, -- red gem
	{ name = "moonlight crystals", chance = 13193, maxCount = 1 },
	{ name = "green crystal shard", chance = 11106, maxCount = 1 },
	{ name = "glorious axe", chance = 13477, maxCount = 1 },
	{ name = "golden sun coin", chance = 8290, maxCount = 1 },
	{ name = "bonebreaker", chance = 9200, maxCount = 1 },
	{ name = "werecrocodile trophy", chance = 13176, maxCount = 1 },
}

monster.attacks = {
	{ name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500, effect = CONST_ME_DRAWBLOOD },
	{ name ="combat", interval = 6000, chance = 9, type = COMBAT_DEATHDAMAGE, minDamage = -150, maxDamage = -300, radius = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name ="combat", interval = 6000, chance = 13, type = COMBAT_ICEDAMAGE, minDamage = -150, maxDamage = -400, length = 4, spread = 0, effect = CONST_ME_ICEATTACK, target = false },
	}

monster.defenses = {
	defense = 82,
	armor = 82
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 25 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 35 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE , percent = -20 },
	{ type = COMBAT_DEATHDAMAGE , percent = 60 }
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false }
}

mType:register(monster)
