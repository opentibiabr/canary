local mType = Game.createMonsterType("Destroyer")
local monster = {}

monster.description = "a destroyer"
monster.experience = 2500
monster.outfit = {
	lookType = 236,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 287
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Pits of Inferno, Formorgar Mines, Alchemist Quarter, Oramond Dungeon and Grounds of Destruction.",
}

monster.health = 3700
monster.maxHealth = 3700
monster.race = "undead"
monster.corpse = 6319
monster.speed = 150
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
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "COME HERE AND DIE!", yell = true },
	{ text = "Destructiooooon!", yell = false },
	{ text = "It's a good day to destroy!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 98422, maxCount = 341 }, -- Gold Coin
	{ id = 3577, chance = 56144, maxCount = 6 }, -- Meat
	{ id = 6499, chance = 19349 }, -- Demonic Essence
	{ id = 3304, chance = 14800 }, -- Crowbar
	{ id = 3449, chance = 58336, maxCount = 12 }, -- Burst Arrow
	{ id = 3383, chance = 9598 }, -- Dark Armor
	{ id = 3033, chance = 10003, maxCount = 2 }, -- Small Amethyst
	{ id = 10298, chance = 7528 }, -- Metal Spike
	{ id = 5944, chance = 6770 }, -- Soul Orb
	{ id = 3456, chance = 5857 }, -- Pick
	{ id = 3357, chance = 5468 }, -- Plate Armor
	{ id = 3035, chance = 7348, maxCount = 3 }, -- Platinum Coin
	{ id = 3281, chance = 1450 }, -- Giant Sword
	{ id = 239, chance = 1153 }, -- Great Health Potion
	{ id = 3554, chance = 1036 }, -- Steel Boots
	{ id = 7427, chance = 896 }, -- Chaos Mace
	{ id = 7419, chance = 804 }, -- Dreaded Cleaver
	{ id = 3062, chance = 462 }, -- Mind Stone
	{ id = 3008, chance = 428 }, -- Crystal Necklace
	{ id = 6299, chance = 120 }, -- Death Ring
	{ id = 5741, chance = 116 }, -- Skull Helmet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -200, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 35,
	mitigation = 1.74,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 420, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -3 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
