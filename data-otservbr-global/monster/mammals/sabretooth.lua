local mType = Game.createMonsterType("Sabretooth")
local monster = {}

monster.description = "a Sabretooth"
monster.experience = 11931
monster.outfit = {
	lookType = 1549,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0
}

monster.raceId = 2267
monster.Bestiary = {
	class = "Mammal",
	race = BESTY_RACE_MAMMAL,
	toKill = 5000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 1,
	Locations = "Sparkling Pools"
}

monster.health = 17300
monster.maxHealth = 17300
monster.race = "blood"
monster.corpse = 39287
monster.speed = 182
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

monster.loot = {
	{name = "Sabretooth Fur", chance = 23640},
	{name = "Crystal Coin", chance = 23350, minCount = 1, maxCount = 2},
	{name = "Elven Amulet", chance = 5010},
	{name = "Wand of Inferno", chance = 4720},
	{name = "Dragon Necklace", chance = 3850},
	{name = "Magma Coat", chance = 3820},
	{name = "Sacred Tree Amulet", chance = 2730},
	{name = "Fire Sword", chance = 2650},
	{name = "Wand of Dragonbreath", chance = 2330},
	{name = "Metal Spats", chance = 2260},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 300, maxDamage = -450, effect = CONST_ME_ORANGE_ENERGY_SPARK},
	{name ="combat", interval = 1000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -260, maxDamage = -300, length = 4, spread = 1, effect = CONST_ME_EXPLOSIONAREA, target = false},
}

monster.defenses = {
	defense = 110,
	armor = 63,
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -10},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 10}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)