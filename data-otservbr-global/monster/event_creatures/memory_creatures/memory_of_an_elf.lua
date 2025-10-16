local mType = Game.createMonsterType("Memory of an Elf")
local monster = {}

monster.description = "a memory of an elf"
monster.experience = 1440
monster.outfit = {
	lookType = 63,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3440
monster.maxHealth = 3440
monster.race = "blood"
monster.corpse = 6011
monster.speed = 110
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
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
}

monster.loot = {
	{ id = 3447, chance = 80000 }, -- arrow
	{ id = 28568, chance = 80000 }, -- inkwell
	{ id = 3073, chance = 80000 }, -- wand of cosmic energy
	{ id = 3661, chance = 80000 }, -- grave flower
	{ id = 2815, chance = 80000 }, -- scroll
	{ id = 237, chance = 80000 }, -- strong mana potion
	{ id = 3061, chance = 80000 }, -- life crystal
	{ id = 3147, chance = 80000 }, -- blank rune
	{ id = 3551, chance = 80000 }, -- sandals
	{ id = 3600, chance = 80000 }, -- bread
	{ id = 2917, chance = 80000 }, -- candlestick
	{ id = 3031, chance = 80000 }, -- gold coin
	{ id = 266, chance = 80000 }, -- health potion
	{ id = 3738, chance = 80000 }, -- sling herb
	{ id = 3082, chance = 80000 }, -- elven amulet
	{ id = 3563, chance = 80000 }, -- green tunic
	{ id = 3593, chance = 80000 }, -- melon
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -35 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -70, range = 7, shootEffect = CONST_ANI_ARROW, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -30, maxDamage = -50, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -70, maxDamage = -85, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 15,
	armor = 15,
	mitigation = 1.20,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 40, maxDamage = 60, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
