local mType = Game.createMonsterType("Tainted Soul")
local monster = {}

monster.description = "a tainted soul"
monster.experience = 0
monster.outfit = {
	lookType = 712,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1137
monster.Bestiary = {
	class = "Fey",
	race = BESTY_RACE_FEY,
	toKill = 250,
	FirstUnlock = 10,
	SecondUnlock = 100,
	CharmsPoints = 5,
	Stars = 1,
	Occurrence = 0,
	Locations = "Around venore."
	}

monster.health = 250
monster.maxHealth = 250
monster.race = "undead"
monster.corpse = 21977
monster.speed = 85
monster.manaCost = 0

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
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 15,
	targetDistance = 7,
	runHealth = 115,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "*Crinkle*", yell = false},
	{text = "*Sizzle*", yell = false}
}

monster.loot = {
	{name = "small ruby", chance = 1000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -10},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -15, maxDamage = -37, range = 1, effect = CONST_ME_MAGIC_RED, target = true}
}

monster.defenses = {
	defense = 10,
	armor = 10,
	{name ="speed", interval = 2000, chance = 15, speedChange = 200, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000},
	{name ="combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 15, maxDamage = 25, effect = CONST_ME_MAGIC_GREEN, target = false},
	{name ="invisible", interval = 2000, chance = 10, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 3000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 50},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
