local mType = Game.createMonsterType("Vashresamun")
local monster = {}

monster.description = "Vashresamun"
monster.experience = 2950
monster.outfit = {
	lookType = 85,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 4000
monster.maxHealth = 4000
monster.race = "undead"
monster.corpse = 6025
monster.speed = 170
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 85,
	bossRace = RARITY_BANE,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	maxSummons = 2,
	summons = {
		{ name = "Banshee", chance = 20, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Come my maidens, we have visitors!", yell = false },
	{ text = "Are you enjoying my music?", yell = false },
	{ text = "If music is the food of death, drop dead.", yell = false },
	{ text = "Chakka Chakka!", yell = false },
	{ text = "Heheheheee!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 250 }, -- gold coin
	{ id = 3236, chance = 80000 }, -- blue note
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 3258, chance = 80000 }, -- lute
	{ id = 3026, chance = 80000 }, -- white pearl
	{ id = 3567, chance = 1000 }, -- blue robe
	{ id = 3333, chance = 1000 }, -- crystal mace
	{ id = 6093, chance = 1000 }, -- crystal ring
	{ id = 3022, chance = 260 }, -- ancient tiara
	{ id = 10290, chance = 260 }, -- mini mummy
	{ id = 2953, chance = 260 }, -- panpipes
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200, condition = { type = CONDITION_POISON, totalDamage = 65, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_LIFEDRAIN, minDamage = -200, maxDamage = -750, radius = 5, effect = CONST_ME_SOUND_PURPLE, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 20,
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_HEALING, minDamage = 60, maxDamage = 450, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 12, speedChange = 350, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 30000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
