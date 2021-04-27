local mType = Game.createMonsterType("Chakoya Toolshaper")
local monster = {}

monster.description = "a chakoya toolshaper"
monster.experience = 40
monster.outfit = {
	lookType = 259,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 328
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Inukaya, Chyllfroest, Chakoya Iceberg."
	}

monster.health = 80
monster.maxHealth = 80
monster.race = "blood"
monster.corpse = 7320
monster.speed = 136
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 60000,
	chance = 0
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
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Chikuva!", yell = false},
	{text = "Jinuma jamjam!", yell = false},
	{text = "Suvituka siq chuqua!", yell = false},
	{text = "Kiyosa sipaju!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 77810, maxCount = 20},
	{name = "mace", chance = 5300},
	{name = "bone shield", chance = 720},
	{id = 2553, chance = 1100},
	{id = 2667, chance = 25060, maxCount = 2},
	{name = "northern pike", chance = 70},
	{name = "rainbow trout", chance = 140},
	{name = "green perch", chance = 70},
	{name = "mammoth whopper", chance = 160},
	{id = 7441, chance = 450},
	{name = "fireproof horn", chance = 390}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -35},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -45, range = 7, radius = 3, shootEffect = CONST_ANI_SMALLSTONE, target = true}
}

monster.defenses = {
	defense = 10,
	armor = 10
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -15},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 40},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 100},
	{type = COMBAT_HOLYDAMAGE , percent = 10},
	{type = COMBAT_DEATHDAMAGE , percent = -5}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
