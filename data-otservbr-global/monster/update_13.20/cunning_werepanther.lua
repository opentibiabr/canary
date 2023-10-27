local mType = Game.createMonsterType("Cunning Werepanther")
local monster = {}

monster.description = "a Cunning Werepanther"
monster.experience = 3620
monster.outfit = {
	lookType = 1648,
	lookHead = 18,
	lookBody = 124,
	lookLegs = 74,
	lookFeet = 81,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 4300
monster.maxHealth = 4300
monster.race = "undead"
monster.corpse = 43959
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.raceId = 2403
monster.Bestiary = {
	class = "Lycanthrope",
	race = BESTY_RACE_LYCANTHROPE,
	toKill = 2500,
	FirstUnlock = 25,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
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
	runHealth = 0,
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
	{ name = "gold coin", chance = 2506, maxCount = 1 },
	{ name = "platinum coin", chance = 2506, maxCount = 1 },
	{ name = "golden sickle", chance = 1948, maxCount = 1 },
	{ name = "moonlight crystals", chance = 2078, maxCount = 1 },
	{ name = "werepanther claw", chance = 2546, maxCount = 1 },
	{ name = "lightning pendant", chance = 2455, maxCount = 1 },
	{ name = "lightning headband", chance = 3401, maxCount = 1 },
	{ name = "yellow gem", chance = 3495, maxCount = 1 },
	{ name = "meat", chance = 2546, maxCount = 1 },
	{ name = "small topaz", chance = 2546, maxCount = 1 },
	{ name = "ripper lance", chance = 1681, maxCount = 1 },
	{ name = "gemmed figurine", chance = 1657, maxCount = 1 },
}

monster.attacks = {
	{ name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name ="combat", interval = 2000, chance = 18, type = COMBAT_EARTHDAMAGE, minDamage = -400, maxDamage = -500, radius = 2, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name ="combat", interval = 2000, chance = 14, type = COMBAT_HOLYDAMAGE, minDamage = -290, maxDamage = -360, length = 5, spread = 3, effect = CONST_ME_BLOCKHIT, target = false }
}

monster.defenses = {
	defense = 100,
	armor = 72
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
	{ type = COMBAT_HOLYDAMAGE , percent = 25 },
	{ type = COMBAT_DEATHDAMAGE , percent = -20 }
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false }
}

mType:register(monster)
