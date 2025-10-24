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
	{ id = 3035, chance = 100000 }, -- Platinum Coin
	{ id = 16119, chance = 55000 }, -- Blue Crystal Shard
	{ id = 20062, chance = 17500 }, -- Cluster of Solace
	{ id = 7440, chance = 100000 }, -- Mastermind Potion
	{ id = 3081, chance = 42500 }, -- Stone Skin Amulet
	{ id = 3031, chance = 100000 }, -- Gold Coin
	{ id = 3439, chance = 7500 }, -- Phoenix Shield
	{ id = 7643, chance = 55000 }, -- Ultimate Health Potion
	{ id = 3028, chance = 22500 }, -- Small Diamond
	{ id = 22721, chance = 27500 }, -- Gold Token
	{ id = 22516, chance = 32500 }, -- Silver Token
	{ id = 16120, chance = 55000 }, -- Violet Crystal Shard
	{ id = 3033, chance = 20000 }, -- Small Amethyst
	{ id = 3036, chance = 7500 }, -- Violet Gem
	{ id = 3098, chance = 100000 }, -- Ring of Healing
	{ id = 7417, chance = 2499 }, -- Runed Sword
	{ id = 3039, chance = 25000 }, -- Red Gem
	{ id = 238, chance = 65000 }, -- Great Mana Potion
	{ id = 16121, chance = 67500 }, -- Green Crystal Shard
	{ id = 11454, chance = 45000 }, -- Luminous Orb
	{ id = 3324, chance = 100000 }, -- Skull Staff
	{ id = 3041, chance = 20000 }, -- Blue Gem
	{ id = 3037, chance = 17500 }, -- Yellow Gem
	{ id = 3032, chance = 22500 }, -- Small Emerald
	{ id = 7387, chance = 15000 }, -- Diamond Sceptre
	{ id = 5809, chance = 15000 }, -- Soul Stone
	{ id = 7642, chance = 45000 }, -- Great Spirit Potion
	{ id = 281, chance = 12500 }, -- Giant Shimmering Pearl
	{ id = 5892, chance = 15000 }, -- Huge Chunk of Crude Iron
	{ id = 9057, chance = 15000 }, -- Small Topaz
	{ id = 826, chance = 2499 }, -- Magma Coat
	{ id = 3030, chance = 21428 }, -- Small Ruby
	{ id = 823, chance = 3571 }, -- Glacier Kilt
	{ id = 3038, chance = 17857 }, -- Green Gem
	{ id = 12306, chance = 3571 }, -- Leather Whip
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
