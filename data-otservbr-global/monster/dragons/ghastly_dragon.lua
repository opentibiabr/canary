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
	lookMount = 0,
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
	Locations = "Ghastly Dragon Lair, Corruption Hole, Razachai including the Inner Sanctum, Zao Palace, Deeper Banuta single spawn, Chyllfroest.",
}

monster.health = 7800
monster.maxHealth = 7800
monster.race = "undead"
monster.corpse = 10445
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 5,
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
	illusionable = false,
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
}

monster.light = {
	level = 4,
	color = 119,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "EMBRACE MY GIFTS!", yell = true },
	{ text = "I WILL FEAST ON YOUR SOUL!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 266 }, -- gold coin
	{ id = 238, chance = 80000, maxCount = 2 }, -- great mana potion
	{ id = 3032, chance = 80000, maxCount = 5 }, -- small emerald
	{ id = 3035, chance = 80000, maxCount = 2 }, -- platinum coin
	{ id = 3383, chance = 80000 }, -- dark armor
	{ id = 3557, chance = 80000 }, -- plate legs
	{ id = 7642, chance = 80000, maxCount = 2 }, -- great spirit potion
	{ id = 7643, chance = 80000 }, -- ultimate health potion
	{ id = 813, chance = 23000 }, -- terra boots
	{ id = 5944, chance = 23000 }, -- soul orb
	{ id = 6499, chance = 23000 }, -- demonic essence
	{ id = 8896, chance = 23000 }, -- slightly rusted armor
	{ id = 10392, chance = 23000 }, -- twin hooks
	{ id = 10406, chance = 23000 }, -- zaoan halberd
	{ id = 10449, chance = 23000 }, -- ghastly dragon head
	{ id = 10450, chance = 23000 }, -- undead heart
	{ id = 812, chance = 5000 }, -- terra legs
	{ id = 10388, chance = 5000 }, -- drakinata
	{ id = 10310, chance = 1000 }, -- shiny stone
	{ id = 10384, chance = 1000 }, -- zaoan armor
	{ id = 10386, chance = 1000 }, -- zaoan shoes
	{ id = 10387, chance = 1000 }, -- zaoan legs
	{ id = 10438, chance = 1000 }, -- spellweavers robe
	{ id = 10451, chance = 1000 }, -- jade hat
	{ id = 10323, chance = 260 }, -- guardian boots
	{ id = 10385, chance = 260 }, -- zaoan helmet
	{ id = 10390, chance = 260 }, -- zaoan sword
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -603 },
	{ name = "ghastly dragon curse", interval = 2000, chance = 5, range = 5, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -920, maxDamage = -1280, range = 5, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -80, maxDamage = -230, range = 7, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "ghastly dragon wave", interval = 2000, chance = 10, minDamage = -120, maxDamage = -250, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -110, maxDamage = -180, radius = 4, effect = CONST_ME_MORTAREA, target = false },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -800, range = 7, effect = CONST_ME_SMALLCLOUDS, target = true, duration = 30000 },
}

monster.defenses = {
	defense = 35,
	armor = 30,
	mitigation = 1.24,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = -15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
