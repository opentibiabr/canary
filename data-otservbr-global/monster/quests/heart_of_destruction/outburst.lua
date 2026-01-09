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
	{ id = 3031, chance = 100000, maxCount = 100 }, -- Gold Coin
	{ id = 3029, chance = 20388, maxCount = 10 }, -- Small Sapphire
	{ id = 3033, chance = 20145, maxCount = 10 }, -- Small Amethyst
	{ id = 238, chance = 54854, maxCount = 5 }, -- Great Mana Potion
	{ id = 7642, chance = 54611, maxCount = 5 }, -- Great Spirit Potion
	{ id = 16121, chance = 61650, maxCount = 3 }, -- Green Crystal Shard
	{ id = 16120, chance = 64805, maxCount = 3 }, -- Violet Crystal Shard
	{ id = 16119, chance = 66990, maxCount = 3 }, -- Blue Crystal Shard
	{ id = 3039, chance = 23058 }, -- Red Gem
	{ id = 3038, chance = 17475 }, -- Green Gem
	{ id = 23529, chance = 16747 }, -- Ring of Blue Plasma
	{ id = 23544, chance = 10436 }, -- Collar of Red Plasma
	{ id = 828, chance = 11165 }, -- Lightning Headband
	{ id = 23516, chance = 100000 }, -- Instable Proto Matter
	{ id = 23523, chance = 100000 }, -- Energy Ball
	{ id = 22721, chance = 100000, maxCount = 7 }, -- Gold Token
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 23474, 23475, chance = 5582 }, -- Tiara of Power
	{ id = 23476, 23477, chance = 18446 }, -- Void Boots
	{ id = 23543, chance = 9951 }, -- Collar of Green Plasma
	{ id = 3035, chance = 100000 }, -- Platinum Coin
	{ id = 7427, chance = 15291 }, -- Chaos Mace
	{ id = 3030, chance = 20145 }, -- Small Ruby
	{ id = 3037, chance = 21116 }, -- Yellow Gem
	{ id = 3032, chance = 20145 }, -- Small Emerald
	{ id = 23545, chance = 100000 }, -- Energy Drink
	{ id = 7643, chance = 55582 }, -- Ultimate Health Potion
	{ id = 281, chance = 11893 }, -- Giant Shimmering Pearl
	{ id = 9057, chance = 18932 }, -- Small Topaz
	{ id = 23533, chance = 13834 }, -- Ring of Red Plasma
	{ id = 8027, chance = 2669 }, -- Composite Hornbow
	{ id = 3041, chance = 23300 }, -- Blue Gem
	{ id = 23526, chance = 10436 }, -- Collar of Blue Plasma
	{ id = 3036, chance = 2912 }, -- Violet Gem
	{ id = 7426, chance = 8252 }, -- Amber Staff
	{ id = 23531, chance = 13834 }, -- Ring of Green Plasma
	{ id = 7428, chance = 8009 }, -- Bonebreaker
	{ id = 825, chance = 3640 }, -- Lightning Robe
	{ id = 3342, chance = 6310 }, -- War Axe
	{ id = 822, chance = 3398 }, -- Lightning Legs
	{ id = 16160, chance = 2912 }, -- Crystalline Sword
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
