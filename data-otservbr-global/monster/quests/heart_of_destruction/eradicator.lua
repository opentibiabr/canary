local mType = Game.createMonsterType("Eradicator")
local monster = {}

monster.description = "Eradicator"
monster.experience = 50000
monster.outfit = {
	lookType = 875,
	lookHead = 79,
	lookBody = 3,
	lookLegs = 114,
	lookFeet = 79,
	lookAddons = 1,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1226,
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
	"HeartBossDeath",
	"EradicatorTransform",
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
	{ id = 23535, chance = 100000 }, -- Energy Bar
	{ id = 3035, chance = 100000, maxCount = 42 }, -- Platinum Coin
	{ id = 23518, chance = 100000 }, -- Spark Sphere
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 23520, chance = 100000 }, -- Plasmatic Lightning
	{ id = 22721, chance = 100000, maxCount = 7 }, -- Gold Token
	{ id = 3031, chance = 100000, maxCount = 387 }, -- Gold Coin
	{ id = 16119, chance = 66000, maxCount = 5 }, -- Blue Crystal Shard
	{ id = 16120, chance = 63000, maxCount = 5 }, -- Violet Crystal Shard
	{ id = 16121, chance = 58000, maxCount = 5 }, -- Green Crystal Shard
	{ id = 238, chance = 56000, maxCount = 14 }, -- Great Mana Potion
	{ id = 7643, chance = 54000, maxCount = 18 }, -- Ultimate Health Potion
	{ id = 7642, chance = 52000, maxCount = 17 }, -- Great Spirit Potion
	{ id = 3028, chance = 25000, maxCount = 19 }, -- Small Diamond
	{ id = 3039, chance = 24000 }, -- Red Gem
	{ id = 9057, chance = 22000, maxCount = 19 }, -- Small Topaz
	{ id = 3037, chance = 21000 }, -- Yellow Gem
	{ id = 3033, chance = 21000, maxCount = 19 }, -- Small Amethyst
	{ id = 23476, chance = 20000 }, -- Void Boots
	{ id = 3032, chance = 19200, maxCount = 19 }, -- Small Emerald
	{ id = 3041, chance = 18300 }, -- Blue Gem
	{ id = 3038, chance = 18300 }, -- Green Gem
	{ id = 23533, chance = 17500 }, -- Ring of Red Plasma
	{ id = 23529, chance = 16700 }, -- Ring of Blue Plasma
	{ id = 281, chance = 15800 }, -- Giant Shimmering Pearl
	{ id = 23543, chance = 13300 }, -- Collar of Green Plasma
	{ id = 3030, chance = 13300, maxCount = 19 }, -- Small Ruby
	{ id = 7426, chance = 12500 }, -- Amber Staff
	{ id = 8073, chance = 12500 }, -- Spellbook of Warding
	{ id = 3333, chance = 11700 }, -- Crystal Mace
	{ id = 8075, chance = 10800 }, -- Spellbook of Lost Souls
	{ id = 23531, chance = 10000 }, -- Ring of Green Plasma
	{ id = 23544, chance = 10000 }, -- Collar of Red Plasma
	{ id = 23526, chance = 5000 }, -- Collar of Blue Plasma
	{ id = 23474, chance = 5000 }, -- Tiara of Power
	{ id = 7421, chance = 4200 }, -- Onyx Flail
	{ id = 3036, chance = 2500 }, -- Violet Gem
	{ id = 7388, chance = 1700 }, -- Vile Axe
	{ id = 8050, chance = 1700 }, -- Crystalline Armor
	{ id = 3554, chance = 830 }, -- Steel Boots
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -300, maxDamage = -1800 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -600, maxDamage = -1000, length = 8, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -600, maxDamage = -1000, length = 8, spread = 0, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -450, maxDamage = -900, radius = 8, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "big energy wave", interval = 2000, chance = 20, minDamage = -700, maxDamage = -1000, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -300, maxDamage = -600, radius = 4, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "anomaly break", interval = 2000, chance = 40, target = false },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 50 },
	{ type = COMBAT_MANADRAIN, percent = 50 },
	{ type = COMBAT_DROWNDAMAGE, percent = 50 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
