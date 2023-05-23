local mType = Game.createMonsterType("Lost Soul")
local monster = {}

monster.description = "a lost soul"
monster.experience = 4000
monster.outfit = {
	lookType = 232,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 283
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Pits of Inferno, Formorgar Mines, Helheim, \z
		Roshamuul Prison and in The Arcanum (Part of the Inquisition quest)."
	}

monster.health = 5800
monster.maxHealth = 5800
monster.race = "undead"
monster.corpse = 6309
monster.speed = 190
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15
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
	runHealth = 450,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{text = "Forgive Meee!", yell = false},
	{text = "Mouuuurn meeee!", yell = false},
	{text = "Help meee!", yell = false}
}

monster.loot = {
	{name = "ruby necklace", chance = 1500},
	{name = "white pearl", chance = 10000, maxCount = 3},
	{name = "black pearl", chance = 12000, maxCount = 3},
	{name = "gold coin", chance = 100000, maxCount = 198},
	{name = "platinum coin", chance = 100000, maxCount = 7},
	{id= 3039, chance = 15000}, -- red gem
	{name = "stone skin amulet", chance = 2780},
	{name = "blank rune", chance = 35250, maxCount = 3},
	{name = "skull staff", chance = 850},
	{name = "tower shield", chance = 740},
	{name = "skull helmet", chance = 170},
	{id = 5806, chance = 4950}, -- silver goblet
	{name = "soul orb", chance = 15000},
	{id = 6299, chance = 2170}, -- death ring
	{name = "demonic essence", chance = 7500},
	{name = "skeleton decoration", chance = 1250},
	{name = "haunted blade", chance = 740},
	{name = "titan axe", chance = 1000},
	{name = "great mana potion", chance = 14200, maxCount = 2},
	{name = "great health potion", chance = 8800, maxCount = 2},
	{id = 8896, chance = 3500}, -- slightly rusted armor
	{name = "unholy bone", chance = 33010}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -420},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -40, maxDamage = -210, length = 3, spread = 0, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="speed", interval = 2000, chance = 20, speedChange = -800, radius = 6, effect = CONST_ME_SMALLCLOUDS, target = false, duration = 4000}
}

monster.defenses = {
	defense = 30,
	armor = 30
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = -25},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
