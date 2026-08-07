local mType = Game.createMonsterType("The Time Guardian")
local monster = {}

monster.description = "The Time Guardian"
monster.experience = 50000
monster.outfit = {
	lookType = 945,
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

monster.bosstiary = {
	bossRaceId = 1290,
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
	{ text = "This place is sacred!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 359 }, -- Gold Coin
	{ id = 3324, chance = 100000 }, -- Skull Staff
	{ id = 3035, chance = 100000, maxCount = 37 }, -- Platinum Coin
	{ id = 3098, chance = 100000 }, -- Ring of Healing
	{ id = 7440, chance = 100000 }, -- Mastermind Potion
	{ id = 16120, chance = 80000, maxCount = 5 }, -- Violet Crystal Shard
	{ id = 7642, chance = 60000, maxCount = 14 }, -- Great Spirit Potion
	{ id = 16121, chance = 55000, maxCount = 5 }, -- Green Crystal Shard
	{ id = 16119, chance = 50000, maxCount = 5 }, -- Blue Crystal Shard
	{ id = 238, chance = 45000, maxCount = 16 }, -- Great Mana Potion
	{ id = 7643, chance = 40000, maxCount = 14 }, -- Ultimate Health Potion
	{ id = 9057, chance = 40000, maxCount = 19 }, -- Small Topaz
	{ id = 3081, chance = 40000 }, -- Stone Skin Amulet
	{ id = 22516, chance = 40000 }, -- Silver Token
	{ id = 11454, chance = 40000 }, -- Luminous Orb
	{ id = 3028, chance = 30000, maxCount = 17 }, -- Small Diamond
	{ id = 281, chance = 25000 }, -- Giant Shimmering Pearl
	{ id = 3039, chance = 20000 }, -- Red Gem
	{ id = 5904, chance = 20000 }, -- Magic Sulphur
	{ id = 7387, chance = 20000 }, -- Diamond Sceptre
	{ id = 22721, chance = 15000 }, -- Gold Token
	{ id = 20062, chance = 15000 }, -- Cluster of Solace
	{ id = 5892, chance = 15000 }, -- Huge Chunk of Crude Iron
	{ id = 3041, chance = 15000 }, -- Blue Gem
	{ id = 3030, chance = 10000, maxCount = 19 }, -- Small Ruby
	{ id = 3036, chance = 10000 }, -- Violet Gem
	{ id = 3037, chance = 10000 }, -- Yellow Gem
	{ id = 3032, chance = 10000, maxCount = 12 }, -- Small Emerald
	{ id = 3038, chance = 10000 }, -- Green Gem
	{ id = 824, chance = 10000 }, -- Glacier Robe
	{ id = 823, chance = 10000 }, -- Glacier Kilt
	{ id = 24969, chance = 10000 }, -- Ancient Watch
	{ id = 3439, chance = 5000 }, -- Phoenix Shield
	{ id = 826, chance = 5000 }, -- Magma Coat
	{ id = 10323, chance = 5000 }, -- Guardian Boots
	{ id = 7417, chance = 5000 }, -- Runed Sword
	{ id = 5809, chance = 5000 }, -- Soul Stone
	{ id = 24956, chance = 3700 }, -- Part of a Rune (Three)
	{ id = 24954, chance = 3700 }, -- Part of a Rune (One)
	{ id = 24955, chance = 3700 }, -- Part of a Rune (Two)
	{ id = 24957, chance = 3700 }, -- Part of a Rune (Four)
	{ id = 24958, chance = 3700 }, -- Part of a Rune (Five)
	{ id = 24959, chance = 3700 }, -- Part of a Rune (Six)
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
	{ name = "time guardian", interval = 2000, chance = 10, target = false },
	{ name = "time guardiann", interval = 2000, chance = 10, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 80 },
	{ type = COMBAT_EARTHDAMAGE, percent = 80 },
	{ type = COMBAT_FIREDAMAGE, percent = 80 },
	{ type = COMBAT_LIFEDRAIN, percent = 80 },
	{ type = COMBAT_MANADRAIN, percent = 80 },
	{ type = COMBAT_DROWNDAMAGE, percent = 80 },
	{ type = COMBAT_ICEDAMAGE, percent = 80 },
	{ type = COMBAT_HOLYDAMAGE, percent = 80 },
	{ type = COMBAT_DEATHDAMAGE, percent = 80 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
