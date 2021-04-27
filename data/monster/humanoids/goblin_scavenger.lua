local mType = Game.createMonsterType("Goblin Scavenger")
local monster = {}

monster.description = "a goblin scavenger"
monster.experience = 37
monster.outfit = {
	lookType = 297,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 464
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Femor Hills, Edron Goblin Cave, and Fenrock."
	}

monster.health = 60
monster.maxHealth = 60
monster.race = "blood"
monster.corpse = 6002
monster.speed = 132
monster.manaCost = 310
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 10,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Shiny, shiny!", yell = false},
	{text = "Gimme gimme!", yell = false},
	{text = "You mean!", yell = false},
	{text = "All mine!", yell = false},
	{text = "Uhh!", yell = false}
}

monster.loot = {
	{name = "small stone", chance = 25560, maxCount = 2},
	{name = "gold coin", chance = 50810, maxCount = 9},
	{id = 2230, chance = 12450},
	{name = "mouldy cheese", chance = 7000},
	{name = "dagger", chance = 18280},
	{name = "short sword", chance = 8900},
	{name = "bone club", chance = 5000},
	{name = "leather helmet", chance = 10180},
	{name = "leather armor", chance = 7700},
	{name = "small axe", chance = 9790},
	{id = 2667, chance = 13640}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -15},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -30, range = 7, shootEffect = CONST_ANI_SPEAR, target = false},
	{name ="combat", interval = 2000, chance = 5, type = COMBAT_LIFEDRAIN, minDamage = -22, maxDamage = -30, range = 7, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="combat", interval = 2000, chance = 5, type = COMBAT_DEATHDAMAGE, minDamage = -1, maxDamage = -30, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = false}
}

monster.defenses = {
	defense = 15,
	armor = 15,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 10, maxDamage = 16, effect = CONST_ME_ENERGYHIT, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 1},
	{type = COMBAT_DEATHDAMAGE , percent = -10}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
