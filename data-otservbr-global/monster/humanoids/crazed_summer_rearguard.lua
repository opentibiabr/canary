local mType = Game.createMonsterType("Crazed Summer Rearguard")
local monster = {}

monster.description = "a crazed summer rearguard"
monster.experience = 4700
monster.outfit = {
	lookType = 1136,
	lookHead = 114,
	lookBody = 94,
	lookLegs = 3,
	lookFeet = 121,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1733
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Court of Summer, Dream Labyrinth.",
}

monster.health = 5300
monster.maxHealth = 5300
monster.race = "blood"
monster.corpse = 30081
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Is this real life?", yell = false },
	{ text = "Weeeuuu weeeuuu!!!", yell = false },
}

monster.loot = {
	{ name = "power bolt", chance = 1000000 },
	{ name = "small enchanted sapphire", chance = 790, maxCount = 2 },
	{ name = "platinum coin", chance = 85000, maxCount = 11 },
	{ id = 5921, chance = 10500 }, -- heaven blossom
	{ name = "dream essence egg", chance = 8500 },
	{ name = "elvish talisman", chance = 7200 },
	{ name = "violet crystal shard", chance = 4500 },
	{ name = "small enchanted ruby", chance = 6000 },
	{ name = "red crystal fragment", chance = 4500 },
	{ name = "leaf star", chance = 4000, maxCount = 8 },
	{ id = 23529, chance = 2500 }, -- ring of blue plasma
	{ name = "sun fruit", chance = 890 },
	{ id = 23542, chance = 900 }, -- collar of blue plasma
	{ name = "wood cape", chance = 1300 },
	{ name = "small diamond", chance = 600 },
	{ name = "yellow gem", chance = 1000 },
	{ name = "crystal crossbow", chance = 500 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "combat", interval = 2500, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -150, maxDamage = -300, range = 6, effect = CONST_ME_FIREATTACK, target = true },
	{ name = "combat", interval = 3000, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -300, range = 6, radius = 2, effect = CONST_ME_FIREAREA, target = true },
}

monster.defenses = {
	defense = 20,
	armor = 76,
	mitigation = 2.11,
}

monster.reflects = {
	{ type = COMBAT_FIREDAMAGE, percent = 70 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 40 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -25 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
