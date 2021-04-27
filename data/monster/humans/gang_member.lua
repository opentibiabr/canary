local mType = Game.createMonsterType("Gang Member")
local monster = {}

monster.description = "a gang member"
monster.experience = 70
monster.outfit = {
	lookType = 151,
	lookHead = 114,
	lookBody = 19,
	lookLegs = 42,
	lookFeet = 20,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 526
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Throughout the Foreigner, Factory, and Trade Quarters in Yalahar."
	}

monster.health = 295
monster.maxHealth = 295
monster.race = "blood"
monster.corpse = 20403
monster.speed = 190
monster.manaCost = 420
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 35,
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
	{text = "This is our territory!", yell = false},
	{text = "Help me guys!", yell = false},
	{text = "I don't like the way you look!", yell = false},
	{text = "You're wearing the wrong colours!", yell = false},
	{text = "Don't mess with us!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 50110, maxCount = 30},
	{name = "club ring", chance = 740},
	{name = "studded legs", chance = 5220},
	{name = "leather legs", chance = 15330}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -70}
}

monster.defenses = {
	defense = 15,
	armor = 15
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = -5}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
