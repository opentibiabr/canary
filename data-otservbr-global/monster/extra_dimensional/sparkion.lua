local mType = Game.createMonsterType("Sparkion")
local monster = {}

monster.description = "a sparkion"
monster.experience = 1520
monster.outfit = {
	lookType = 877,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1234
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

monster.health = 2700
monster.maxHealth = 2700
monster.race = "venom"
monster.corpse = 23388
monster.speed = 151
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 15,
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
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Zzing!", yell = false },
	{ text = "Frizzle!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 90000, maxCount = 3 }, -- Platinum Coin
	{ id = 23535, chance = 15000 }, -- Energy Bar
	{ id = 23545, chance = 14600 }, -- Energy Drink
	{ id = 23502, chance = 14100 }, -- Sparkion Claw
	{ id = 23505, chance = 13600 }, -- Sparkion Stings
	{ id = 23504, chance = 11200 }, -- Sparkion Legs
	{ id = 239, chance = 10700, maxCount = 2 }, -- Great Health Potion
	{ id = 23503, chance = 10500 }, -- Sparkion Tail
	{ id = 7642, chance = 10500, maxCount = 2 }, -- Great Spirit Potion
	{ id = 238, chance = 9600, maxCount = 2 }, -- Great Mana Potion
	{ id = 16124, chance = 8100 }, -- Blue Crystal Splinter
	{ id = 16125, chance = 6200 }, -- Cyan Crystal Fragment
	{ id = 3029, chance = 5000, maxCount = 2 }, -- Small Sapphire
	{ id = 16119, chance = 4300 }, -- Blue Crystal Shard
	{ id = 3073, chance = 750 }, -- Wand of Cosmic Energy
	{ id = 3041, chance = 700 }, -- Blue Gem
	{ id = 23544, chance = 260 }, -- Collar of Red Plasma
	{ id = 50150, chance = 260 }, -- Ring of Orange Plasma
	{ id = 50152, chance = 210 }, -- Collar of Orange Plasma
	{ id = 23533, chance = 180 }, -- Ring of Red Plasma
	{ id = 23531, chance = 180 }, -- Ring of Green Plasma
	{ id = 23543, chance = 180 }, -- Collar of Green Plasma
	{ id = 23526, chance = 130 }, -- Collar of Blue Plasma
	{ id = 23529, chance = 100 }, -- Ring of Blue Plasma
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -400, length = 6, spread = 0, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -400, range = 5, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_ENERGYHIT, target = true },
	-- energy damage
	{ name = "condition", type = CONDITION_ENERGY, interval = 2000, chance = 20, minDamage = -300, maxDamage = -600, range = 6, radius = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_PURPLEENERGY, target = true },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	mitigation = 1.32,
	{ name = "speed", interval = 2000, chance = 10, speedChange = 400, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 50, maxDamage = 180, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 90 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 70 },
	{ type = COMBAT_HOLYDAMAGE, percent = 5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
