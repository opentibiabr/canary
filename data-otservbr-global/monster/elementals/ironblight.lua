local mType = Game.createMonsterType("Ironblight")
local monster = {}

monster.description = "an ironblight"
monster.experience = 5400
monster.outfit = {
	lookType = 498,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 890
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Warzone 3.",
}

monster.health = 6600
monster.maxHealth = 6600
monster.race = "undead"
monster.corpse = 16079
monster.speed = 143
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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 260,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Yowl!", yell = false },
	{ text = "Clonk!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 199 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 8 }, -- Platinum Coin
	{ id = 16123, chance = 12782, maxCount = 2 }, -- Brown Crystal Splinter
	{ id = 16138, chance = 18519 }, -- Crystalline Spikes
	{ id = 238, chance = 17574 }, -- Great Mana Potion
	{ id = 16121, chance = 5656 }, -- Green Crystal Shard
	{ id = 16126, chance = 10475 }, -- Red Crystal Fragment
	{ id = 10310, chance = 15591 }, -- Shiny Stone
	{ id = 3033, chance = 14718, maxCount = 3 }, -- Small Amethyst
	{ id = 3032, chance = 10393, maxCount = 3 }, -- Small Emerald
	{ id = 7643, chance = 18711 }, -- Ultimate Health Potion
	{ id = 9654, chance = 20091 }, -- War Crystal
	{ id = 9028, chance = 5287 }, -- Crystal of Balance
	{ id = 9067, chance = 1862 }, -- Crystal of Power
	{ id = 3039, chance = 3820 }, -- Red Gem
	{ id = 8084, chance = 1653 }, -- Springsprout Rod
	{ id = 16118, chance = 893 }, -- Glacial Rod
	{ id = 3041, chance = 583 }, -- Blue Gem
	{ id = 3048, chance = 310 }, -- Might Ring
	{ id = 3326, chance = 700 }, -- Epee
	{ id = 5904, chance = 757 }, -- Magic Sulphur
	{ id = 812, chance = 908 }, -- Terra Legs
	{ id = 3333, chance = 497 }, -- Crystal Mace
	{ id = 7437, chance = 893 }, -- Sapphire Hammer
	{ id = 8027, chance = 276 }, -- Composite Hornbow
	{ id = 10451, chance = 296 }, -- Jade Hat
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -460, maxDamage = -480, radius = 6, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -260, maxDamage = -350, length = 7, spread = 0, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -180, maxDamage = -250, radius = 2, shootEffect = CONST_ANI_GREENSTAR, effect = CONST_ME_BIGPLANTS, target = true },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -800, length = 5, spread = 0, effect = CONST_ME_BLOCKHIT, target = false, duration = 30000 },
}

monster.defenses = {
	defense = 35,
	armor = 84,
	mitigation = 2.40,
	{ name = "invisible", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 60 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
