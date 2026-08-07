local mType = Game.createMonsterType("Anomaly")
local monster = {}

monster.description = "anomaly"
monster.experience = 50000
monster.outfit = {
	lookType = 876,
	lookHead = 38,
	lookBody = 79,
	lookLegs = 76,
	lookFeet = 79,
	lookAddons = 1,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1219,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 290000
monster.maxHealth = 290000
monster.race = "venom"
monster.corpse = 23564
monster.speed = 200
monster.manaCost = 0

monster.events = {
	"AnomalyTransform",
	"HeartBossDeath",
}

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

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 23511, chance = 100000 }, -- Curious Matter
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 3035, chance = 100000, maxCount = 47 }, -- Platinum Coin
	{ id = 3031, chance = 100000, maxCount = 347 }, -- Gold Coin
	{ id = 22721, chance = 100000, maxCount = 7 }, -- Gold Token
	{ id = 23519, chance = 100000 }, -- Frozen Lightning
	{ id = 23545, chance = 100000, maxCount = 9 }, -- Energy Drink
	{ id = 16121, chance = 72000, maxCount = 5 }, -- Green Crystal Shard
	{ id = 16119, chance = 68000, maxCount = 5 }, -- Blue Crystal Shard
	{ id = 16120, chance = 64000, maxCount = 5 }, -- Violet Crystal Shard
	{ id = 238, chance = 63000, maxCount = 16 }, -- Great Mana Potion
	{ id = 7642, chance = 55000, maxCount = 15 }, -- Great Spirit Potion
	{ id = 7643, chance = 49000, maxCount = 15 }, -- Ultimate Health Potion
	{ id = 3030, chance = 24000, maxCount = 19 }, -- Small Ruby
	{ id = 3028, chance = 22000, maxCount = 19 }, -- Small Diamond
	{ id = 3041, chance = 21000 }, -- Blue Gem
	{ id = 3037, chance = 21000 }, -- Yellow Gem
	{ id = 23531, chance = 21000 }, -- Ring of Green Plasma
	{ id = 3038, chance = 21000 }, -- Green Gem
	{ id = 9057, chance = 19000, maxCount = 18 }, -- Small Topaz
	{ id = 3033, chance = 19000, maxCount = 19 }, -- Small Amethyst
	{ id = 3039, chance = 17500 }, -- Red Gem
	{ id = 23476, chance = 17500 }, -- Void Boots
	{ id = 23533, chance = 17500 }, -- Ring of Red Plasma
	{ id = 8073, chance = 16700 }, -- Spellbook of Warding
	{ id = 3032, chance = 15900, maxCount = 18 }, -- Small Emerald
	{ id = 281, chance = 15100 }, -- Giant Shimmering Pearl
	{ id = 23529, chance = 13500 }, -- Ring of Blue Plasma
	{ id = 7427, chance = 12700 }, -- Chaos Mace
	{ id = 7451, chance = 11900 }, -- Shadow Sceptre
	{ id = 828, chance = 10300 }, -- Lightning Headband
	{ id = 23526, chance = 9500 }, -- Collar of Blue Plasma
	{ id = 23544, chance = 9500 }, -- Collar of Red Plasma
	{ id = 23543, chance = 9500 }, -- Collar of Green Plasma
	{ id = 822, chance = 6300 }, -- Lightning Legs
	{ id = 23474, chance = 5600 }, -- Tiara of Power
	{ id = 825, chance = 3200 }, -- Lightning Robe
	{ id = 6553, chance = 2400 }, -- Ruthless Axe
	{ id = 16160, chance = 1600 }, -- Crystalline Sword
	{ id = 3036, chance = 790 }, -- Violet Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -300, maxDamage = -1400 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -300, maxDamage = -600, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "anomaly wave", interval = 2000, chance = 25, minDamage = -500, maxDamage = -900, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = -600, maxDamage = -1000, length = 9, spread = 0, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -600, length = 9, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "anomaly break", interval = 2000, chance = 40, target = false },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 150, maxDamage = 400, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
