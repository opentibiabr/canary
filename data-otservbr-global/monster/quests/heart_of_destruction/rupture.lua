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
	{ id = 22721, chance = 100000, maxCount = 4 }, -- Gold Token
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 3031, chance = 100000, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 30 }, -- Platinum Coin
	{ id = 23476, 23477, chance = 18699 }, -- Void Boots
	{ id = 281, chance = 15447 }, -- Giant Shimmering Pearl
	{ id = 23535, chance = 100000, maxCount = 3 }, -- Energy Bar
	{ id = 3036, chance = 9756 }, -- Violet Gem
	{ id = 7427, chance = 14634 }, -- Chaos Mace
	{ id = 3033, chance = 13008, maxCount = 10 }, -- Small Amethyst
	{ id = 7643, chance = 52032, maxCount = 5 }, -- Ultimate Health Potion
	{ id = 9057, chance = 19512, maxCount = 10 }, -- Small Topaz
	{ id = 23529, chance = 14634 }, -- Ring of Blue Plasma
	{ id = 7642, chance = 60975, maxCount = 5 }, -- Great Spirit Potion
	{ id = 23533, chance = 16260 }, -- Ring of Red Plasma
	{ id = 23543, chance = 7317 }, -- Collar of Green Plasma
	{ id = 23510, chance = 100000 }, -- Odd Organ
	{ id = 8050, chance = 7142 }, -- Crystalline Armor
	{ id = 23506, chance = 100000 }, -- Plasma Pearls
	{ id = 16121, chance = 73170, maxCount = 3 }, -- Green Crystal Shard
	{ id = 16120, chance = 70731, maxCount = 3 }, -- Violet Crystal Shard
	{ id = 16119, chance = 61788, maxCount = 3 }, -- Blue Crystal Shard
	{ id = 23474, 23475, chance = 3738 }, -- Tiara of Power
	{ id = 3029, chance = 26829 }, -- Small Sapphire
	{ id = 3039, chance = 21138 }, -- Red Gem
	{ id = 7426, chance = 10569 }, -- Amber Staff
	{ id = 238, chance = 52032 }, -- Great Mana Potion
	{ id = 23531, chance = 17757 }, -- Ring of Green Plasma
	{ id = 3028, chance = 18699 }, -- Small Diamond
	{ id = 23544, chance = 10569 }, -- Collar of Red Plasma
	{ id = 3032, chance = 21951 }, -- Small Emerald
	{ id = 828, chance = 11214 }, -- Lightning Headband
	{ id = 3038, chance = 16260 }, -- Green Gem
	{ id = 7451, chance = 14953 }, -- Shadow Sceptre
	{ id = 3037, chance = 21951 }, -- Yellow Gem
	{ id = 822, chance = 4878 }, -- Lightning Legs
	{ id = 23526, chance = 12195 }, -- Collar of Blue Plasma
	{ id = 3041, chance = 15447 }, -- Blue Gem
	{ id = 6553, chance = 1869 }, -- Ruthless Axe
	{ id = 7403, chance = 2777 }, -- Berserker
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
