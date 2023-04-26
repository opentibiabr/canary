local mType = Game.createMonsterType("Sulphider")
local monster = {}

monster.description = "a Sulphider"
monster.experience = 13328
monster.outfit = {
	lookType = 1546,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0
}

monster.raceId = 2264
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 5000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 1,
	Locations = "Monster Graveyard"
}

monster.health = 21000
monster.maxHealth = 21000
monster.race = "blood"
monster.corpse = 39275
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
	{text = "Tikkee...Takka...", yell = false},
}

monster.loot = {
	{name = "Sulphur Powder", chance = 29600},
	{name = "Sulphider Shell", chance = 24660},
	{name = "Ultimate Mana Potion", chance = 14620},
	{name = "Crystal Coin", chance = 14430, minCount = 1, maxCount = 3},
	{name = "White Pearl", chance = 5010},
	{name = "Fire Axe", chance = 2450},
	{name = "Magma Boots", chance = 1600},
	{name = "Crown Shield", chance = 1230},
	{name = "Amber Staff", chance = 1150},
	{name = "Amulet of Loss", chance = 850}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 300, maxDamage = -801},
	{name ="combat", interval = 3000, chance = 47, type = COMBAT_PHYSICALDAMAGE, minDamage = -800, maxDamage = -1500, effect = CONST_ME_YELLOWSMOKE, target = true},
	{name ="combat", interval = 4000, chance = 31, type = COMBAT_LIFEDRAIN, minDamage = -800, maxDamage = -1500, radius = 4, effect = CONST_ME_DRAWBLOOD, target = false},
}

monster.defenses = {
	defense = 110,
	armor = 83,
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 20},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -20},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)