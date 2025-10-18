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
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 35 }, -- Platinum Coin
	{ id = 23545, chance = 99829, maxCount = 5 }, -- Energy Drink
	{ id = 23535, chance = 99829, maxCount = 5 }, -- Energy Bar
	{ id = 238, chance = 56410, maxCount = 10 }, -- Great Mana Potion
	{ id = 7643, chance = 51111, maxCount = 10 }, -- Ultimate Health Potion
	{ id = 16121, chance = 64102, maxCount = 3 }, -- Green Crystal Shard
	{ id = 16119, chance = 63418, maxCount = 3 }, -- Blue Crystal Shard
	{ id = 16120, chance = 58290, maxCount = 3 }, -- Violet Crystal Shard
	{ id = 9057, chance = 12649, maxCount = 20 }, -- Small Topaz
	{ id = 23509, chance = 99829 }, -- Mysterious Remains
	{ id = 23507, chance = 92991 }, -- Crystallized Anger
	{ id = 23508, chance = 92991 }, -- Energy Vein
	{ id = 3038, chance = 14017 }, -- Green Gem
	{ id = 23529, chance = 14358 }, -- Ring of Blue Plasma
	{ id = 23474, 23475, chance = 57264 }, -- Tiara of Power
	{ id = 23476, 23477, chance = 74529 }, -- Void Boots
	{ id = 22721, chance = 99829, maxCount = 23 }, -- Gold Token
	{ id = 23686, chance = 1025 }, -- Devourer Core
	{ id = 23684, chance = 1000 }, -- Crackling Egg
	{ id = 23685, chance = 507 }, -- Menacing Egg
	{ id = 23543, chance = 9059 }, -- Collar of Green Plasma
	{ id = 23544, chance = 9401 }, -- Collar of Red Plasma
	{ id = 7642, chance = 52991, maxCount = 10 }, -- Great Spirit Potion
	{ id = 3029, chance = 15897 }, -- Small Sapphire
	{ id = 3030, chance = 17264 }, -- Small Ruby
	{ id = 3037, chance = 16923 }, -- Yellow Gem
	{ id = 3032, chance = 14529 }, -- Small Emerald
	{ id = 3364, chance = 1880 }, -- Golden Legs
	{ id = 281, chance = 11452 }, -- Giant Shimmering Pearl
	{ id = 828, chance = 7692 }, -- Lightning Headband
	{ id = 3033, chance = 14188 }, -- Small Amethyst
	{ id = 23533, chance = 12478 }, -- Ring of Red Plasma
	{ id = 3039, chance = 12649 }, -- Red Gem
	{ id = 23526, chance = 8717 }, -- Collar of Blue Plasma
	{ id = 3324, chance = 12991 }, -- Skull Staff
	{ id = 3041, chance = 16581 }, -- Blue Gem
	{ id = 7426, chance = 7521 }, -- Amber Staff
	{ id = 8027, chance = 1880 }, -- Composite Hornbow
	{ id = 23531, chance = 11623 }, -- Ring of Green Plasma
	{ id = 3036, chance = 3076 }, -- Violet Gem
	{ id = 7428, chance = 7008 }, -- Bonebreaker
	{ id = 8050, chance = 2735 }, -- Crystalline Armor
	{ id = 7417, chance = 257 }, -- Runed Sword
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
