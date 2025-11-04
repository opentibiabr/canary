local mType = Game.createMonsterType("Dread Intruder")
local monster = {}

monster.description = "a dread intruder"
monster.experience = 2400
monster.outfit = {
	lookType = 882,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1260
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

monster.health = 4500
monster.maxHealth = 4500
monster.race = "venom"
monster.corpse = 23478
monster.speed = 165
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
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Whirr!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 8 }, -- Platinum Coin
	{ id = 238, chance = 12773 }, -- Great Mana Potion
	{ id = 7642, chance = 12558 }, -- Great Spirit Potion
	{ id = 7643, chance = 12618 }, -- Ultimate Health Potion
	{ id = 23545, chance = 21943 }, -- Energy Drink
	{ id = 23535, chance = 19803 }, -- Energy Bar
	{ id = 23516, chance = 13560 }, -- Instable Proto Matter
	{ id = 23523, chance = 11338 }, -- Energy Ball
	{ id = 23510, chance = 10265 }, -- Odd Organ
	{ id = 23519, chance = 15798 }, -- Frozen Lightning
	{ id = 16124, chance = 8385 }, -- Blue Crystal Splinter
	{ id = 16125, chance = 5641 }, -- Cyan Crystal Fragment
	{ id = 3033, chance = 4212, maxCount = 2 }, -- Small Amethyst
	{ id = 3030, chance = 4250, maxCount = 2 }, -- Small Ruby
	{ id = 3029, chance = 4785, maxCount = 2 }, -- Small Sapphire
	{ id = 16120, chance = 4941 }, -- Violet Crystal Shard
	{ id = 3036, chance = 885 }, -- Violet Gem
	{ id = 23544, chance = 222 }, -- Collar of Red Plasma
	{ id = 23526, chance = 171 }, -- Collar of Blue Plasma
	{ id = 23543, chance = 167 }, -- Collar of Green Plasma
	{ id = 50152, chance = 1000 }, -- Collar of Orange Plasma
	{ id = 23533, chance = 257 }, -- Ring of Red Plasma
	{ id = 23529, chance = 171 }, -- Ring of Blue Plasma
	{ id = 23531, chance = 183 }, -- Ring of Green Plasma
	{ id = 50150, chance = 350 }, -- Ring of Orange Plasma
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500 },
	-- energy damage
	{ name = "condition", type = CONDITION_ENERGY, interval = 2000, chance = 20, minDamage = -400, maxDamage = -600, radius = 5, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -250, maxDamage = -400, range = 4, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "dread intruder wave", interval = 2000, chance = 25, minDamage = -350, maxDamage = -550, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 50,
	mitigation = 1.54,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 80, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 90 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 80 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
