local mType = Game.createMonsterType("Many Faces")
local monster = {}

monster.description = "a many faces"
monster.experience = 18870
monster.outfit = {
	lookType = 1296,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1927
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Mirrored Nightmare.",
}

monster.events = {
	"FourthTaintBossesPrepareDeath",
}

monster.health = 30000
monster.maxHealth = 30000
monster.race = "undead"
monster.corpse = 33805
monster.speed = 215
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
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
	{ text = "I have a head start.", yell = false },
	{ text = "Look into my eyes! No, the other ones!", yell = false },
	{ text = "The mirrors can't contain the night!", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 7643, chance = 23000 }, -- ultimate health potion
	{ id = 33933, chance = 23000 }, -- apron
	{ id = 3067, chance = 5000 }, -- hailstorm rod
	{ id = 3036, chance = 5000 }, -- violet gem
	{ id = 3038, chance = 5000 }, -- green gem
	{ id = 3041, chance = 5000 }, -- blue gem
	{ id = 8083, chance = 5000 }, -- northwind rod
	{ id = 9302, chance = 5000 }, -- sacred tree amulet
	{ id = 819, chance = 5000 }, -- glacier shoes
	{ id = 824, chance = 5000 }, -- glacier robe
	{ id = 3081, chance = 5000 }, -- stone skin amulet
	{ id = 23533, chance = 5000 }, -- ring of red plasma
	{ id = 16118, chance = 1000 }, -- glacial rod
	{ id = 34024, chance = 1000 }, -- gruesome fan
	{ id = 34109, chance = 260 }, -- bag you desire
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1300 },
	{ name = "combat", interval = 4000, chance = 33, type = COMBAT_ICEDAMAGE, minDamage = -1220, maxDamage = -1400, range = 7, shootEffect = CONST_ANI_SNOWBALL, effect = CONST_ME_ICEATTACK, target = true },
	{ name = "combat", interval = 5000, chance = 44, type = COMBAT_ICEDAMAGE, minDamage = -1000, maxDamage = -1450, range = 7, radius = 5, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = true },
	{ name = "combat", interval = 9500, chance = 59, type = COMBAT_HOLYDAMAGE, minDamage = -1050, maxDamage = -1300, radius = 4, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "extended holy chain", interval = 10000, chance = 59, minDamage = -1150, maxDamage = -1300, range = 7 },
	{ name = "destroy magic walls", interval = 1000, chance = 30 },
}

monster.defenses = {
	defense = 105,
	armor = 105,
	mitigation = 3.34,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = -30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onThink = function(monster, interval)
	monster:tryTeleportToPlayer("Hands off my comrades!")
end

mType:register(monster)
