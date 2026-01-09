local mType = Game.createMonsterType("Emerald Tortoise")
local monster = {}

monster.description = "an emerald tortoise"
monster.experience = 12129
monster.outfit = {
	lookType = 1550,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2268
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Sparkling Pools",
}

monster.health = 22300
monster.maxHealth = 22300
monster.race = "blood"
monster.corpse = 39291
monster.speed = 179
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
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
	{ text = "Shllpp...", yell = false },
}

monster.loot = {
	{ id = 39379, chance = 28715 }, -- Emerald Tortoise Shell
	{ id = 3043, chance = 15309, maxCount = 3 }, -- Crystal Coin
	{ id = 7642, chance = 13411, maxCount = 2 }, -- Great Spirit Potion
	{ id = 3026, chance = 3278 }, -- White Pearl
	{ id = 3036, chance = 3900 }, -- Violet Gem
	{ id = 3027, chance = 2171, maxCount = 2 }, -- Black Pearl
	{ id = 16127, chance = 4065 }, -- Green Crystal Fragment
	{ id = 16119, chance = 3997 }, -- Blue Crystal Shard
	{ id = 3039, chance = 2546 }, -- Red Gem
	{ id = 3037, chance = 3278 }, -- Yellow Gem
	{ id = 16126, chance = 3478 }, -- Red Crystal Fragment
	{ id = 16121, chance = 2920 }, -- Green Crystal Shard
	{ id = 5021, chance = 2610, maxCount = 2 }, -- Orichalcum Pearl
	{ id = 281, chance = 2594 }, -- Giant Shimmering Pearl (Green)
	{ id = 3038, chance = 2963 }, -- Green Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1250 },
	{ name = "energy chain", interval = 5000, chance = 37, minDamage = -750, maxDamage = -1000, range = 3, target = true },
	{ name = "combat", interval = 2700, chance = 35, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -600, range = 5, shootEffect = CONST_ANI_ENERGY, target = true },
	{ name = "emerald tortoise large ring", interval = 3500, chance = 35, minDamage = -550, maxDamage = -1000 },
	{ name = "emerald tortoise small ring", interval = 4500, chance = 20, minDamage = -550, maxDamage = -700 },
	{ name = "emerald tortoise small explosion", interval = 3800, chance = 30, minDamage = -400, maxDamage = -600 },
	{ name = "combat", interval = 4100, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -450, maxDamage = -750, radius = 3, effect = CONST_ME_BLUE_ENERGY_SPARK, target = false },
}

monster.defenses = {
	defense = 110,
	armor = 97,
	mitigation = 2.57,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

RegisterPrimalPackBeast(monster)
