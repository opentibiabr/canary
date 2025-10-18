local mType = Game.createMonsterType("Wyvern")
local monster = {}

monster.description = "a wyvern"
monster.experience = 515
monster.outfit = {
	lookType = 239,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 290
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Beregar, Black Knight's Villa, Chor, Ghostlands, Chyllfroest, Crystal Gardens, \z
		Crystal Grounds, Dragon Lair (Edron), Drillworm Cave, Folda, Hero Fortress, Kazordoon, \z
		Green Djinn Tower, Mushroom Fields,Paradox Tower, Plains of Havoc, Plague Spike, \z
		Poachers' Camp (Ferngrims Gate), Stonehome, Tiquanda, Truffels Garden, \z
		Vandura Mountain, Vega, Venore, Wyvern Cave (Ferngrims Gate), Wyvern Hill and Wyvern Ulderek's Rock Cave.",
}

monster.health = 795
monster.maxHealth = 795
monster.race = "blood"
monster.corpse = 6301
monster.speed = 93
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 300,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Shriiiek", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 70496, maxCount = 90 }, -- Gold Coin
	{ id = 3583, chance = 57563, maxCount = 3 }, -- Dragon Ham
	{ id = 9644, chance = 5200 }, -- Wyvern Talisman
	{ id = 3029, chance = 1091 }, -- Small Sapphire
	{ id = 3450, chance = 3892 }, -- Power Bolt
	{ id = 236, chance = 969 }, -- Strong Health Potion
	{ id = 3010, chance = 339 }, -- Emerald Bangle
	{ id = 3071, chance = 1166 }, -- Wand of Inferno
	{ id = 7408, chance = 723 }, -- Wyvern Fang
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -120, condition = { type = CONDITION_POISON, totalDamage = 480, interval = 4000 } },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 15, minDamage = -240, maxDamage = -240, length = 8, spread = 3, effect = CONST_ME_POISONAREA, target = false },
	{ name = "drunk", interval = 2000, chance = 10, length = 3, spread = 2, effect = CONST_ME_SOUND_RED, target = false, duration = 5000 },
}

monster.defenses = {
	defense = 25,
	armor = 19,
	mitigation = 1.21,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 45, maxDamage = 65, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 300, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
