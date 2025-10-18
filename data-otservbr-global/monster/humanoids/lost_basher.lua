local mType = Game.createMonsterType("Lost Basher")
local monster = {}

monster.description = "a lost basher"
monster.experience = 2300
monster.outfit = {
	lookType = 538,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 925
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Caves of the Lost, Lower Spike and in the Lost Dwarf version of the Forsaken Mine.",
}

monster.health = 2600
monster.maxHealth = 2600
monster.race = "blood"
monster.corpse = 17683
monster.speed = 130
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "Yhouuuu!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 99990, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 69940 }, -- Platinum Coin
	{ id = 12600, chance = 20160 }, -- Coal
	{ id = 17827, chance = 17350 }, -- Bloody Dwarven Beard
	{ id = 17826, chance = 15080 }, -- Lost Basher's Spike
	{ id = 3725, chance = 14890, maxCount = 2 }, -- Brown Mushroom
	{ id = 238, chance = 12240 }, -- Great Mana Potion
	{ id = 17855, chance = 11900 }, -- Red Hair Dye
	{ id = 17847, chance = 11850 }, -- Wimp Tooth Chain
	{ id = 17857, chance = 10220 }, -- Basalt Figurine
	{ id = 9057, chance = 10100 }, -- Small Topaz
	{ id = 17830, chance = 10070 }, -- Bonecarving Knife
	{ id = 7643, chance = 9680 }, -- Ultimate Health Potion
	{ id = 17856, chance = 8210 }, -- Basalt Fetish
	{ id = 17831, chance = 7480 }, -- Bone Fetish
	{ id = 5880, chance = 4940 }, -- Iron Ore
	{ id = 2995, chance = 3950 }, -- Piggy Bank
	{ id = 3429, chance = 3430 }, -- Black Shield
	{ id = 3097, chance = 2420 }, -- Dwarven Ring
	{ id = 17828, chance = 1560 }, -- Pair of Iron Fists
	{ id = 16119, chance = 1350 }, -- Blue Crystal Shard
	{ id = 17829, chance = 1140 }, -- Buckle
	{ id = 3318, chance = 900 }, -- Knight Axe
	{ id = 813, chance = 790 }, -- Terra Boots
	{ id = 3371, chance = 560 }, -- Knight Legs
	{ id = 7452, chance = 370 }, -- Spiked Squelcher
	{ id = 3320, chance = 300 }, -- Fire Axe
	{ id = 7427, chance = 190 }, -- Chaos Mace
	{ id = 3342, chance = 60 }, -- War Axe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -351 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -220, range = 7, radius = 3, shootEffect = CONST_ANI_WHIRLWINDAXE, effect = CONST_ME_EXPLOSIONAREA, target = true },
	{ name = "drunk", interval = 2000, chance = 15, radius = 4, shootEffect = CONST_ANI_WHIRLWINDCLUB, effect = CONST_ME_SOUND_RED, target = true, duration = 6000 },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -650, radius = 2, effect = CONST_ME_ENERGYHIT, target = false, duration = 15000 },
}

monster.defenses = {
	defense = 30,
	armor = 57,
	mitigation = 1.62,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 250, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
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
