local mType = Game.createMonsterType("Sharpclaw")
local monster = {}

monster.description = "Sharpclaw"
monster.experience = 3000
monster.outfit = {
	lookType = 1031,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3300
monster.maxHealth = 3300
monster.race = "blood"
monster.corpse = 22067
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1562,
	bossRace = RARITY_ARCHFOE,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
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

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "Werebadger", chance = 20, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Never underestimate a badger!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80986, maxCount = 75 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 7 }, -- Platinum Coin
	{ id = 22051, chance = 100000 }, -- Werebadger Claws
	{ id = 22055, chance = 100000 }, -- Werebadger Skull
	{ id = 22193, chance = 64697, maxCount = 3 }, -- Onyx Chip
	{ id = 22086, chance = 20195 }, -- Badger Boots
	{ id = 8017, chance = 23634 }, -- Beetroot
	{ id = 8082, chance = 6967 }, -- Underworld Rod
	{ id = 238, chance = 38470 }, -- Great Mana Potion
	{ id = 678, chance = 35302, maxCount = 3 }, -- Small Enchanted Amethyst
	{ id = 8094, chance = 5203 }, -- Wand of Voodoo
	{ id = 3741, chance = 4146 }, -- Troll Green
	{ id = 22083, chance = 2646, maxCount = 15 }, -- Moonlight Crystals
	{ id = 23373, chance = 14638 }, -- Ultimate Mana Potion
	{ id = 22516, chance = 2028 }, -- Silver Token
	{ id = 3098, chance = 9873 }, -- Ring of Healing
	{ id = 3055, chance = 966 }, -- Platinum Amulet
	{ id = 22101, chance = 5467 }, -- Werebadger Trophy
	{ id = 22060, chance = 4146 }, -- Werewolf Amulet
	{ id = 3725, chance = 5995 }, -- Brown Mushroom
	{ id = 22084, chance = 179 }, -- Wolf Backpack
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -290 },
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 100, maxDamage = 720, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -600, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000 },
	{ name = "combat", interval = 1000, chance = 14, type = COMBAT_DEATHDAMAGE, minDamage = -100, maxDamage = -700, length = 5, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "outfit", interval = 1000, chance = 1, radius = 1, target = true, duration = 2000, outfitMonster = "Werebadger" },
	{ name = "ghastly dragon curse", interval = 2000, chance = 5, range = 1, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 40,
	--	mitigation = ???,
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_HEALING, minDamage = 150, maxDamage = 345, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
