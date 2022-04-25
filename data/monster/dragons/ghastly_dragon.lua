--# Monster converted using Devm monster converter #--
local mType = Game.createMonsterType("Ghastly Dragon")
local monster = {}

monster.description = "a ghastly dragon"
monster.experience = 4600
monster.outfit = {
	lookType = 351,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 643
monster.Bestiary = {
	class = "Dragon",
	race = BESTY_RACE_DRAGON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Ghastly Dragon Lair, Corruption Hole, Razachai including the Inner Sanctum, \z
		Zao Palace, Deeper Banuta, Chyllfroest."
	}

monster.health = 7800
monster.maxHealth = 7800
monster.race = "undead"
monster.corpse = 10445
monster.speed = 320
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 5
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 366,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{text = "EMBRACE MY GIFTS!", yell = true},
	{text = "I WILL FEAST ON YOUR SOUL!", yell = true}
}

monster.loot = {
	{id = 3031, chance = 33725, maxCount = 100}, -- gold coin
	{id = 3031, chance = 33725, maxCount = 100}, -- gold coin
	{id = 3031, chance = 33725, maxCount = 66}, -- gold coin
	{id = 3035, chance = 29840, maxCount = 2}, -- platinum coin
	{id = 5944, chance = 12170}, -- soul orb
	{id = 6499, chance = 8920}, -- demonic essence
	{id = 238, chance = 30560, maxCount = 2}, -- great mana potion
	{id = 812, chance = 3130}, -- terra legs
	{id = 813, chance = 9510}, -- terra boots
	{id = 7642, chance = 29460, maxCount = 2}, -- great spirit potion
	{id = 7643, chance = 24700}, -- ultimate health potion
	{id = 8896, chance = 180}, -- slightly rusted armor
	{id = 10310, chance = 860}, -- shiny stone
	{id = 10323, chance = 200}, -- guardian boots
	{id = 10384, chance = 870}, -- Zaoan armor
	{id = 10385, chance = 150}, -- Zaoan helmet
	{id = 10386, chance = 870}, -- Zaoan shoes
	{id = 10387, chance = 1400}, -- Zaoan legs
	{id = 10388, chance = 1470}, -- drakinata
	{id = 10390, chance = 100}, -- Zaoan sword
	{id = 10392, chance = 15100}, -- twin hooks
	{id = 10406, chance = 15020}, -- Zaoan halberd
	{id = 10438, chance = 690}, -- spellweaver's robe
	{id = 10449, chance = 6650}, -- ghastly dragon head
	{id = 10450, chance = 19830}, -- undead heart
	{id = 10451, chance = 810} -- jade hat
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -603},
	-- {name ="ghastly dragon curse", interval = 2000, chance = 5, range = 5, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -920, maxDamage = -1280, range = 5, effect = CONST_ME_SMALLCLOUDS, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -80, maxDamage = -230, range = 7, effect = CONST_ME_MAGIC_RED, target = true},
	-- {name ="ghastly dragon wave", interval = 2000, chance = 10, minDamage = -120, maxDamage = -250, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -110, maxDamage = -180, radius = 4, effect = CONST_ME_MORTAREA, target = false},
	{name ="speed", interval = 2000, chance = 20, speedChange = -800, range = 7, effect = CONST_ME_SMALLCLOUDS, target = true, duration = 30000}
}

monster.defenses = {
	defense = 35,
	armor = 35
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -10},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = -15},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
