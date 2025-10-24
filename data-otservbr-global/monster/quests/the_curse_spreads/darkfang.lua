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
	{ id = 7439, chance = 84697, maxCount = 2 }, -- Berserk Potion
	{ id = 3027, chance = 80562, maxCount = 5 }, -- Black Pearl
	{ id = 3031, chance = 100000, maxCount = 117 }, -- Gold Coin
	{ id = 22193, chance = 83550, maxCount = 3 }, -- Onyx Chip
	{ id = 3035, chance = 100000, maxCount = 9 }, -- Platinum Coin
	{ id = 675, chance = 79859, maxCount = 2 }, -- Small Enchanted Sapphire
	{ id = 7643, chance = 100000, maxCount = 2 }, -- Ultimate Health Potion
	{ id = 10317, chance = 100000 }, -- Werewolf Fur
	{ id = 22052, chance = 100000 }, -- Werewolf Fangs
	{ id = 5897, chance = 99911 }, -- Wolf Paw
	{ id = 3081, chance = 23879 }, -- Stone Skin Amulet
	{ id = 3741, chance = 23879 }, -- Troll Green
	{ id = 7419, chance = 7314 }, -- Dreaded Cleaver
	{ id = 7394, chance = 9954 }, -- Wolf Trophy
	{ id = 7428, chance = 8355 }, -- Bonebreaker
	{ id = 22084, chance = 265 }, -- Wolf Backpack
	{ id = 22516, chance = 2115 }, -- Silver Token
	{ id = 10389, chance = 1350 }, -- Traditional Sai
	{ id = 22083, chance = 2552 }, -- Moonlight Crystals
	{ id = 3055, chance = 3084 }, -- Platinum Amulet
	{ id = 22060, chance = 2994 }, -- Werewolf Amulet
	{ id = 3053, chance = 7397 }, -- Time Ring
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
