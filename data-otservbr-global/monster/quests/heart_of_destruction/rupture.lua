local mType = Game.createMonsterType("Rupture")
local monster = {}

monster.description = "Rupture"
monster.experience = 112000
monster.outfit = {
	lookType = 875,
	lookHead = 77,
	lookBody = 79,
	lookLegs = 3,
	lookFeet = 85,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1225,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 290000
monster.maxHealth = 290000
monster.race = "venom"
monster.corpse = 23564
monster.speed = 225
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 25,
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

monster.events = {
	"RuptureResonance",
	"RuptureHeal",
	"HeartBossDeath",
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
	{ id = 23535, chance = 100000, maxCount = 9 }, -- Energy Bar
	{ id = 23506, chance = 100000 }, -- Plasma Pearls
	{ id = 3035, chance = 100000, maxCount = 42 }, -- Platinum Coin
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 23510, chance = 100000 }, -- Odd Organ
	{ id = 22721, chance = 100000, maxCount = 7 }, -- Gold Token
	{ id = 3031, chance = 100000, maxCount = 377 }, -- Gold Coin
	{ id = 16121, chance = 78000, maxCount = 5 }, -- Green Crystal Shard
	{ id = 16119, chance = 72000, maxCount = 5 }, -- Blue Crystal Shard
	{ id = 16120, chance = 72000, maxCount = 5 }, -- Violet Crystal Shard
	{ id = 238, chance = 64000, maxCount = 15 }, -- Great Mana Potion
	{ id = 7643, chance = 58000, maxCount = 13 }, -- Ultimate Health Potion
	{ id = 7642, chance = 44000, maxCount = 10 }, -- Great Spirit Potion
	{ id = 3037, chance = 28000 }, -- Yellow Gem
	{ id = 9057, chance = 22000, maxCount = 18 }, -- Small Topaz
	{ id = 3029, chance = 22000, maxCount = 19 }, -- Small Sapphire
	{ id = 3032, chance = 22000, maxCount = 15 }, -- Small Emerald
	{ id = 3033, chance = 19400, maxCount = 19 }, -- Small Amethyst
	{ id = 23526, chance = 19400 }, -- Collar of Blue Plasma
	{ id = 23531, chance = 19400 }, -- Ring of Green Plasma
	{ id = 3041, chance = 19400 }, -- Blue Gem
	{ id = 23533, chance = 16700 }, -- Ring of Red Plasma
	{ id = 3038, chance = 16700 }, -- Green Gem
	{ id = 3039, chance = 16700 }, -- Red Gem
	{ id = 281, chance = 16700 }, -- Giant Shimmering Pearl
	{ id = 7427, chance = 16700 }, -- Chaos Mace
	{ id = 3028, chance = 13900, maxCount = 16 }, -- Small Diamond
	{ id = 7426, chance = 13900 }, -- Amber Staff
	{ id = 23476, chance = 11100 }, -- Void Boots
	{ id = 23529, chance = 11100 }, -- Ring of Blue Plasma
	{ id = 23543, chance = 11100 }, -- Collar of Green Plasma
	{ id = 23544, chance = 5600 }, -- Collar of Red Plasma
	{ id = 6553, chance = 2800 }, -- Ruthless Axe
	{ id = 7451, chance = 2800 }, -- Shadow Sceptre
	{ id = 49372, chance = 2800 }, -- Spiritualist Gem
	{ id = 822, chance = 2800 }, -- Lightning Legs
	{ id = 7403, chance = 2800 }, -- Berserker
	{ id = 828, chance = 2800 }, -- Lightning Headband
	{ id = 3036, chance = 2800 }, -- Violet Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -250, maxDamage = -1000 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -350, maxDamage = -800, length = 10, spread = 0, effect = CONST_ME_LOSEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -150, maxDamage = -300, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "rupture wave", interval = 2000, chance = 20, minDamage = -700, maxDamage = -1100, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -600, length = 9, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "anomaly break", interval = 2000, chance = 40, target = false },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 150, maxDamage = 400, effect = CONST_ME_MAGIC_BLUE, target = false },
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
