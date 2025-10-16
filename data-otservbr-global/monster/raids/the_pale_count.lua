local mType = Game.createMonsterType("The Pale Count")
local monster = {}

monster.description = "The Pale Count"
monster.experience = 28000
monster.outfit = {
	lookType = 557,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 972,
	bossRace = RARITY_NEMESIS,
}

monster.health = 50000
monster.maxHealth = 50000
monster.race = "blood"
monster.corpse = 18953
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
		{ name = "Nightfiend", chance = 10, interval = 2000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Feel the hungry kiss of death!", yell = false },
	{ text = "The monsters in the mirror will come eat your dreams.", yell = false },
	{ text = "Your pitiful life has come to an end!", yell = false },
	{ text = "I will squish you like a maggot and suck you dry!", yell = false },
	{ text = "Yield to the inevitable!", yell = false },
	{ text = "Some day I shall see my beautiful face in a mirror again.", yell = false },
}

monster.loot = {
	{ id = 8192, chance = 80000 }, -- vampire lord token
	{ id = 18927, chance = 80000 }, -- vampires cape chain
	{ id = 9685, chance = 80000 }, -- vampire teeth
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 3032, chance = 80000, maxCount = 5 }, -- small emerald
	{ id = 3029, chance = 80000, maxCount = 5 }, -- small sapphire
	{ id = 3033, chance = 80000, maxCount = 5 }, -- small amethyst
	{ id = 3028, chance = 80000, maxCount = 5 }, -- small diamond
	{ id = 3027, chance = 80000, maxCount = 5 }, -- black pearl
	{ id = 236, chance = 80000, maxCount = 3 }, -- strong health potion
	{ id = 237, chance = 80000, maxCount = 5 }, -- strong mana potion
	{ id = 11449, chance = 80000 }, -- blood preservation
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 3326, chance = 80000 }, -- epee
	{ id = 3049, chance = 80000 }, -- stealth ring
	{ id = 3098, chance = 80000 }, -- ring of healing
	{ id = 5909, chance = 80000 }, -- white piece of cloth
	{ id = 5912, chance = 80000 }, -- blue piece of cloth
	{ id = 5911, chance = 80000 }, -- red piece of cloth
	{ id = 3434, chance = 80000 }, -- vampire shield
	{ id = 7427, chance = 80000 }, -- chaos mace
	{ id = 7416, chance = 80000 }, -- bloody edge
	{ id = 7419, chance = 80000 }, -- dreaded cleaver
	{ id = 8075, chance = 80000 }, -- spellbook of lost souls
	{ id = 19083, chance = 1000 }, -- silver raid token
	{ id = 19373, chance = 1000 }, -- haunted mirror piece
	{ id = 19374, chance = 1000 }, -- vampire silk slippers
	{ id = 18935, chance = 1000 }, -- vampires signet ring
	{ id = 3030, chance = 80000 }, -- small ruby
	{ id = 9057, chance = 80000 }, -- small topaz
	{ id = 3041, chance = 80000 }, -- blue gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 80, attack = 120 },
	{ name = "speed", interval = 1000, chance = 17, speedChange = -600, range = 7, radius = 4, effect = CONST_ME_MAGIC_RED, target = true, duration = 1500 },
	{ name = "combat", interval = 2000, chance = 21, type = COMBAT_ICEDAMAGE, minDamage = -130, maxDamage = -350, range = 6, radius = 2, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_GIANTICE, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -60, maxDamage = -120, range = 7, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_CARNIPHILA, target = false },
}

monster.defenses = {
	defense = 75,
	armor = 75,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
