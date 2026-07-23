local mType = Game.createMonsterType("Cave Chimera")
local monster = {}

monster.description = "a cave chimera"
monster.experience = 6800
monster.outfit = {
	lookType = 1406,
	lookHead = 60,
	lookBody = 77,
	lookLegs = 64,
	lookFeet = 70,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2096
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Dwelling of the Forgotten",
}

monster.health = 8000
monster.maxHealth = 8000
monster.race = "blood"
monster.corpse = 36768
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 3,
	color = 100,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 29 }, -- Platinum Coin
	{ id = 7642, chance = 27000, maxCount = 2 }, -- Great Spirit Potion
	{ id = 7643, chance = 22000 }, -- Ultimate Health Potion
	{ id = 9058, chance = 20000 }, -- Gold Ingot
	{ id = 3036, chance = 6300 }, -- Violet Gem
	{ id = 16120, chance = 6200 }, -- Violet Crystal Shard
	{ id = 36788, chance = 5000 }, -- Cave Chimera Leg
	{ id = 281, chance = 3000 }, -- Giant Shimmering Pearl (Green)
	{ id = 815, chance = 3000 }, -- Glacier Amulet
	{ id = 3037, chance = 2900 }, -- Yellow Gem
	{ id = 36787, chance = 2700 }, -- Cave Chimera Head
	{ id = 823, chance = 2100 }, -- Glacier Kilt
	{ id = 23529, chance = 1700 }, -- Ring of Blue Plasma
	{ id = 3063, chance = 1100 }, -- Gold Ring
	{ id = 14247, chance = 1100 }, -- Ornate Crossbow
	{ id = 24392, chance = 990 }, -- Gemmed Figurine
	{ id = 22085, chance = 840 }, -- Fur Armor
	{ id = 7438, chance = 300 }, -- Elvish Bow
	{ id = 16163, chance = 300 }, -- Crystal Crossbow
	{ id = 8027, chance = 150 }, -- Composite Hornbow
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HOLYDAMAGE, minDamage = -600, maxDamage = -700, range = 4, radius = 3, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYDAMAGE, target = true },
	{ name = "combat", interval = 2000, chance = 60, type = COMBAT_ICEDAMAGE, minDamage = -560, maxDamage = -650, radius = 4, effect = CONST_ME_BLUE_ENERGY_SPARK, target = false },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_ICEDAMAGE, minDamage = -750, maxDamage = -850, range = 4, shootEffect = CONST_ANI_ICE, target = true },
}

monster.defenses = {
	defense = 60,
	armor = 60,
	mitigation = 1.88,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 200, maxDamage = 700, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
