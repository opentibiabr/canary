local mType = Game.createMonsterType("Werebadger")
local monster = {}

monster.description = "a werebadger"
monster.experience = 1600
monster.outfit = {
	lookType = 729,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1144
monster.Bestiary = {
	class = "Lycanthrope",
	race = BESTY_RACE_LYCANTHROPE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Grimvale: -1 floor from ground level, also seen on surface during full moon (12th-14th of every month). \z
		Also in the were-beasts cave south-west of Edron and in the Last Sanctum.",
}

monster.health = 1700
monster.maxHealth = 1700
monster.race = "blood"
monster.corpse = 22067
monster.speed = 130
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 275,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
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
	{ text = "SNUFFLE", yell = true },
	{ text = "Sniff Sniff", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 81050, maxCount = 75 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 3 }, -- Platinum Coin
	{ id = 8017, chance = 25377 }, -- Beetroot
	{ id = 3725, chance = 6592 }, -- Brown Mushroom
	{ id = 22051, chance = 14120 }, -- Werebadger Claws
	{ id = 22055, chance = 14954 }, -- Werebadger Skull
	{ id = 22083, chance = 2126 }, -- Moonlight Crystals
	{ id = 237, chance = 4021 }, -- Strong Mana Potion
	{ id = 238, chance = 1798 }, -- Great Mana Potion
	{ id = 268, chance = 5295 }, -- Mana Potion
	{ id = 678, chance = 1470, maxCount = 2 }, -- Small Enchanted Amethyst
	{ id = 3741, chance = 5174 }, -- Troll Green
	{ id = 3055, chance = 469 }, -- Platinum Amulet
	{ id = 3098, chance = 912 }, -- Ring of Healing
	{ id = 22060, chance = 548 }, -- Werewolf Amulet
	{ id = 22086, chance = 864 }, -- Badger Boots
	{ id = 8082, chance = 389 }, -- Underworld Rod
	{ id = 8094, chance = 496 }, -- Wand of Voodoo
	{ id = 22101, chance = 262 }, -- Werebadger Trophy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 50, attack = 60, condition = { type = CONDITION_POISON, totalDamage = 140, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -21, maxDamage = -150, range = 7, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_CARNIPHILA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -10, maxDamage = -100, length = 8, spread = 0, effect = CONST_ME_CARNIPHILA, target = false },
	{ name = "speed", interval = 4000, chance = 20, radius = 7, effect = CONST_ME_POFF, target = true },
}

monster.defenses = {
	defense = 30,
	armor = 31,
	mitigation = 0.75,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
