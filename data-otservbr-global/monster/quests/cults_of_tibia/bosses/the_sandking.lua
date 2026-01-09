local mType = Game.createMonsterType("The Sandking")
local monster = {}

monster.description = "The Sandking"
monster.experience = 0
monster.outfit = {
	lookType = 1013,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"CultsOfTibiaBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1444,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 50000
monster.maxHealth = 50000
monster.race = "venom"
monster.corpse = 25866
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 30,
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
	canPushCreatures = false,
	staticAttackChance = 95,
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

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "CRRRK!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 30 }, -- Platinum Coin
	{ id = 3028, chance = 15492, maxCount = 10 }, -- Small Diamond
	{ id = 3033, chance = 25352, maxCount = 10 }, -- Small Amethyst
	{ id = 3030, chance = 16901, maxCount = 10 }, -- Small Ruby
	{ id = 3032, chance = 20312, maxCount = 10 }, -- Small Emerald
	{ id = 9057, chance = 23943, maxCount = 10 }, -- Small Topaz
	{ id = 281, chance = 21126 }, -- Giant Shimmering Pearl
	{ id = 11454, chance = 46478 }, -- Luminous Orb
	{ id = 3324, chance = 100000 }, -- Skull Staff
	{ id = 16121, chance = 64788, maxCount = 3 }, -- Green Crystal Shard
	{ id = 16120, chance = 60563, maxCount = 3 }, -- Violet Crystal Shard
	{ id = 16119, chance = 64788, maxCount = 3 }, -- Blue Crystal Shard
	{ id = 7642, chance = 60563, maxCount = 10 }, -- Great Spirit Potion
	{ id = 238, chance = 60563, maxCount = 10 }, -- Great Mana Potion
	{ id = 7643, chance = 54929, maxCount = 10 }, -- Ultimate Health Potion
	{ id = 7440, chance = 100000 }, -- Mastermind Potion
	{ id = 3039, chance = 21126 }, -- Red Gem
	{ id = 3041, chance = 23943 }, -- Blue Gem
	{ id = 3038, chance = 15625 }, -- Green Gem
	{ id = 3036, chance = 6060 }, -- Violet Gem
	{ id = 3037, chance = 16901 }, -- Yellow Gem
	{ id = 3098, chance = 100000 }, -- Ring of Healing
	{ id = 20062, chance = 25000 }, -- Cluster of Solace
	{ id = 3067, chance = 15492 }, -- Hailstorm Rod
	{ id = 14087, chance = 12121 }, -- Grasshopper Legs
	{ id = 3341, chance = 8450 }, -- Arcane Staff
	{ id = 5892, chance = 16901 }, -- Huge Chunk of Crude Iron
	{ id = 5904, chance = 15625 }, -- Magic Sulphur
	{ id = 3339, chance = 3125 }, -- Djinn Blade
	{ id = 25360, chance = 3030 }, -- Heart of the Mountain (Item)
	{ id = 25361, chance = 1000 }, -- Blood of the Mountain (Item)
	{ id = 7417, chance = 4687 }, -- Runed Sword
	{ id = 11674, chance = 1000 }, -- Cobra Crown
	{ id = 7404, chance = 6250 }, -- Assassin Dagger
	{ id = 22721, chance = 23943 }, -- Gold Token
	{ id = 22516, chance = 21126 }, -- Silver Token
	{ id = 16161, chance = 6250 }, -- Crystalline Axe
	{ id = 14086, chance = 6250 }, -- Calopteryx Cape
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -500, range = 4, radius = 4, effect = CONST_ME_STONES, target = true },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -650, radius = 5, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
