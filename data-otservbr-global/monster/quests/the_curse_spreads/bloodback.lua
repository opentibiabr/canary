local mType = Game.createMonsterType("Bloodback")
local monster = {}

monster.description = "Bloodback"
monster.experience = 4000
monster.outfit = {
	lookType = 1039,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 5200
monster.maxHealth = 5200
monster.race = "blood"
monster.corpse = 27718
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1560,
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
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "Wereboar", chance = 20, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You will DIE!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 68 }, -- Gold Coin
	{ id = 22054, chance = 100000 }, -- Wereboar Tusks
	{ id = 22053, chance = 100000 }, -- Wereboar Hooves
	{ id = 22087, chance = 100000 }, -- Wereboar Loincloth
	{ id = 3035, chance = 100000, maxCount = 6 }, -- Platinum Coin
	{ id = 3039, chance = 50000 }, -- Red Gem
	{ id = 239, chance = 50000 }, -- Great Health Potion
	{ id = 676, chance = 50000, maxCount = 2 }, -- Small Enchanted Ruby
	{ id = 7432, chance = 31170 }, -- Furry Club
	{ id = 16126, chance = 19670, maxCount = 2 }, -- Red Crystal Fragment
	{ id = 3081, chance = 19670 }, -- Stone Skin Amulet
	{ id = 7643, chance = 14290 }, -- Ultimate Health Potion
	{ id = 22085, chance = 8530 }, -- Fur Armor
	{ id = 7419, chance = 7420 }, -- Dreaded Cleaver
	{ id = 22102, chance = 3900 }, -- Wereboar Trophy
	{ id = 22516, chance = 2780 }, -- Silver Token
	{ id = 7452, chance = 2600 }, -- Spiked Squelcher
	{ id = 22060, chance = 3150 }, -- Werewolf Amulet
	{ id = 7439, chance = 2040 }, -- Berserk Potion
	{ id = 7457, chance = 930 }, -- Fur Boots
	{ id = 22083, chance = 2970 }, -- Moonlight Crystals
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -290 },
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -420, range = 7, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -600, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000 },
	{ name = "combat", interval = 1000, chance = 14, type = COMBAT_DEATHDAMAGE, minDamage = -100, maxDamage = -200, length = 5, spread = 0, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 40,
	--	mitigation = ???,
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_HEALING, minDamage = 150, maxDamage = 345, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
