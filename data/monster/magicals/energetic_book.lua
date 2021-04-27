local mType = Game.createMonsterType("Energetic Book")
local monster = {}

monster.description = "an energetic book"
monster.experience = 12034
monster.outfit = {
	lookType = 1061,
	lookHead = 15,
	lookBody = 91,
	lookLegs = 85,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1665
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Secret Library."
	}

monster.health = 18500
monster.maxHealth = 18500
monster.race = "undead"
monster.corpse = 32478
monster.speed = 440
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
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
}

monster.loot = {
	{name = "Platinum Coin", chance = 100000, maxCount = 28},
	{id = 33316, chance = 900, maxCount = 8},
	{id = 33317, chance = 900, maxCount = 7},
	{name = "Ultimate Health Potion", chance = 10000, maxCount = 7},
	{name = "Ultimate Mana Potion", chance = 10000, maxCount = 7},
	{name = "Energy Ball", chance = 900, maxCount = 7},
	{id = 33313, chance = 800, maxCount = 7},
	{name = "Lightning Pendant", chance = 500},
	{name = "Lightning Boots", chance = 500},
	{name = "Lightning Headband", chance = 500},
	{name = "Might Ring", chance = 500},
	{name = "Spellweaver's Robe", chance = 350},
	{name = "Wand of Defiance", chance = 350},
	{name = "Haunted Blade", chance = 550},
	{name = "Lightning Legs", chance = 350}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200},
	{name ="combat", interval = 2000, chance = 14, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -680, range = 7, shootEffect = CONST_ANI_ENERGY, target = false},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -505, radius = 3, effect = CONST_ME_ENERGYAREA, target = false},
	{name ="combat", interval = 1500, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -700, length = 8, spread = 3, effect = CONST_ME_STUN, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 82
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 100},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
