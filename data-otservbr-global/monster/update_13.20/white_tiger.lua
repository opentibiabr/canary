local mType = Game.createMonsterType("White Tiger")
local monster = {}

monster.description = "a White Tiger"
monster.experience = 40
monster.outfit = {
	lookType = 1649,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 75
monster.maxHealth = 75
monster.race = "undead"
monster.corpse = 43771
monster.speed = 110
monster.manaCost = 0

monster.raceId = 2387
monster.Bestiary = {
	class = "Mammals",
	race = BESTY_RACE_MAMMALS,
	toKill = 250,
	FirstUnlock = 10,
	SecondUnlock = 100,
	CharmsPoints = 15,
	Stars = 2,
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
	{ name = "meat", chance = 8433, maxCount = 3 },
	{ name = "striped fur", chance = 10077, maxCount = 3 },
}

monster.attacks = {
	{ name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -480 },
	{ name ="explosion wave", interval = 2000, chance = 15, minDamage = -280, maxDamage = -400, target = false },
	{ name ="combat", interval = 2000, chance = 12, type = COMBAT_EARTHDAMAGE, minDamage = -350, maxDamage = -520, radius = 4, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_GREEN_RINGS, target = true }
}

monster.defenses = {
	defense = 83,
	armor = 12
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
