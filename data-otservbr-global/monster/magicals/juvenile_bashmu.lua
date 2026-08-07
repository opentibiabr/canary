local mType = Game.createMonsterType("Juvenile Bashmu")
local monster = {}

monster.description = "a juvenile bashmu"
monster.experience = 4500
monster.outfit = {
	lookType = 1408,
	lookHead = 0,
	lookBody = 112,
	lookLegs = 3,
	lookFeet = 79,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2101
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Salt Caves",
}

monster.health = 7500
monster.maxHealth = 7500
monster.race = "blood"
monster.corpse = 36967
monster.speed = 195
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 20,
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
	level = 1,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 74000, maxCount = 19 }, -- Platinum Coin
	{ id = 7642, chance = 13700, maxCount = 2 }, -- Great Spirit Potion
	{ id = 7643, chance = 10700, maxCount = 4 }, -- Ultimate Health Potion
	{ id = 16119, chance = 5800 }, -- Blue Crystal Shard
	{ id = 36821, chance = 5700 }, -- Bashmu Tongue
	{ id = 36823, chance = 4100 }, -- Bashmu Feather
	{ id = 16121, chance = 3600 }, -- Green Crystal Shard
	{ id = 16125, chance = 3400 }, -- Cyan Crystal Fragment
	{ id = 822, chance = 2500 }, -- Lightning Legs
	{ id = 3036, chance = 2500 }, -- Violet Gem
	{ id = 3037, chance = 2300 }, -- Yellow Gem
	{ id = 3039, chance = 2300 }, -- Red Gem
	{ id = 816, chance = 2000 }, -- Lightning Pendant
	{ id = 7387, chance = 2000 }, -- Diamond Sceptre
	{ id = 16120, chance = 1700 }, -- Violet Crystal Shard
	{ id = 3279, chance = 1600 }, -- War Hammer
	{ id = 3038, chance = 1500 }, -- Green Gem
	{ id = 36820, chance = 1400 }, -- Bashmu Fang
	{ id = 7426, chance = 1300 }, -- Amber Staff
	{ id = 7430, chance = 1300 }, -- Dragonbone Staff
	{ id = 820, chance = 1300 }, -- Lightning Boots
	{ id = 3333, chance = 1000 }, -- Crystal Mace
	{ id = 10438, chance = 940 }, -- Spellweaver's Robe
	{ id = 7427, chance = 920 }, -- Chaos Mace
	{ id = 17828, chance = 870 }, -- Pair of Iron Fists
	{ id = 3324, chance = 850 }, -- Skull Staff
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_ENERGYDAMAGE, minDamage = -300, maxDamage = -400, length = 4, spread = 0, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -500, range = 3, radius = 3, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -400, maxDamage = -500, range = 7, shootEffect = CONST_ANI_EARTHARROW, target = true },
}

monster.defenses = {
	defense = 75,
	armor = 75,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 5 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
