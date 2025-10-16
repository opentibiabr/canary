local mType = Game.createMonsterType("Liodile")
local monster = {}

monster.description = "a liodile"
monster.experience = 6860
monster.outfit = {
	lookType = 1602,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2338
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Ingol",
}

monster.health = 8600
monster.maxHealth = 8600
monster.race = "blood"
monster.corpse = 42214
monster.speed = 165
monster.manaCost = 0

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
	illusionable = true,
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
	{ text = "Growl!", yell = false },
	{ text = "Meat!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 3029, chance = 23000 }, -- small sapphire
	{ id = 16121, chance = 23000 }, -- green crystal shard
	{ id = 812, chance = 5000 }, -- terra legs
	{ id = 3037, chance = 5000 }, -- yellow gem
	{ id = 7404, chance = 5000 }, -- assassin dagger
	{ id = 7642, chance = 5000 }, -- great spirit potion
	{ id = 8084, chance = 5000 }, -- springsprout rod
	{ id = 40583, chance = 5000 }, -- liodile fang
	{ id = 9302, chance = 1000 }, -- sacred tree amulet
	{ id = 9303, chance = 1000 }, -- leviathans amulet
	{ id = 48055, chance = 80000 }, -- liodile soul core
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500 },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_EARTHDAMAGE, minDamage = -325, maxDamage = -400, range = 7, shootEffect = CONST_ANI_POISONARROW, target = true },
	{ name = "combat", interval = 2000, chance = 34, type = COMBAT_PHYSICALDAMAGE, minDamage = -300, maxDamage = -400, range = 2, effect = CONST_ME_GROUNDSHAKER, target = true },
}

monster.defenses = {
	defense = 50,
	armor = 71,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
