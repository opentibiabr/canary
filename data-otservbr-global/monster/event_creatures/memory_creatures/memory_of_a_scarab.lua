local mType = Game.createMonsterType("Memory of a Scarab")
local monster = {}

monster.description = "a memory of a scarab"
monster.experience = 1590
monster.outfit = {
	lookType = 79,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3620
monster.maxHealth = 3620
monster.race = "venom"
monster.corpse = 6021
monster.speed = 109
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 20,
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
	maxSummons = 2,
	summons = {
		{ name = "Larva", chance = 10, interval = 2000, count = 3 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3033, chance = 80000 }, -- small amethyst
	{ id = 3018, chance = 80000 }, -- scarab amulet
	{ id = 236, chance = 80000 }, -- strong health potion
	{ id = 22746, chance = 80000 }, -- ancient amulet
	{ id = 37530, chance = 80000 }, -- bottle of champagne
	{ id = 37468, chance = 80000 }, -- special fx box
	{ id = 3032, chance = 80000 }, -- small emerald
	{ id = 3031, chance = 80000 }, -- gold coin
	{ id = 3042, chance = 80000 }, -- scarab coin
	{ id = 3357, chance = 80000 }, -- plate armor
	{ id = 3047, chance = 80000 }, -- magic light wand
	{ id = 3440, chance = 80000 }, -- scarab shield
	{ id = 3328, chance = 80000 }, -- daramian waraxe
	{ id = 8084, chance = 80000 }, -- springsprout rod
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -130, condition = { type = CONDITION_POISON, totalDamage = 56, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -15, maxDamage = -145, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -700, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false, duration = 25000 },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 30, minDamage = -70, maxDamage = -150, radius = 5, effect = CONST_ME_POISONAREA, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	mitigation = 1.10,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 380, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
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
