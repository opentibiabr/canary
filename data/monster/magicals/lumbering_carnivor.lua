local mType = Game.createMonsterType("Lumbering Carnivor")
local monster = {}

monster.description = "a Lumbering Carnivor"
monster.experience = 1452
monster.outfit = {
	lookType = 1133,
	lookHead = 0,
	lookBody = 39,
	lookLegs = 86,
	lookFeet = 85,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1721
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Carnivora's Rocks."
	}

monster.health = 2600
monster.maxHealth = 2600
monster.race = "blood"
monster.corpse = 34703
monster.speed = 400
monster.manaCost = 0
monster.maxSummons = 0

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
}

monster.loot = {
	{name = "platinum coin", chance = 100000, maxCount = 5},
	{name = "Blue Glass Plate", chance = 100000, maxCount = 3},
	{id = 2376, chance = 15000},
	{name = "Axe", chance = 14000},
	{name = "Ice Rapier", chance = 12000},
	{name = "Glorious Axe", chance = 6100},
	{name = "Blue Robe", chance = 4600},
	{name = "Two Handed Sword", chance = 13000},
	{name = "Fur Armor", chance = 5400},
	{id = 7632, chance = 3200},
	{name = "Green Crystal Shard", chance = 3100},
	{name = "Violet Gem", chance = 4000},
	{name = "Green Gem", chance = 4800},
	{name = "Blue Gem", chance = 4000},
	{name = "Focus Cape", chance = 3000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -500},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -150, radius = 4, effect = CONST_ME_GROUNDSHAKER, target = false}
}

monster.defenses = {
	defense = 20,
	armor = 71,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 20},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
