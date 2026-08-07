local mType = Game.createMonsterType("Afflicted Strider")
local monster = {}

monster.description = "an afflicted strider"
monster.experience = 5700
monster.outfit = {
	lookType = 1403,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2094
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Antrum of the Fallen.",
}

monster.health = 10000
monster.maxHealth = 10000
monster.race = "blood"
monster.corpse = 36719
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
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
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
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
	{ id = 3035, chance = 100000, maxCount = 15 }, -- Platinum Coin
	{ id = 36790, chance = 10100 }, -- Afflicted Strider Worms
	{ id = 3315, chance = 8500 }, -- Guardian Halberd
	{ id = 7449, chance = 8400 }, -- Crystal Sword
	{ id = 3036, chance = 7000 }, -- Violet Gem
	{ id = 16121, chance = 6400 }, -- Green Crystal Shard
	{ id = 16120, chance = 5700 }, -- Violet Crystal Shard
	{ id = 36789, chance = 5100 }, -- Afflicted Strider Head
	{ id = 3379, chance = 4700 }, -- Doublet
	{ id = 8044, chance = 4100 }, -- Belted Cape
	{ id = 3370, chance = 3900 }, -- Knight Armor
	{ id = 3308, chance = 3600 }, -- Machete
	{ id = 8042, chance = 3000 }, -- Spirit Cloak
	{ id = 8043, chance = 2700 }, -- Focus Cape
	{ id = 826, chance = 2200 }, -- Magma Coat
	{ id = 3297, chance = 2100 }, -- Serpent Sword
	{ id = 3301, chance = 2000 }, -- Broadsword
	{ id = 3284, chance = 2000 }, -- Ice Rapier
	{ id = 7413, chance = 1600 }, -- Titan Axe
	{ id = 7407, chance = 1500 }, -- Haunted Blade
	{ id = 7386, chance = 1500 }, -- Mercenary Sword
	{ id = 3318, chance = 1200 }, -- Knight Axe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -550, maxDamage = -650, range = 3, shootEffect = CONST_ANI_POISON, target = true },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_DEATHDAMAGE, minDamage = -650, maxDamage = -800, radius = 5, effect = CONST_ME_GROUNDSHAKER, target = false },
}

monster.defenses = {
	defense = 68,
	armor = 68,
	mitigation = 1.88,
	{ name = "speed", interval = 2000, chance = 25, speedChange = 450, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
