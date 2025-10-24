local mType = Game.createMonsterType("Lavafungus")
local monster = {}

monster.description = "a lavafungus"
monster.experience = 6200
monster.outfit = {
	lookType = 1405,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2095
monster.Bestiary = {
	class = "Plant",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Grotto of the Lost.",
}

monster.health = 7200
monster.maxHealth = 7200
monster.race = "blood"
monster.corpse = 36764
monster.speed = 115
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 3,
	color = 192,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 18 }, -- Platinum Coin
	{ id = 3065, chance = 25770 }, -- Terra Rod
	{ id = 3039, chance = 6841 }, -- Red Gem
	{ id = 3067, chance = 6097 }, -- Hailstorm Rod
	{ id = 16119, chance = 7124 }, -- Blue Crystal Shard
	{ id = 36786, chance = 13360 }, -- Lavafungus Ring
	{ id = 3038, chance = 5511 }, -- Green Gem
	{ id = 817, chance = 2597 }, -- Magma Amulet
	{ id = 3036, chance = 4911 }, -- Violet Gem
	{ id = 3037, chance = 4142 }, -- Yellow Gem
	{ id = 3071, chance = 4653 }, -- Wand of Inferno
	{ id = 3097, chance = 1949 }, -- Dwarven Ring
	{ id = 3333, chance = 1778 }, -- Crystal Mace
	{ id = 8043, chance = 2125 }, -- Focus Cape
	{ id = 8073, chance = 2714 }, -- Spellbook of Warding
	{ id = 8092, chance = 1792 }, -- Wand of Starstorm
	{ id = 16120, chance = 3781 }, -- Violet Crystal Shard
	{ id = 16125, chance = 4507 }, -- Cyan Crystal Fragment
	{ id = 16126, chance = 4198 }, -- Red Crystal Fragment
	{ id = 16127, chance = 3381 }, -- Green Crystal Fragment
	{ id = 21169, chance = 2325 }, -- Metal Spats
	{ id = 22193, chance = 3537 }, -- Onyx Chip
	{ id = 25737, chance = 3351 }, -- Rainbow Quartz
	{ id = 36785, chance = 3921 }, -- Lavafungus Head
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -810 },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_DEATHDAMAGE, minDamage = -560, maxDamage = -650, length = 6, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2750, chance = 40, type = COMBAT_FIREDAMAGE, minDamage = -490, maxDamage = -720, range = 5, shootEffect = CONST_ANI_FIRE, target = true },
	{ name = "combat", interval = 2750, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -720, maxDamage = -810, range = 5, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "lavafungus ring", interval = 2000, chance = 20, minDamage = -450, maxDamage = -610 },
	{ name = "lavafungus x wave", interval = 2000, chance = 10, minDamage = -640, maxDamage = -730 },
}

monster.defenses = {
	defense = 70,
	armor = 70,
	mitigation = 1.60,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 270, maxDamage = 530, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
