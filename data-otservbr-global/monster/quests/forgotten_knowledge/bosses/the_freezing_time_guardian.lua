local mType = Game.createMonsterType("The Freezing Time Guardian")
local monster = {}

monster.description = "The Freezing Time Guardian"
monster.experience = 50000
monster.outfit = {
	lookType = 943,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"ForgottenKnowledgeBossDeath",
}

monster.health = 150000
monster.maxHealth = 150000
monster.race = "undead"
monster.corpse = 25085
monster.speed = 170
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5,
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
	level = 5,
	color = 107,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 377 }, -- Gold Coin
	{ id = 3098, chance = 100000 }, -- Ring of Healing
	{ id = 3035, chance = 100000, maxCount = 41 }, -- Platinum Coin
	{ id = 3324, chance = 100000 }, -- Skull Staff
	{ id = 7440, chance = 100000 }, -- Mastermind Potion
	{ id = 238, chance = 75000, maxCount = 13 }, -- Great Mana Potion
	{ id = 16120, chance = 64000, maxCount = 5 }, -- Violet Crystal Shard
	{ id = 16119, chance = 61000, maxCount = 5 }, -- Blue Crystal Shard
	{ id = 16121, chance = 57000, maxCount = 5 }, -- Green Crystal Shard
	{ id = 7642, chance = 50000, maxCount = 9 }, -- Great Spirit Potion
	{ id = 3081, chance = 43000 }, -- Stone Skin Amulet
	{ id = 7643, chance = 39000, maxCount = 10 }, -- Ultimate Health Potion
	{ id = 11454, chance = 36000 }, -- Luminous Orb
	{ id = 22721, chance = 29000 }, -- Gold Token
	{ id = 22516, chance = 25000 }, -- Silver Token
	{ id = 3039, chance = 25000 }, -- Red Gem
	{ id = 3041, chance = 25000 }, -- Blue Gem
	{ id = 3030, chance = 21000, maxCount = 16 }, -- Small Ruby
	{ id = 3033, chance = 21000, maxCount = 17 }, -- Small Amethyst
	{ id = 3032, chance = 21000, maxCount = 16 }, -- Small Emerald
	{ id = 20062, chance = 21000 }, -- Cluster of Solace
	{ id = 9057, chance = 17900, maxCount = 17 }, -- Small Topaz
	{ id = 5892, chance = 17900 }, -- Huge Chunk of Crude Iron
	{ id = 3037, chance = 17900 }, -- Yellow Gem
	{ id = 3038, chance = 17900 }, -- Green Gem
	{ id = 3028, chance = 14300, maxCount = 19 }, -- Small Diamond
	{ id = 7387, chance = 14300 }, -- Diamond Sceptre
	{ id = 5809, chance = 14300 }, -- Soul Stone
	{ id = 3439, chance = 7100 }, -- Phoenix Shield
	{ id = 10323, chance = 7100 }, -- Guardian Boots
	{ id = 281, chance = 7100 }, -- Giant Shimmering Pearl
	{ id = 24970, chance = 7100 }, -- Frozen Time
	{ id = 3036, chance = 3600 }, -- Violet Gem
	{ id = 5904, chance = 3600 }, -- Magic Sulphur
	{ id = 12306, chance = 3600 }, -- Leather Whip
	{ id = 824, chance = 3600 }, -- Glacier Robe
	{ id = 823, chance = 3600 }, -- Glacier Kilt
	{ id = 826, chance = 0 }, -- Magma Coat
	{ id = 7417, chance = 0 }, -- Runed Sword
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 190, attack = 300 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -600, maxDamage = -780, range = 7, radius = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -600, maxDamage = -780, length = 9, spread = 0, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -600, maxDamage = -780, length = 9, spread = 0, effect = CONST_ME_ENERGYAREA, target = false },
	-- energy damage
	{ name = "condition", type = CONDITION_ENERGY, interval = 2000, chance = 20, minDamage = -2000, maxDamage = -2000, radius = 7, effect = CONST_ME_BLOCKHIT, target = false },
	-- bleed
	{ name = "condition", type = CONDITION_BLEEDING, interval = 2000, chance = 20, minDamage = -2000, maxDamage = -2000, length = 9, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
}

monster.defenses = {
	defense = 70,
	armor = 70,
	--	mitigation = ???,
	{ name = "time guardian lost time", interval = 2000, chance = 10, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -1 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.heals = {
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
