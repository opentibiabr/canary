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
	{ id = 11660, chance = 100000 }, -- Broken Draken Mail
	{ id = 5881, chance = 100000 }, -- Lizard Scale
	{ id = 3035, chance = 100000, maxCount = 10 }, -- Platinum Coin
	{ id = 3031, chance = 100000, maxCount = 99 }, -- Gold Coin
	{ id = 3577, chance = 100000 }, -- Meat
	{ id = 11658, chance = 100000 }, -- Draken Sulphur
	{ id = 11659, chance = 100000 }, -- Draken Wristbands
	{ id = 11661, chance = 100000 }, -- Broken Slicer
	{ id = 238, chance = 41000, maxCount = 3 }, -- Great Mana Potion
	{ id = 5904, chance = 39000 }, -- Magic Sulphur
	{ id = 3037, chance = 39000 }, -- Yellow Gem
	{ id = 239, chance = 31000, maxCount = 3 }, -- Great Health Potion
	{ id = 3039, chance = 28000 }, -- Red Gem
	{ id = 7642, chance = 28000, maxCount = 3 }, -- Great Spirit Potion
	{ id = 50183, chance = 22000 }, -- Sai
	{ id = 3038, chance = 20000 }, -- Green Gem
	{ id = 8052, chance = 20000 }, -- Swamplair Armor
	{ id = 10384, chance = 17000 }, -- Zaoan Armor
	{ id = 10390, chance = 15900 }, -- Zaoan Sword
	{ id = 11657, chance = 10200 }, -- Twiceslicer
	{ id = 3386, chance = 10200 }, -- Dragon Scale Mail
	{ id = 3041, chance = 6800 }, -- Blue Gem
	{ id = 11651, chance = 5700 }, -- Elite Draken Mail
	{ id = 3032, chance = 5700, maxCount = 10 }, -- Small Emerald
	{ id = 12307, chance = 2300 }, -- Harness
	{ id = 10389, chance = 1100 }, -- Traditional Sai
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
