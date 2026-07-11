local mType = Game.createMonsterType("Realityquake")
local monster = {}

monster.description = "Realityquake"
monster.experience = 20000
monster.outfit = {
	lookTypeEx = 1949,
}

monster.bosstiary = {
	bossRaceId = 1218,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 110000
monster.maxHealth = 110000
monster.race = "venom"
monster.corpse = 23567
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 3000,
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
	{ id = 23507, chance = 100000 }, -- Crystallized Anger
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 3035, chance = 100000, maxCount = 45 }, -- Platinum Coin
	{ id = 3031, chance = 100000, maxCount = 367 }, -- Gold Coin
	{ id = 22721, chance = 100000, maxCount = 7 }, -- Gold Token
	{ id = 23508, chance = 100000 }, -- Energy Vein
	{ id = 23535, chance = 100000, maxCount = 9 }, -- Energy Bar
	{ id = 16120, chance = 68000, maxCount = 5 }, -- Violet Crystal Shard
	{ id = 16121, chance = 63000, maxCount = 5 }, -- Green Crystal Shard
	{ id = 238, chance = 61000, maxCount = 15 }, -- Great Mana Potion
	{ id = 16119, chance = 61000, maxCount = 5 }, -- Blue Crystal Shard
	{ id = 7643, chance = 54000, maxCount = 17 }, -- Ultimate Health Potion
	{ id = 7642, chance = 51000, maxCount = 9 }, -- Great Spirit Potion
	{ id = 3033, chance = 30000, maxCount = 19 }, -- Small Amethyst
	{ id = 3073, chance = 28000 }, -- Wand of Cosmic Energy
	{ id = 3037, chance = 25000 }, -- Yellow Gem
	{ id = 3039, chance = 23000 }, -- Red Gem
	{ id = 23476, chance = 23000 }, -- Void Boots
	{ id = 23531, chance = 23000 }, -- Ring of Green Plasma
	{ id = 3029, chance = 21000, maxCount = 17 }, -- Small Sapphire
	{ id = 3030, chance = 21000, maxCount = 19 }, -- Small Ruby
	{ id = 9057, chance = 17500, maxCount = 16 }, -- Small Topaz
	{ id = 3041, chance = 15800 }, -- Blue Gem
	{ id = 3038, chance = 14000 }, -- Green Gem
	{ id = 281, chance = 14000 }, -- Giant Shimmering Pearl
	{ id = 23543, chance = 14000 }, -- Collar of Green Plasma
	{ id = 23533, chance = 12300 }, -- Ring of Red Plasma
	{ id = 3032, chance = 10500, maxCount = 14 }, -- Small Emerald
	{ id = 3036, chance = 8800 }, -- Violet Gem
	{ id = 23529, chance = 8800 }, -- Ring of Blue Plasma
	{ id = 3333, chance = 8800 }, -- Crystal Mace
	{ id = 828, chance = 7000 }, -- Lightning Headband
	{ id = 23544, chance = 5300 }, -- Collar of Red Plasma
	{ id = 825, chance = 5300 }, -- Lightning Robe
	{ id = 23526, chance = 5300 }, -- Collar of Blue Plasma
	{ id = 23474, chance = 3500 }, -- Tiara of Power
	{ id = 3364, chance = 3500 }, -- Golden Legs
	{ id = 8050, chance = 3500 }, -- Crystalline Armor
	{ id = 7418, chance = 1800 }, -- Nightmare Blade
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -400, maxDamage = -1000 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -350, maxDamage = -800, length = 10, spread = 0, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = -350, maxDamage = -800, length = 10, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = -240, maxDamage = -600, radius = 5, effect = CONST_ME_POFF, target = true },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HOLYDAMAGE, minDamage = -240, maxDamage = -600, radius = 5, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYDAMAGE, target = true },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -450, length = 4, spread = 2, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -240, maxDamage = -600, radius = 5, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "anomaly break", interval = 2000, chance = 40, target = false },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, radius = 8, effect = CONST_ME_POFF, target = false },
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
