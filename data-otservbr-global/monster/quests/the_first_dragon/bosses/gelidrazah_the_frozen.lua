local mType = Game.createMonsterType("Gelidrazah the Frozen")
local monster = {}

monster.description = "Gelidrazah the Frozen"
monster.experience = 9000
monster.outfit = {
	lookType = 947,
	lookHead = 19,
	lookBody = 11,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 3,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1379,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 10000
monster.maxHealth = 10000
monster.race = "blood"
monster.corpse = 25065
monster.speed = 175
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
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
	runHealth = 400,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3031, chance = 88760, maxCount = 129 }, -- Gold Coin
	{ id = 3035, chance = 68420, maxCount = 3 }, -- Platinum Coin
	{ id = 24937, chance = 100000 }, -- Dragon Blood
	{ id = 24938, chance = 100000 }, -- Dragon Tongue
	{ id = 24939, chance = 100000 }, -- Scale of Gelidrazah
	{ id = 3583, chance = 80860 }, -- Dragon Ham
	{ id = 7290, chance = 30140 }, -- Shard
	{ id = 3051, chance = 5740 }, -- Energy Ring
	{ id = 7441, chance = 5020 }, -- Ice Cube
	{ id = 3029, chance = 10770 }, -- Small Sapphire
	{ id = 815, chance = 25600 }, -- Glacier Amulet
	{ id = 829, chance = 8850 }, -- Glacier Mask
	{ id = 16118, chance = 3110 }, -- Glacial Rod
	{ id = 19362, chance = 9810 }, -- Icicle Bow
	{ id = 19363, chance = 6460 }, -- Runic Ice Shield
	{ id = 2903, chance = 4070 }, -- Golden Mug
	{ id = 8059, chance = 1200 }, -- Frozen Plate
	{ id = 7409, chance = 720 }, -- Northern Star
	{ id = 3061, chance = 480 }, -- Life Crystal
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 112, attack = 85 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -310, maxDamage = -495, range = 5, radius = 5, effect = CONST_ME_ICETORNADO, target = true },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -600, length = 9, spread = 3, effect = CONST_ME_ICEATTACK, target = false, duration = 10000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -310, maxDamage = -395, length = 9, spread = 3, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -210, maxDamage = -395, radius = 3, effect = CONST_ME_ICEAREA, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_LIFEDRAIN, minDamage = -150, maxDamage = -280, length = 8, spread = 3, effect = CONST_ME_POFF, target = false },
}

monster.defenses = {
	defense = 64,
	armor = 52,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 150, maxDamage = 450, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
