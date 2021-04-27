local mType = Game.createMonsterType("Crypt Defiler")
local monster = {}

monster.description = "a crypt defiler"
monster.experience = 70
monster.outfit = {
	lookType = 146,
	lookHead = 115,
	lookBody = 115,
	lookLegs = 61,
	lookFeet = 96,
	lookAddons = 3,
	lookMount = 0
}

monster.raceId = 868
monster.Bestiary = {
	class = "Human",
	race = dafasdfasdfsadfasdfasd,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 2,
	Locations = "Horestis Tomb."
	}

monster.health = 185
monster.maxHealth = 185
monster.race = "blood"
monster.corpse = 20359
monster.speed = 190
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
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 15,
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
	{text = "I smell gold!", yell = false},
	{text = "You'll make a fine fake-mummy to be sold!", yell = false},
	{text = "Untold riches are awaiting me!", yell = false},
	{text = "I don't like competition!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 50900, maxCount = 39},
	{name = "axe", chance = 2730},
	{name = "mace", chance = 1800},
	{name = "iron helmet", chance = 450},
	{name = "brass armor", chance = 2240},
	{name = "steel shield", chance = 450},
	{name = "nomad parchment", chance = 220},
	{name = "potato", chance = 4840, maxCount = 3},
	{name = "dirty turban", chance = 1570},
	{name = "rope belt", chance = 4040}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -90},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -40, range = 7, radius = 1, shootEffect = CONST_ANI_THROWINGSTAR, target = true}
}

monster.defenses = {
	defense = 15,
	armor = 15
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -5},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
