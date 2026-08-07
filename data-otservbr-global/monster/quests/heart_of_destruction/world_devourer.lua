local mType = Game.createMonsterType("World Devourer")
local monster = {}

monster.description = "World Devourer"
monster.experience = 77700
monster.outfit = {
	lookType = 875,
	lookHead = 82,
	lookBody = 79,
	lookLegs = 84,
	lookFeet = 94,
	lookAddons = 3,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1228,
	bossRace = RARITY_NEMESIS,
}

monster.health = 25000
monster.maxHealth = 25000
monster.race = "venom"
monster.corpse = 0
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
	{ id = 3031, chance = 100000, maxCount = 361 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 46 }, -- Platinum Coin
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 23545, chance = 100000, maxCount = 12 }, -- Energy Drink
	{ id = 22721, chance = 100000, maxCount = 26 }, -- Gold Token
	{ id = 23535, chance = 100000, maxCount = 9 }, -- Energy Bar
	{ id = 23508, chance = 87000 }, -- Energy Vein
	{ id = 23507, chance = 87000 }, -- Crystallized Anger
	{ id = 23476, chance = 69000 }, -- Void Boots
	{ id = 16119, chance = 60000, maxCount = 8 }, -- Blue Crystal Shard
	{ id = 16121, chance = 59000, maxCount = 6 }, -- Green Crystal Shard
	{ id = 16120, chance = 53000, maxCount = 5 }, -- Violet Crystal Shard
	{ id = 7643, chance = 52000, maxCount = 16 }, -- Ultimate Health Potion
	{ id = 238, chance = 51000, maxCount = 18 }, -- Great Mana Potion
	{ id = 7642, chance = 51000, maxCount = 17 }, -- Great Spirit Potion
	{ id = 23474, chance = 50000 }, -- Tiara of Power
	{ id = 3037, chance = 19700 }, -- Yellow Gem
	{ id = 3032, chance = 17400, maxCount = 39 }, -- Small Emerald
	{ id = 3030, chance = 16500, maxCount = 39 }, -- Small Ruby
	{ id = 3029, chance = 15100, maxCount = 37 }, -- Small Sapphire
	{ id = 3324, chance = 14200 }, -- Skull Staff
	{ id = 23531, chance = 13800 }, -- Ring of Green Plasma
	{ id = 3038, chance = 13300 }, -- Green Gem
	{ id = 23529, chance = 13300 }, -- Ring of Blue Plasma
	{ id = 23533, chance = 12400 }, -- Ring of Red Plasma
	{ id = 3033, chance = 11900, maxCount = 39 }, -- Small Amethyst
	{ id = 281, chance = 11500 }, -- Giant Shimmering Pearl
	{ id = 3041, chance = 11000 }, -- Blue Gem
	{ id = 3039, chance = 10100 }, -- Red Gem
	{ id = 9057, chance = 8300, maxCount = 39 }, -- Small Topaz
	{ id = 23544, chance = 7800 }, -- Collar of Red Plasma
	{ id = 828, chance = 7300 }, -- Lightning Headband
	{ id = 23526, chance = 7300 }, -- Collar of Blue Plasma
	{ id = 7426, chance = 7300 }, -- Amber Staff
	{ id = 7428, chance = 5500 }, -- Bonebreaker
	{ id = 23543, chance = 5500 }, -- Collar of Green Plasma
	{ id = 3036, chance = 4100 }, -- Violet Gem
	{ id = 8027, chance = 3200 }, -- Composite Hornbow
	{ id = 8050, chance = 2800 }, -- Crystalline Armor
	{ id = 3364, chance = 1800 }, -- Golden Legs
	{ id = 23686, chance = 920 }, -- Devourer Core
	{ id = 23685, chance = 460 }, -- Menacing Egg
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1600 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -400, maxDamage = -800, length = 10, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -800, radius = 4, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -800, radius = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_YELLOWENERGY, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -600, maxDamage = -1200, length = 10, spread = 0, effect = CONST_ME_LOSEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, radius = 8, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "anomaly break", interval = 2000, chance = 40, target = false },
	{ name = "devourer summon", interval = 2000, chance = 25, target = false },
}

monster.defenses = {
	defense = 150,
	armor = 150,
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
