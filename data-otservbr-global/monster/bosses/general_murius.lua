local mType = Game.createMonsterType("General Murius")
local monster = {}

monster.description = "General Murius"
monster.experience = 450
monster.outfit = {
	lookType = 611,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 207,
	bossRace = RARITY_NEMESIS,
}

monster.health = 550
monster.maxHealth = 550
monster.race = "blood"
monster.corpse = 21091
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 20,
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
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 4,
	summons = {
		{ name = "Minotaur Archer", chance = 15, interval = 1000, count = 2 },
		{ name = "Minotaur Guard", chance = 12, interval = 1000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You will get what you deserve!", yell = false },
	{ text = "Feel the power of the Mooh'Tah!", yell = false },
	{ text = "For the king!", yell = false },
	{ text = "Guards!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 97140, maxCount = 97 }, -- Gold Coin
	{ id = 3035, chance = 97140, maxCount = 3 }, -- Platinum Coin
	{ id = 11472, chance = 100000, maxCount = 2 }, -- Minotaur Horn
	{ id = 5878, chance = 100000 }, -- Minotaur Leather
	{ id = 7363, chance = 34290, maxCount = 11 }, -- Piercing Bolt
	{ id = 3577, chance = 20000 }, -- Meat
	{ id = 3413, chance = 28570 }, -- Battle Shield
	{ id = 3409, chance = 1000 }, -- Steel Shield
	{ id = 3558, chance = 7145 }, -- Chain Legs
	{ id = 3358, chance = 1000 }, -- Chain Armor
	{ id = 3359, chance = 71430 }, -- Brass Armor
	{ id = 3377, chance = 1000 }, -- Scale Armor
	{ id = 3275, chance = 85710 }, -- Double Axe
	{ id = 7401, chance = 20000 }, -- Minotaur Trophy
	{ id = 3450, chance = 8570, maxCount = 7 }, -- Power Bolt
	{ id = 236, chance = 2860 }, -- Strong Health Potion
	{ id = 3073, chance = 1000 }, -- Wand of Cosmic Energy
	{ id = 3483, chance = 5710 }, -- Fishing Rod
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -170 },
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -120, range = 7, shootEffect = CONST_ANI_BOLT, target = false },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -80, radius = 3, effect = CONST_ME_HITAREA, target = false },
}

monster.defenses = {
	defense = 22,
	armor = 16,
	--	mitigation = ???,
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 275, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
