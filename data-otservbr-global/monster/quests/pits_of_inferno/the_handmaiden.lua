local mType = Game.createMonsterType("The Handmaiden")
local monster = {}

monster.description = "The Handmaiden"
monster.experience = 7500
monster.outfit = {
	lookType = 230,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 301,
	bossRace = RARITY_NEMESIS,
}

monster.health = 19500
monster.maxHealth = 19500
monster.race = "blood"
monster.corpse = 6311
monster.speed = 225
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 3100,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 184 }, -- Gold Coin
	{ id = 3035, chance = 52940, maxCount = 5 }, -- Platinum Coin
	{ id = 3050, chance = 5880 }, -- Power Ring
	{ id = 3051, chance = 5880 }, -- Energy Ring
	{ id = 3049, chance = 5880 }, -- Stealth Ring
	{ id = 3110, chance = 73685 }, -- Piece of Iron
	{ id = 3421, chance = 29410 }, -- Dark Shield
	{ id = 3116, chance = 26316 }, -- Big Bone
	{ id = 6299, chance = 11760 }, -- Death Ring
	{ id = 3554, chance = 23530 }, -- Steel Boots
	{ id = 3567, chance = 15785 }, -- Blue Robe
	{ id = 6499, chance = 100000 }, -- Demonic Essence
	{ id = 5944, chance = 100000 }, -- Soul Orb
	{ id = 6539, chance = 100000 }, -- The Handmaiden's Protector
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -800 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_MANADRAIN, minDamage = -150, maxDamage = -800, range = 7, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "drunk", interval = 1000, chance = 12, range = 1, target = true },
}

monster.defenses = {
	defense = 35,
	armor = 25,
	--	mitigation = ???,
	{ name = "speed", interval = 3000, chance = 12, speedChange = 380, effect = CONST_ME_MAGIC_RED, target = false, duration = 8000 },
	{ name = "invisible", interval = 4000, chance = 50, effect = CONST_ME_MAGIC_RED },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_HEALING, minDamage = 100, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 35, speedChange = 370, effect = CONST_ME_MAGIC_RED, target = false, duration = 30000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
