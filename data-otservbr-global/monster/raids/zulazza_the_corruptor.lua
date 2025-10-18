local mType = Game.createMonsterType("Zulazza the Corruptor")
local monster = {}

monster.description = "Zulazza the Corruptor"
monster.experience = 10000
monster.outfit = {
	lookType = 334,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 628,
	bossRace = RARITY_NEMESIS,
}

monster.health = 46500
monster.maxHealth = 46500
monster.race = "blood"
monster.corpse = 10190
monster.speed = 145
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 1500,
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
	{ text = "I'm Zulazza, and you won't forget me that fazzt.", yell = false },
	{ text = "Oh, HE will take revenge on zzizz azzault when you zztep in front of HIZZ fazze!", yell = false },
	{ text = "Zzaion is our last zztand! I will not leave wizzout a fight!", yell = false },
	{ text = "Behind zze Great Gate liezz your doom!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 99 }, -- Gold Coin
	{ id = 3035, chance = 64131, maxCount = 29 }, -- Platinum Coin
	{ id = 7366, chance = 22782, maxCount = 46 }, -- Viper Star
	{ id = 5944, chance = 23791, maxCount = 5 }, -- Soul Orb
	{ id = 9058, chance = 47259, maxCount = 4 }, -- Gold Ingot
	{ id = 281, chance = 35079, maxCount = 2 }, -- Giant Shimmering Pearl
	{ id = 3010, chance = 17739 }, -- Emerald Bangle
	{ id = 7643, chance = 15551 }, -- Ultimate Health Potion
	{ id = 239, chance = 14921 }, -- Great Health Potion
	{ id = 238, chance = 13307 }, -- Great Mana Potion
	{ id = 7642, chance = 17723 }, -- Great Spirit Potion
	{ id = 7440, chance = 15325 }, -- Mastermind Potion
	{ id = 3039, chance = 25318 }, -- Red Gem
	{ id = 3037, chance = 22987 }, -- Yellow Gem
	{ id = 3038, chance = 15727 }, -- Green Gem
	{ id = 3041, chance = 14112 }, -- Blue Gem
	{ id = 3036, chance = 18144 }, -- Violet Gem
	{ id = 10406, chance = 1000 }, -- Zaoan Halberd
	{ id = 3415, chance = 10548 }, -- Guardian Shield
	{ id = 3428, chance = 6983 }, -- Tower Shield
	{ id = 8896, chance = 48261 }, -- Slightly Rusted Armor
	{ id = 8063, chance = 9548 }, -- Paladin Armor
	{ id = 3414, chance = 9996 }, -- Mastermind Shield
	{ id = 10201, chance = 1780 }, -- Dragon Scale Boots
	{ id = 8054, chance = 1180 }, -- Earthborn Titan Armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 200, attack = 200 },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = -500, maxDamage = -800, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -800, radius = 3, effect = CONST_ME_POISONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_MANADRAIN, minDamage = -50, maxDamage = -130, range = 7, effect = CONST_ME_MAGIC_GREEN, target = true },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -500, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000 },
}

monster.defenses = {
	defense = 119,
	armor = 96,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 2000, maxDamage = 3000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 70 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
