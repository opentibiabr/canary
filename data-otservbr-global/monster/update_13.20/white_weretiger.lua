local mType = Game.createMonsterType("White Weretiger")
local monster = {}

monster.description = "a White Weretiger"
monster.experience = 4860
monster.outfit = {
	lookType = 1646,
	lookHead = 0,
	lookBody = 121,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 3,
	lookMount = 0
}

monster.health = 6100
monster.maxHealth = 6100
monster.race = "undead"
monster.corpse = 43762
monster.speed = 120
monster.manaCost = 0

monster.raceId = 2387
monster.Bestiary = {
	class = "Lycanthrope",
	race = BESTY_RACE_LYCANTHROPE,
	toKill = 2500,
	FirstUnlock = 25,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 3,
	Occurrence = 0,
	Locations = "Sanctuary."
	}

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	{ name = "gold coin", chance = 12163, maxCount = 100 },
	{ name = "platinum coin", chance = 11731, maxCount = 20 },
	{ name = "weretiger tooth", chance = 13424, maxCount = 1 },
	{ name = "moonlight crystal", chance = 6838, maxCount = 1 },
	{ name = "ham", chance = 5229, maxCount = 2 },
	{ name = "beastslayer axe", chance = 9764, maxCount = 1 },
	{ name = "silver moon coin", chance = 5865, maxCount = 1 },
	{ name = "white gem", chance = 7543, maxCount = 1 },
	{ name = "blue robe", chance = 9050, maxCount = 1 },
	{ name = "moon pin", chance = 9373, maxCount = 1 },
	{ name = "crystal mace", chance = 14375, maxCount = 1 },
}

monster.attacks = {
	{ name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -480 },
	{ name ="explosion wave", interval = 2000, chance = 15, minDamage = -280, maxDamage = -400, target = false },
	{ name ="combat", interval = 2000, chance = 12, type = COMBAT_EARTHDAMAGE, minDamage = -350, maxDamage = -520, radius = 4, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_GREEN_RINGS, target = true }
}

monster.defenses = {
	defense = 83,
	armor = 83
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 60 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 40 },
	{ type = COMBAT_HOLYDAMAGE , percent = 25 },
	{ type = COMBAT_DEATHDAMAGE , percent = 0 }
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false }
}

mType:register(monster)
