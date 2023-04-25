local mType = Game.createMonsterType("Gorerilla")
local monster = {}

monster.description = "a Gorerilla"
monster.experience = 13172
monster.outfit = {
	lookType = 1559,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0
}

monster.raceId = 2277
monster.Bestiary = {
	class = "Mammal",
	race = BESTY_RACE_MAMMAL,
	toKill = 5000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 100,
	Stars = 3,
	Occurrence = 0,
	Locations = "Sea Serpent Area and Seacrest Grounds."
}

monster.health = 16850
monster.maxHealth = 16850
monster.race = "blood"
monster.corpse = 39327
monster.speed = 215
monster.manaCost = 0
monster.maxSummons = 0


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
	{text = "The Moon Goddess is ashamed of you!", yell = false},
}

monster.loot = {
	{id = 39546, chance = 0},
	{name = "Crystal Coin", chance = 10000, maxCount = 3},
	{name = "Doublet", chance = 7730},
	{name = "Ultimate Mana Potion", chance = 10000, maxCount = 5},
	{name = "Gorerilla Mane", chance = 5430},
	{name = "Gorerilla Tail", chance = 15640},
	{name = "Magma Coat", chance = 1980},
	{name = "Crystal Crossbow", chance = 430},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 300, maxDamage = -801},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 250, maxDamage = -360, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = true},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_FIREDAMAGE, minDamage = -1, maxDamage = -1, range = 5, radius = 3, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREATTACK, target = true},
}

monster.defenses = {
	defense = 76,
	armor = 76,
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