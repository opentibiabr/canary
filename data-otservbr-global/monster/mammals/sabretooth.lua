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
	Stars = 3,
	Occurrence = 0,
	Locations = "In almost all grass areas in Tibia, also found in Rookgaard and Dawnport."
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

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "The Moon Goddess is ashamed of you!", yell = false},
}

monster.loot = {
	{id = 39546, chance = 0},
	{name = "platinum coin", chance = 100000, maxCount = 13},
	{name = "Crystal Coin", chance = 12500, maxCount = 3},
	{name = "Sabretooth Fur", chance = 13000},
	{name = "Magma Coat", chance = 12000},
	{name = "Wand of Inferno", chance = 15640},
	{name = "Wand of Dragonbreath", chance = 5980},
	{name = "Elven Amulet", chance = 2430},
	{name = "Fire Sword", chance = 9430},
	{name = "serpent sword", chance = 90},
	{name = "naga earring", chance = 13830},
	{name = "relic sword", chance = 430},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 300, maxDamage = -450, effect = CONST_ME_ORANGE_ENERGY_SPARK},
	{name ="combat", interval = 1000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -260, maxDamage = -300, length = 4, spread = 1, effect = CONST_ME_EXPLOSIONAREA, target = false},

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