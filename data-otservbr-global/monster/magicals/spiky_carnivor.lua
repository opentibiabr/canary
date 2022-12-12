local mType = Game.createMonsterType("Spiky Carnivor")
local monster = {}

monster.description = "a Spiky Carnivor"
monster.experience = 1650
monster.outfit = {
	lookType = 1139,
	lookHead = 79,
	lookBody = 121,
	lookLegs = 23,
	lookFeet = 86,
	lookAddons = 1,
	lookMount = 0
}

monster.raceId = 1722
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Carnivora's Rocks."
	}

monster.health = 2800
monster.maxHealth = 2800
monster.race = "blood"
monster.corpse = 30099
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	canWalkOnFire = false,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{name = "platinum coin", chance = 100000, maxCount = 6},
	{name = "green glass plate", chance = 12000, maxCount = 17},
	{name = "blue crystal splinter", chance = 11500},
	{name = "brown crystal splinter", chance = 11000},
	{name = "dark armor", chance = 10000},
	{name = "guardian shield", chance = 9000},
	{name = "rainbow quartz", chance = 8500},
	{name = "blue robe", chance = 8000},
	{name = "glacier amulet", chance = 7500},
	{name = "lightning pendant", chance = 2200},
	{name = "prismatic quartz", chance = 6500},
	{name = "talon", chance = 6000},
	{name = "terra amulet", chance = 5500},
	{name = "warrior helmet", chance = 4000},
	{name = "shockwave amulet", chance = 2550},
	{name = "terra mantle", chance = 4050},
	{name = "buckle", chance = 250},
	{name = "doublet", chance = 250}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -400},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -230, maxDamage = -380, radius = 4, effect = CONST_ME_GROUNDSHAKER, target = false}
}

monster.defenses = {
	defense = 20,
	armor = 71,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.reflects = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 50}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 40},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = -30},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
