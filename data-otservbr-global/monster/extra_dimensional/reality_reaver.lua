local mType = Game.createMonsterType("Reality Reaver")
local monster = {}

monster.description = "a reality reaver"
monster.experience = 2480
monster.outfit = {
	lookType = 879,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1224
monster.Bestiary = {
	class = "Extra Dimensional",
	race = BESTY_RACE_EXTRA_DIMENSIONAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Otherworld",
}

monster.health = 3900
monster.maxHealth = 3900
monster.race = "venom"
monster.corpse = 23412
monster.speed = 170
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
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Ssshhh!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 6 }, -- Platinum Coin
	{ id = 23535, chance = 18500, maxCount = 2 }, -- Energy Bar
	{ id = 23545, chance = 17300, maxCount = 2 }, -- Energy Drink
	{ id = 23508, chance = 14800 }, -- Energy Vein
	{ id = 23520, chance = 14300 }, -- Plasmatic Lightning
	{ id = 7642, chance = 12100, maxCount = 2 }, -- Great Spirit Potion
	{ id = 238, chance = 12000, maxCount = 2 }, -- Great Mana Potion
	{ id = 239, chance = 11100, maxCount = 2 }, -- Great Health Potion
	{ id = 23515, chance = 10400 }, -- Dangerous Proto Matter
	{ id = 23506, chance = 9500 }, -- Plasma Pearls
	{ id = 16124, chance = 7600, maxCount = 2 }, -- Blue Crystal Splinter
	{ id = 16126, chance = 6100 }, -- Red Crystal Fragment
	{ id = 16120, chance = 4400 }, -- Violet Crystal Shard
	{ id = 16119, chance = 4400 }, -- Blue Crystal Shard
	{ id = 3039, chance = 1900 }, -- Red Gem
	{ id = 8092, chance = 1100 }, -- Wand of Starstorm
	{ id = 8043, chance = 500 }, -- Focus Cape
	{ id = 828, chance = 470 }, -- Lightning Headband
	{ id = 23529, chance = 420 }, -- Ring of Blue Plasma
	{ id = 50150, chance = 330 }, -- Ring of Orange Plasma
	{ id = 23543, chance = 330 }, -- Collar of Green Plasma
	{ id = 50152, chance = 310 }, -- Collar of Orange Plasma
	{ id = 23531, chance = 280 }, -- Ring of Green Plasma
	{ id = 3036, chance = 250 }, -- Violet Gem
	{ id = 23526, chance = 220 }, -- Collar of Blue Plasma
	{ id = 23533, chance = 170 }, -- Ring of Red Plasma
	{ id = 23544, chance = 110 }, -- Collar of Red Plasma
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -180, maxDamage = -400, range = 5, radius = 5, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_PURPLEENERGY, target = true },
	{ name = "reality reaver wave", interval = 2000, chance = 20, minDamage = -200, maxDamage = -500, target = false },
	-- energy damage
	{ name = "condition", type = CONDITION_ENERGY, interval = 2000, chance = 20, minDamage = -400, maxDamage = -800, radius = 5, effect = CONST_ME_STUN, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 51,
	mitigation = 1.76,
	{ name = "invisible", interval = 2000, chance = 15, effect = CONST_ME_POFF },
	{ name = "speed", interval = 2000, chance = 10, speedChange = 380, effect = CONST_ME_HITAREA, target = false, duration = 8000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 85 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
