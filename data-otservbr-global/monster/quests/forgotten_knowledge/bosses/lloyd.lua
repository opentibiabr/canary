local mType = Game.createMonsterType("Lloyd")
local monster = {}

monster.description = "Lloyd"
monster.experience = 50000
monster.outfit = {
	lookType = 940,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"ForgottenKnowledgeBossDeath",
	"LloydPrepareDeath",
}

monster.bosstiary = {
	bossRaceId = 1329,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 64000
monster.maxHealth = 64000
monster.race = "venom"
monster.corpse = 24927
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20,
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
	runHealth = 1,
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
	{ id = 3031, chance = 100000, maxCount = 370 }, -- Gold Coin
	{ id = 8092, chance = 100000 }, -- Wand of Starstorm
	{ id = 3035, chance = 100000, maxCount = 38 }, -- Platinum Coin
	{ id = 3098, chance = 100000 }, -- Ring of Healing
	{ id = 7440, chance = 100000 }, -- Mastermind Potion
	{ id = 16121, chance = 73000, maxCount = 5 }, -- Green Crystal Shard
	{ id = 7642, chance = 65000, maxCount = 14 }, -- Great Spirit Potion
	{ id = 16120, chance = 65000, maxCount = 5 }, -- Violet Crystal Shard
	{ id = 16119, chance = 60000, maxCount = 5 }, -- Blue Crystal Shard
	{ id = 238, chance = 55000, maxCount = 13 }, -- Great Mana Potion
	{ id = 7643, chance = 49000, maxCount = 12 }, -- Ultimate Health Potion
	{ id = 23526, chance = 40000 }, -- Collar of Blue Plasma
	{ id = 11454, chance = 34000 }, -- Luminous Orb
	{ id = 8895, chance = 33000 }, -- Rusted Armor
	{ id = 22721, chance = 28000 }, -- Gold Token
	{ id = 9057, chance = 25000, maxCount = 19 }, -- Small Topaz
	{ id = 3038, chance = 24000 }, -- Green Gem
	{ id = 3032, chance = 24000, maxCount = 19 }, -- Small Emerald
	{ id = 3041, chance = 21000 }, -- Blue Gem
	{ id = 22516, chance = 19600 }, -- Silver Token
	{ id = 3028, chance = 18500, maxCount = 18 }, -- Small Diamond
	{ id = 3037, chance = 17400 }, -- Yellow Gem
	{ id = 3030, chance = 17400, maxCount = 19 }, -- Small Ruby
	{ id = 8073, chance = 16300 }, -- Spellbook of Warding
	{ id = 3039, chance = 16300 }, -- Red Gem
	{ id = 281, chance = 16300 }, -- Giant Shimmering Pearl
	{ id = 5909, chance = 15200, maxCount = 5 }, -- White Piece of Cloth
	{ id = 5888, chance = 14100, maxCount = 3 }, -- Piece of Hell Steel
	{ id = 3033, chance = 14100, maxCount = 19 }, -- Small Amethyst
	{ id = 10438, chance = 10900 }, -- Spellweaver's Robe
	{ id = 24393, chance = 8700 }, -- Pillow Backpack
	{ id = 24959, chance = 3700 }, -- Part of a Rune (Six)
	{ id = 3036, chance = 4300 }, -- Violet Gem
	{ id = 5904, chance = 4300 }, -- Magic Sulphur
	{ id = 822, chance = 4300 }, -- Lightning Legs
	{ id = 3387, chance = 3300 }, -- Demon Helmet
	{ id = 3079, chance = 3300 }, -- Boots of Haste
	{ id = 5891, chance = 1100 }, -- Enchanted Chicken Wing
	{ id = 24954, chance = 3700 }, -- Part of a Rune (One)
	{ id = 24955, chance = 3700 }, -- Part of a Rune (Two)
	{ id = 24956, chance = 3700 }, -- Part of a Rune (Three)
	{ id = 24957, chance = 3700 }, -- Part of a Rune (Four)
	{ id = 24958, chance = 3700 }, -- Part of a Rune (Five)
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -1400 },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_ENERGYDAMAGE, minDamage = -330, maxDamage = -660, length = 6, spread = 0, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "lloyd wave", interval = 2000, chance = 12, minDamage = -430, maxDamage = -560, target = false },
	{ name = "lloyd wave2", interval = 2000, chance = 12, minDamage = -230, maxDamage = -460, target = false },
	{ name = "lloyd wave3", interval = 2000, chance = 12, minDamage = -430, maxDamage = -660, target = false },
}

monster.defenses = {
	defense = 55,
	armor = 55,
	mitigation = 2.35,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 180, maxDamage = 250, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
