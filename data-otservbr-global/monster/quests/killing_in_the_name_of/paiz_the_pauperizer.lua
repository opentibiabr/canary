local mType = Game.createMonsterType("Paiz the Pauperizer")
local monster = {}

monster.description = "Paiz the Pauperizer"
monster.experience = 6300
monster.outfit = {
	lookType = 362,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "blood"
monster.corpse = 11653
monster.speed = 140
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 3,
	color = 161,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You will die zhouzandz deazhz!", yell = false },
	{ text = "For ze emperor!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 10 }, -- platinum coin
	{ id = 3577, chance = 80000, maxCount = 5 }, -- meat
	{ id = 11660, chance = 80000 }, -- broken draken mail
	{ id = 11661, chance = 80000 }, -- broken slicer
	{ id = 11658, chance = 80000 }, -- draken sulphur
	{ id = 11659, chance = 80000 }, -- draken wristbands
	{ id = 5881, chance = 80000 }, -- lizard scale
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 239, chance = 80000, maxCount = 3 }, -- great health potion
	{ id = 238, chance = 5000, maxCount = 3 }, -- great mana potion
	{ id = 7642, chance = 5000, maxCount = 3 }, -- great spirit potion
	{ id = 36706, chance = 5000 }, -- red gem
	{ id = 3038, chance = 5000 }, -- green gem
	{ id = 10390, chance = 1000 }, -- zaoan sword
	{ id = 10384, chance = 1000 }, -- zaoan armor
	{ id = 3386, chance = 1000 }, -- dragon scale mail
	{ id = 8052, chance = 1000 }, -- swamplair armor
	{ id = 11657, chance = 1000 }, -- twiceslicer
	{ id = 3041, chance = 1000 }, -- blue gem
	{ id = 3032, chance = 1000, maxCount = 8 }, -- small emerald
	{ id = 11651, chance = 1000 }, -- elite draken mail
	{ id = 12307, chance = 260 }, -- harness
	{ id = 11693, chance = 260 }, -- blade of corruption
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -240, maxDamage = -550, length = 5, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -350, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_EARTHDAMAGE, minDamage = -280, maxDamage = -450, range = 4, radius = 4, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_POFF, target = true },
	{ name = "soulfire rune", interval = 2000, chance = 10, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 11, minDamage = -20, maxDamage = -20, range = 7, shootEffect = CONST_ANI_POISON, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 35,
	mitigation = 2.00,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 230, maxDamage = 330, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 40 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
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
