local mType = Game.createMonsterType("Ragiaz")
local monster = {}

monster.description = "Ragiaz"
monster.experience = 500000
monster.outfit = {
	lookType = 862,
	lookHead = 76,
	lookBody = 57,
	lookLegs = 19,
	lookFeet = 0,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"AscendantBossesDeath",
}

monster.bosstiary = {
	bossRaceId = 1180,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 280000
monster.maxHealth = 280000
monster.race = "undead"
monster.corpse = 22495
monster.speed = 170
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
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 348 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 37 }, -- Platinum Coin
	{ id = 22516, chance = 100000 }, -- Silver Token
	{ id = 16127, chance = 83000, maxCount = 7 }, -- Green Crystal Fragment
	{ id = 16125, chance = 78000, maxCount = 7 }, -- Cyan Crystal Fragment
	{ id = 7642, chance = 78000, maxCount = 18 }, -- Great Spirit Potion
	{ id = 6499, chance = 72000 }, -- Demonic Essence
	{ id = 16126, chance = 69000, maxCount = 7 }, -- Red Crystal Fragment
	{ id = 238, chance = 64000, maxCount = 13 }, -- Great Mana Potion
	{ id = 6558, chance = 56000, maxCount = 9 }, -- Flask of Demonic Blood
	{ id = 3098, chance = 36000 }, -- Ring of Healing
	{ id = 7643, chance = 36000, maxCount = 8 }, -- Ultimate Health Potion
	{ id = 3029, chance = 31000, maxCount = 9 }, -- Small Sapphire
	{ id = 3032, chance = 28000, maxCount = 9 }, -- Small Emerald
	{ id = 3041, chance = 25000 }, -- Blue Gem
	{ id = 3030, chance = 22000, maxCount = 7 }, -- Small Ruby
	{ id = 3039, chance = 22000 }, -- Red Gem
	{ id = 3037, chance = 19400 }, -- Yellow Gem
	{ id = 281, chance = 16700 }, -- Giant Shimmering Pearl
	{ id = 3324, chance = 13900 }, -- Skull Staff
	{ id = 22867, chance = 11100 }, -- Rift Crossbow
	{ id = 3038, chance = 11100 }, -- Green Gem
	{ id = 22726, chance = 11100 }, -- Rift Shield
	{ id = 9057, chance = 11100, maxCount = 7 }, -- Small Topaz
	{ id = 3033, chance = 8300, maxCount = 8 }, -- Small Amethyst
	{ id = 22866, chance = 5600 }, -- Rift Bow
	{ id = 3036, chance = 5600 }, -- Violet Gem
	{ id = 22727, chance = 5600 }, -- Rift Lance
	{ id = 7428, chance = 2800 }, -- Bonebreaker
	{ id = 7426, chance = 2800 }, -- Amber Staff
	{ id = 6299, chance = 2800 }, -- Death Ring
	{ id = 3364, chance = 2800 }, -- Golden Legs
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1400, maxDamage = -2300 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -900, radius = 4, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -900, range = 4, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_POFF, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -1000, maxDamage = -1200, length = 10, spread = 3, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -1500, maxDamage = -1900, length = 10, spread = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -600, radius = 7, effect = CONST_ME_POFF, target = false, duration = 20000 },
}

monster.defenses = {
	defense = 125,
	armor = 125,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 2000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 20, speedChange = 600, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 4000 },
	{ name = "ragiaz transform", interval = 2000, chance = 8, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 90 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
