local mType = Game.createMonsterType("The Plasmother")
local monster = {}

monster.description = "The Plasmother"
monster.experience = 12000
monster.outfit = {
	lookType = 238,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 300,
	bossRace = RARITY_NEMESIS,
}

monster.health = 7500
monster.maxHealth = 7500
monster.race = "venom"
monster.corpse = 6532
monster.speed = 155
monster.manaCost = 0

monster.changeTarget = {
	interval = 5500,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 250,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 3,
	color = 30,
}

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "Defiler", chance = 20, interval = 4000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Blubb", yell = false },
	{ text = "Blubb Blubb", yell = false },
	{ text = "Blubberdiblubb", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 177 }, -- Gold Coin
	{ id = 3035, chance = 69230, maxCount = 20 }, -- Platinum Coin
	{ id = 6499, chance = 69230 }, -- Demonic Essence
	{ id = 3027, chance = 23080, maxCount = 3 }, -- Black Pearl
	{ id = 3029, chance = 38460, maxCount = 3 }, -- Small Sapphire
	{ id = 3033, chance = 23080, maxCount = 2 }, -- Small Amethyst
	{ id = 3032, chance = 7689, maxCount = 3 }, -- Small Emerald
	{ id = 5944, chance = 15379 }, -- Soul Orb
	{ id = 6535, chance = 100000 }, -- The Plasmother's Remains
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 30, attack = 50 },
	{ name = "speed", interval = 1000, chance = 8, speedChange = -800, radius = 6, effect = CONST_ME_POISONAREA, target = false, duration = 10000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -350, radius = 4, effect = CONST_ME_POISONAREA, target = false },
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -530, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_HITBYPOISON, target = true },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	--	mitigation = ???,
	{ name = "combat", interval = 1000, chance = 75, type = COMBAT_HEALING, minDamage = 505, maxDamage = 605, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -15 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
