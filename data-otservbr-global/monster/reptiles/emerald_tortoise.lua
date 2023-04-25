local mType = Game.createMonsterType("Emerald Tortoise")
local monster = {}

monster.description = "a Emerald Tortoise"
monster.experience = 12192
monster.outfit = {
	lookType = 1550,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0
}

monster.health = 22300
monster.maxHealth = 22300
monster.race = "blood"
monster.corpse = 39291
monster.speed = 179
monster.manaCost = 0
monster.maxSummons = 0

monster.raceId = 2268
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 5000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 100,
	Stars = 3,
	Occurrence = 0,
	Locations = "Sea Serpent Area and Seacrest Grounds."
}

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Shllpp...", yell = false},
}

monster.loot = {
	{id = 39546, chance = 0},
	{name = "crystal coin", chance = 21000, maxCount = 3},
	{name = "great spirit potion", chance = 19000, maxCount = 3},
	{name = "orichalcum pearl", chance = 15000, maxCount = 2},
	{name = "yellow gem", chance = 14300},
	{name = "green crystal shard", chance = 11980},
	{name = "blue crystal shard", chance = 15800},
	{name = "violet gem", chance = 13430},
	{name = "red crystal fragment", chance = 13500},
	{name = "green crystal fragment", chance = 12580},
	{name = "emerald tortoise shell", chance = 14500},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 450, maxDamage = -500},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -500, range = 5, shootEffect = CONST_ANI_ENERGY, target = true},
	{name ="lavafungus ring", interval = 2000, chance = 20, minDamage = -600, maxDamage = -650},
}

monster.defenses = {
	defense = 110,
	armor = 120,
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 20},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = -5},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = -20},
	{type = COMBAT_DEATHDAMAGE , percent = 10}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)