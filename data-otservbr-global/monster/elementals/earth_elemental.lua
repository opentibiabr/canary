local mType = Game.createMonsterType("Earth Elemental")
local monster = {}

monster.description = "an earth elemental"
monster.experience = 550
monster.outfit = {
	lookType = 301,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 458
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Edron Earth Elemental Cave, Vandura Mountain, Deeper Banuta, Vengoth Castle, Robson Isle, \z
	Drillworm Caves, Crystal Grounds, Middle Spike.",
}

monster.health = 650
monster.maxHealth = 650
monster.race = "undead"
monster.corpse = 8105
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 80,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
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
	{ text = "Stomp.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 93090, maxCount = 130 }, -- Gold Coin
	{ id = 774, chance = 19953, maxCount = 30 }, -- Earth Arrow
	{ id = 1781, chance = 46890, maxCount = 10 }, -- Small Stone
	{ id = 3147, chance = 10158 }, -- Blank Rune
	{ id = 10305, chance = 20613 }, -- Lump of Earth
	{ id = 237, chance = 2154 }, -- Strong Mana Potion
	{ id = 3048, chance = 20 }, -- Might Ring
	{ id = 8894, chance = 5259 }, -- Heavily Rusted Armor
	{ id = 9057, chance = 545 }, -- Small Topaz
	{ id = 10422, chance = 610 }, -- Clay Lump
	{ id = 12600, chance = 158 }, -- Coal
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -110 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -72, maxDamage = -105, range = 7, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_GREEN_RINGS, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -100, range = 7, radius = 2, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_POFF, target = true },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 20, minDamage = -200, maxDamage = -260, length = 6, spread = 0, effect = CONST_ME_BIGPLANTS, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -100, maxDamage = -140, radius = 5, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -330, range = 5, effect = CONST_ME_SMALLPLANTS, target = true, duration = 5000 },
}

monster.defenses = {
	defense = 25,
	armor = 45,
	mitigation = 0.78,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 60, maxDamage = 80, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 35 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
