local mType = Game.createMonsterType("Orc Cultist")
local monster = {}

monster.description = "an orc cultist"
monster.experience = 950
monster.outfit = {
	lookType = 7,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1503
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 1,
	Locations = "Edron Orc Cave.",
}

monster.health = 1350
monster.maxHealth = 1350
monster.race = "blood"
monster.corpse = 5979
monster.speed = 95
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
	staticAttackChance = 95,
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
	{ id = 3031, chance = 80000, maxCount = 217 }, -- gold coin
	{ id = 236, chance = 23000 }, -- strong health potion
	{ id = 7786, chance = 23000 }, -- orc tusk
	{ id = 3582, chance = 23000 }, -- ham
	{ id = 3316, chance = 23000 }, -- orcish axe
	{ id = 9057, chance = 5000, maxCount = 2 }, -- small topaz
	{ id = 5910, chance = 5000 }, -- green piece of cloth
	{ id = 9639, chance = 5000 }, -- cultish robe
	{ id = 16123, chance = 5000, maxCount = 2 }, -- brown crystal splinter
	{ id = 7439, chance = 1000 }, -- berserk potion
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	mitigation = 1.26,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
