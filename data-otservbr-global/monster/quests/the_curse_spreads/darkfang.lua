local mType = Game.createMonsterType("Darkfang")
local monster = {}

monster.description = "Darkfang"
monster.experience = 4000
monster.outfit = {
	lookType = 308,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 4800
monster.maxHealth = 4800
monster.race = "blood"
monster.corpse = 18099
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1558,
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
		{ name = "Gloom Wolf", chance = 20, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You are my next meal! Grrr!", yell = false },
}

monster.loot = {
	{ id = 7439, chance = 80000, maxCount = 2 }, -- berserk potion
	{ id = 3027, chance = 80000, maxCount = 5 }, -- black pearl
	{ id = 3031, chance = 80000, maxCount = 117 }, -- gold coin
	{ id = 22193, chance = 80000, maxCount = 3 }, -- onyx chip
	{ id = 3035, chance = 80000, maxCount = 9 }, -- platinum coin
	{ id = 675, chance = 80000, maxCount = 2 }, -- small enchanted sapphire
	{ id = 7643, chance = 80000, maxCount = 2 }, -- ultimate health potion
	{ id = 10317, chance = 80000 }, -- werewolf fur
	{ id = 22052, chance = 80000 }, -- werewolf fangs
	{ id = 5897, chance = 80000 }, -- wolf paw
	{ id = 3081, chance = 80000 }, -- stone skin amulet
	{ id = 3741, chance = 80000 }, -- troll green
	{ id = 7419, chance = 80000 }, -- dreaded cleaver
	{ id = 7394, chance = 80000 }, -- wolf trophy
	{ id = 7428, chance = 80000 }, -- bonebreaker
	{ id = 22084, chance = 80000 }, -- wolf backpack
	{ id = 22516, chance = 80000 }, -- silver token
	{ id = 22083, chance = 80000 }, -- moonlight crystals
	{ id = 3055, chance = 80000 }, -- platinum amulet
	{ id = 22060, chance = 80000 }, -- werewolf amulet
	{ id = 3053, chance = 80000 }, -- time ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -290 },
	{ name = "werewolf skill reducer", interval = 2000, chance = 15, range = 1, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -300, radius = 8, effect = CONST_ME_SOUND_RED, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = 200, maxDamage = 340, radius = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -600, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000 },
}

monster.defenses = {
	defense = 45,
	armor = 40,
	--	mitigation = ???,
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_HEALING, minDamage = 150, maxDamage = 345, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 70 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 70 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
