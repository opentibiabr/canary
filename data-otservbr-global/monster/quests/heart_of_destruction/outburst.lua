local mType = Game.createMonsterType("Outburst")
local monster = {}

monster.description = "Outburst"
monster.experience = 50000
monster.outfit = {
	lookType = 876,
	lookHead = 79,
	lookBody = 3,
	lookLegs = 94,
	lookFeet = 3,
	lookAddons = 3,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1227,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 290000
monster.maxHealth = 290000
monster.race = "venom"
monster.corpse = 23564
monster.speed = 250
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
	"OutburstCharge",
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
	{ id = 23523, chance = 100000 }, -- Energy Ball
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 3035, chance = 100000, maxCount = 43 }, -- Platinum Coin
	{ id = 22721, chance = 100000, maxCount = 7 }, -- Gold Token
	{ id = 23516, chance = 100000 }, -- Instable Proto Matter
	{ id = 3031, chance = 100000, maxCount = 394 }, -- Gold Coin
	{ id = 23545, chance = 100000, maxCount = 9 }, -- Energy Drink
	{ id = 238, chance = 66000, maxCount = 18 }, -- Great Mana Potion
	{ id = 16119, chance = 61000, maxCount = 5 }, -- Blue Crystal Shard
	{ id = 16120, chance = 59000, maxCount = 5 }, -- Violet Crystal Shard
	{ id = 16121, chance = 56000, maxCount = 5 }, -- Green Crystal Shard
	{ id = 7643, chance = 53000, maxCount = 16 }, -- Ultimate Health Potion
	{ id = 7642, chance = 47000, maxCount = 17 }, -- Great Spirit Potion
	{ id = 3041, chance = 26000 }, -- Blue Gem
	{ id = 3039, chance = 23000 }, -- Red Gem
	{ id = 3033, chance = 22000, maxCount = 19 }, -- Small Amethyst
	{ id = 3032, chance = 22000, maxCount = 19 }, -- Small Emerald
	{ id = 3030, chance = 20000, maxCount = 19 }, -- Small Ruby
	{ id = 3029, chance = 19300, maxCount = 19 }, -- Small Sapphire
	{ id = 3038, chance = 18500 }, -- Green Gem
	{ id = 3037, chance = 17600 }, -- Yellow Gem
	{ id = 23476, chance = 17600 }, -- Void Boots
	{ id = 23529, chance = 17600 }, -- Ring of Blue Plasma
	{ id = 23531, chance = 16800 }, -- Ring of Green Plasma
	{ id = 23533, chance = 16800 }, -- Ring of Red Plasma
	{ id = 9057, chance = 16000, maxCount = 19 }, -- Small Topaz
	{ id = 828, chance = 13400 }, -- Lightning Headband
	{ id = 23543, chance = 11800 }, -- Collar of Green Plasma
	{ id = 281, chance = 11800 }, -- Giant Shimmering Pearl
	{ id = 7426, chance = 10100 }, -- Amber Staff
	{ id = 23544, chance = 10100 }, -- Collar of Red Plasma
	{ id = 3342, chance = 9200 }, -- War Axe
	{ id = 7428, chance = 5900 }, -- Bonebreaker
	{ id = 822, chance = 5000 }, -- Lightning Legs
	{ id = 23526, chance = 5000 }, -- Collar of Blue Plasma
	{ id = 7427, chance = 5000 }, -- Chaos Mace
	{ id = 825, chance = 4200 }, -- Lightning Robe
	{ id = 16160, chance = 4200 }, -- Crystalline Sword
	{ id = 8027, chance = 4200 }, -- Composite Hornbow
	{ id = 23474, chance = 2500 }, -- Tiara of Power
	{ id = 3036, chance = 2500 }, -- Violet Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -300, maxDamage = -1800 },
	{ name = "big energy purple wave", interval = 2000, chance = 25, minDamage = -700, maxDamage = -1300, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -300, maxDamage = -600, radius = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = true },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = -800, maxDamage = -1300, length = 8, spread = 0, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_LIFEDRAIN, minDamage = -600, maxDamage = -900, length = 8, spread = 0, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "big skill reducer", interval = 2000, chance = 25, target = false },
	{ name = "anomaly break", interval = 2000, chance = 40, target = false },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
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
