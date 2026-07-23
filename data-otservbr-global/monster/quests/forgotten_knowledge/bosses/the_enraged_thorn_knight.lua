local mType = Game.createMonsterType("The Enraged Thorn Knight")
local monster = {}

monster.description = "the enraged Thorn Knight"
monster.experience = 30000
monster.outfit = {
	lookType = 512,
	lookHead = 81,
	lookBody = 121,
	lookLegs = 121,
	lookFeet = 121,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"ForgottenKnowledgeBossDeath",
	"HealthForgotten",
}

monster.bosstiary = {
	bossRaceId = 1297,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 90000
monster.maxHealth = 90000
monster.race = "blood"
monster.corpse = 111
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
	runHealth = 15,
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
	{ text = "You've killed my only friend!", yell = false },
	{ text = "You will pay for this!", yell = false },
	{ text = "NOOOOO!", yell = true },
}

monster.loot = {
	{ id = 3318, chance = 100000 }, -- Knight Axe
	{ id = 3035, chance = 98000, maxCount = 39 }, -- Platinum Coin
	{ id = 3031, chance = 98000, maxCount = 198 }, -- Gold Coin
	{ id = 3098, chance = 96000 }, -- Ring of Healing
	{ id = 16119, chance = 71000, maxCount = 5 }, -- Blue Crystal Shard
	{ id = 16121, chance = 67000, maxCount = 5 }, -- Green Crystal Shard
	{ id = 7439, chance = 62000 }, -- Berserk Potion
	{ id = 16120, chance = 60000, maxCount = 5 }, -- Violet Crystal Shard
	{ id = 7643, chance = 60000, maxCount = 11 }, -- Ultimate Health Potion
	{ id = 238, chance = 56000, maxCount = 16 }, -- Great Mana Potion
	{ id = 7642, chance = 56000, maxCount = 13 }, -- Great Spirit Potion
	{ id = 9302, chance = 40000 }, -- Sacred Tree Amulet
	{ id = 7443, chance = 38000 }, -- Bullseye Potion
	{ id = 22721, chance = 31000 }, -- Gold Token
	{ id = 8895, chance = 29000 }, -- Rusted Armor
	{ id = 22516, chance = 29000 }, -- Silver Token
	{ id = 20203, chance = 27000 }, -- Trapped Bad Dream Monster
	{ id = 3038, chance = 24000 }, -- Green Gem
	{ id = 3030, chance = 24000, maxCount = 19 }, -- Small Ruby
	{ id = 3033, chance = 22000, maxCount = 14 }, -- Small Amethyst
	{ id = 6499, chance = 20000 }, -- Demonic Essence
	{ id = 3037, chance = 17800 }, -- Yellow Gem
	{ id = 3028, chance = 17800, maxCount = 19 }, -- Small Diamond
	{ id = 3041, chance = 15600 }, -- Blue Gem
	{ id = 5910, chance = 15600, maxCount = 5 }, -- Green Piece of Cloth
	{ id = 9057, chance = 13300, maxCount = 15 }, -- Small Topaz
	{ id = 3039, chance = 13300 }, -- Red Gem
	{ id = 7452, chance = 11100 }, -- Spiked Squelcher
	{ id = 3032, chance = 11100, maxCount = 17 }, -- Small Emerald
	{ id = 281, chance = 11100 }, -- Giant Shimmering Pearl
	{ id = 5875, chance = 8900 }, -- Sniper Gloves
	{ id = 8052, chance = 8900 }, -- Swamplair Armor
	{ id = 3036, chance = 6700 }, -- Violet Gem
	{ id = 7407, chance = 4400 }, -- Haunted Blade
	{ id = 5884, chance = 4400 }, -- Spirit Container
	{ id = 24954, chance = 3700 }, -- Part of a Rune (One)
	{ id = 24965, chance = 4400 }, -- Thorn Seed
	{ id = 3436, chance = 4400 }, -- Medusa Shield
	{ id = 3098, chance = 2200 }, -- Ring of Healing
	{ id = 3392, chance = 2200 }, -- Royal Helmet
	{ id = 5014, chance = 2200 }, -- Mandrake
	{ id = 7453, chance = 2200 }, -- Executioner
	{ id = 6553, chance = 2200 }, -- Ruthless Axe
	{ id = 24955, chance = 3700 }, -- Part of a Rune (Two)
	{ id = 24956, chance = 3700 }, -- Part of a Rune (Three)
	{ id = 24957, chance = 3700 }, -- Part of a Rune (Four)
	{ id = 24958, chance = 3700 }, -- Part of a Rune (Five)
	{ id = 24959, chance = 3700 }, -- Part of a Rune (Six)
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -600, maxDamage = -1000 },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_LIFEDRAIN, minDamage = -400, maxDamage = -700, length = 4, spread = 0, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_MANADRAIN, minDamage = -1400, maxDamage = -1700, length = 9, spread = 0, effect = CONST_ME_CARNIPHILA, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -700, length = 9, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -250, radius = 10, effect = CONST_ME_BLOCKHIT, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 60,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 1550, maxDamage = 2550, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 12, speedChange = 620, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000 },
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
	{ type = COMBAT_DEATHDAMAGE, percent = -100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

monster.heals = {
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

mType:register(monster)
