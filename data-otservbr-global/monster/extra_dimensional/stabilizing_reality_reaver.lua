local mType = Game.createMonsterType("Stabilizing Reality Reaver")
local monster = {}

monster.description = "a stabilizing reality reaver"
monster.experience = 1950
monster.outfit = {
	lookType = 879,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1266
monster.Bestiary = {
	class = "Extra Dimensional",
	race = BESTY_RACE_EXTRA_DIMENSIONAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Otherworld (Edron)",
}

monster.health = 2500
monster.maxHealth = 2500
monster.race = "venom"
monster.corpse = 23412
monster.speed = 155
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
	{ text = "Ssshhh!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 98260, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 98260, maxCount = 4 }, -- Platinum Coin
	{ id = 238, chance = 14100 }, -- Great Mana Potion
	{ id = 239, chance = 14520 }, -- Great Health Potion
	{ id = 7642, chance = 14690 }, -- Great Spirit Potion
	{ id = 23501, chance = 10200 }, -- Condensed Energy
	{ id = 23506, chance = 9530 }, -- Plasma Pearls
	{ id = 23524, chance = 9610 }, -- Small Energy Ball
	{ id = 23535, chance = 9440 }, -- Energy Bar
	{ id = 23545, chance = 9570 }, -- Energy Drink
	{ id = 3039, chance = 1360 }, -- Red Gem
	{ id = 16119, chance = 1710 }, -- Blue Crystal Shard
	{ id = 16120, chance = 4190 }, -- Violet Crystal Shard
	{ id = 16124, chance = 3789, maxCount = 2 }, -- Blue Crystal Splinter
	{ id = 16126, chance = 3939 }, -- Red Crystal Fragment
	{ id = 8092, chance = 1290 }, -- Wand of Starstorm
	{ id = 828, chance = 150 }, -- Lightning Headband
	{ id = 8043, chance = 130 }, -- Focus Cape
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -180, maxDamage = -300, range = 5, radius = 5, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_PURPLEENERGY, target = true },
	{ name = "reality reaver wave", interval = 2000, chance = 20, minDamage = -200, maxDamage = -350, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -80, maxDamage = -200, radius = 3, effect = CONST_ME_STUN, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 46,
	mitigation = 1.57,
	{ name = "invisible", interval = 2000, chance = 15, effect = CONST_ME_POFF },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 80, maxDamage = 210, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 10, speedChange = 330, effect = CONST_ME_HITAREA, target = false, duration = 8000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 70 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
