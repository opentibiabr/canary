local mType = Game.createMonsterType("The Horned Fox")
local monster = {}

monster.description = "the Horned Fox"
monster.experience = 4400
monster.outfit = {
	lookType = 202,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 7990
monster.maxHealth = 7990
monster.race = "blood"
monster.corpse = 5983
monster.speed = 105
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 5,
	summons = {
		{ name = "Minotaur Hunter", chance = 15, interval = 1000, count = 2 },
		{ name = "Minotaur Amazon", chance = 15, interval = 1000, count = 1 },
		{ name = "Worm Princess", chance = 15, interval = 1000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You will never get me!", yell = false },
	{ text = "I'll be back!", yell = false },
	{ text = "Catch me, if you can!", yell = false },
	{ text = "Help me, Gang!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 96880, maxCount = 99 }, -- Gold Coin
	{ id = 11472, chance = 93750, maxCount = 2 }, -- Minotaur Horn
	{ id = 5878, chance = 96880 }, -- Minotaur Leather
	{ id = 11482, chance = 81250 }, -- Piece of Warrior Armor
	{ id = 7363, chance = 46880, maxCount = 14 }, -- Piercing Bolt
	{ id = 3359, chance = 28130 }, -- Brass Armor
	{ id = 3413, chance = 12500 }, -- Battle Shield
	{ id = 3275, chance = 3130 }, -- Double Axe
	{ id = 3483, chance = 6250 }, -- Fishing Rod
	{ id = 3577, chance = 15630 }, -- Meat
	{ id = 236, chance = 12824 }, -- Strong Health Potion
	{ id = 3396, chance = 12824 }, -- Dwarven Helmet
	{ id = 3049, chance = 1000 }, -- Stealth Ring
	{ id = 3276, chance = 1000 }, -- Hatchet
	{ id = 3073, chance = 1000 }, -- Wand of Cosmic Energy
	{ id = 5804, chance = 100000 }, -- Nose Ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -525 },
	{ name = "combat", interval = 1000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -20, range = 7, shootEffect = CONST_ANI_BOLT, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 1000, chance = 40, minDamage = -10, maxDamage = -200, range = 10, shootEffect = CONST_ANI_POISON, target = false },
}

monster.defenses = {
	defense = 33,
	armor = 30,
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_HEALING, minDamage = 80, maxDamage = 100, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "invisible", interval = 1000, chance = 10, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -1 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -1 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
