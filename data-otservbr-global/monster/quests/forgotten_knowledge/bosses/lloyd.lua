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
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 30 }, -- Platinum Coin
	{ id = 238, chance = 54741, maxCount = 10 }, -- Great Mana Potion
	{ id = 7642, chance = 55844, maxCount = 5 }, -- Great Spirit Potion
	{ id = 7643, chance = 54824, maxCount = 10 }, -- Ultimate Health Potion
	{ id = 16121, chance = 68103, maxCount = 3 }, -- Green Crystal Shard
	{ id = 16120, chance = 63793, maxCount = 3 }, -- Violet Crystal Shard
	{ id = 16119, chance = 62500, maxCount = 3 }, -- Blue Crystal Shard
	{ id = 5888, chance = 18421, maxCount = 2 }, -- Piece of Hell Steel
	{ id = 5887, chance = 3164, maxCount = 2 }, -- Piece of Royal Steel
	{ id = 5909, chance = 15584, maxCount = 3 }, -- White Piece of Cloth
	{ id = 3033, chance = 19298, maxCount = 10 }, -- Small Amethyst
	{ id = 3028, chance = 21052, maxCount = 10 }, -- Small Diamond
	{ id = 3032, chance = 26754, maxCount = 10 }, -- Small Emerald
	{ id = 3030, chance = 14912, maxCount = 10 }, -- Small Ruby
	{ id = 9057, chance = 18614, maxCount = 10 }, -- Small Topaz
	{ id = 3039, chance = 23376 }, -- Red Gem
	{ id = 3041, chance = 22807 }, -- Blue Gem
	{ id = 3038, chance = 17748 }, -- Green Gem
	{ id = 3037, chance = 17543 }, -- Yellow Gem
	{ id = 11454, chance = 37229 }, -- Luminous Orb
	{ id = 281, chance = 14718 }, -- Giant Shimmering Pearl
	{ id = 3079, chance = 3333 }, -- Boots of Haste
	{ id = 22727, chance = 2564 }, -- Rift Lance
	{ id = 7424, chance = 1282 }, -- Lunar Staff
	{ id = 23526, chance = 41558 }, -- Collar of Blue Plasma
	{ id = 8895, chance = 24675 }, -- Rusted Armor
	{ id = 8092, chance = 100000 }, -- Wand of Starstorm
	{ id = 3387, chance = 4054 }, -- Demon Helmet
	{ id = 822, chance = 4385 }, -- Lightning Legs
	{ id = 7440, chance = 99137 }, -- Mastermind Potion
	{ id = 5904, chance = 5696 }, -- Magic Sulphur
	{ id = 3098, chance = 100000 }, -- Ring of Healing
	{ id = 8072, chance = 1000 }, -- Spellbook of Enlightenment
	{ id = 8073, chance = 10526 }, -- Spellbook of Warding
	{ id = 10438, chance = 7456 }, -- Spellweaver's Robe
	{ id = 5891, chance = 1960 }, -- Enchanted Chicken Wing
	{ id = 24393, chance = 5701 }, -- Pillow Backpack
	{ id = 22516, chance = 20175, maxCount = 2 }, -- Silver Token
	{ id = 22721, chance = 29385 }, -- Gold Token
	{ id = 24959, chance = 6081 }, -- Part of a Rune (Six)
	{ id = 3036, chance = 3947 }, -- Violet Gem
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
