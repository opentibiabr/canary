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
	{ id = 3036, chance = 5587 }, -- Violet Gem
	{ id = 3315, chance = 6595 }, -- Guardian Halberd
	{ id = 7449, chance = 6436 }, -- Crystal Sword
	{ id = 16120, chance = 4931 }, -- Violet Crystal Shard
	{ id = 16121, chance = 4867 }, -- Green Crystal Shard
	{ id = 36790, chance = 9423 }, -- Afflicted Strider Worms
	{ id = 826, chance = 2526 }, -- Magma Coat
	{ id = 3284, chance = 1567 }, -- Ice Rapier
	{ id = 3297, chance = 2387 }, -- Serpent Sword
	{ id = 3301, chance = 1710 }, -- Broadsword
	{ id = 3308, chance = 2266 }, -- Machete
	{ id = 3318, chance = 661 }, -- Knight Axe
	{ id = 3370, chance = 3012 }, -- Knight Armor
	{ id = 3379, chance = 4700 }, -- Doublet
	{ id = 7386, chance = 1093 }, -- Mercenary Sword
	{ id = 7407, chance = 1221 }, -- Haunted Blade
	{ id = 7413, chance = 1374 }, -- Titan Axe
	{ id = 8042, chance = 2734 }, -- Spirit Cloak
	{ id = 8043, chance = 1754 }, -- Focus Cape
	{ id = 8044, chance = 4204 }, -- Belted Cape
	{ id = 36789, chance = 3891 }, -- Afflicted Strider Head
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
