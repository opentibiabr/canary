local mType = Game.createMonsterType("Draken Elite")
local monster = {}

monster.description = "a draken elite"
monster.experience = 4200
monster.outfit = {
	lookType = 362,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 672
monster.Bestiary = {
	class = "Dragon",
	race = BESTY_RACE_DRAGON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Razachai, including the Crystal Column chambers in the Inner Sanctum.",
}

monster.health = 5550
monster.maxHealth = 5550
monster.race = "blood"
monster.corpse = 11653
monster.speed = 166
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
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
	color = 161,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "For ze emperor!", yell = false },
	{ text = "You will die zhouzandz deazhz!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 8 }, -- platinum coin
	{ id = 3577, chance = 80000 }, -- meat
	{ id = 11661, chance = 80000 }, -- broken slicer
	{ id = 11660, chance = 23000 }, -- broken draken mail
	{ id = 11659, chance = 23000 }, -- draken wristbands
	{ id = 7643, chance = 23000, maxCount = 3 }, -- ultimate health potion
	{ id = 238, chance = 23000, maxCount = 3 }, -- great mana potion
	{ id = 11658, chance = 23000 }, -- draken sulphur
	{ id = 3028, chance = 5000, maxCount = 4 }, -- small diamond
	{ id = 5904, chance = 5000 }, -- magic sulphur
	{ id = 11657, chance = 1000 }, -- twiceslicer
	{ id = 10387, chance = 1000 }, -- zaoan legs
	{ id = 7404, chance = 1000 }, -- assassin dagger
	{ id = 4033, chance = 1000 }, -- draken boots
	{ id = 10384, chance = 1000 }, -- zaoan armor
	{ id = 10390, chance = 1000 }, -- zaoan sword
	{ id = 10385, chance = 260 }, -- zaoan helmet
	{ id = 11651, chance = 260 }, -- elite draken mail
	{ id = 11691, chance = 260 }, -- snake gods wristguard
	{ id = 11693, chance = 260 }, -- blade of corruption
	{ id = 11674, chance = 260 }, -- cobra crown
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -354 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -240, maxDamage = -550, length = 4, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -300, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -280, maxDamage = -410, radius = 4, effect = CONST_ME_POFF, target = true },
	{ name = "soulfire rune", interval = 2000, chance = 10, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -250, maxDamage = -320, range = 7, shootEffect = CONST_ANI_POISON, target = true },
}

monster.defenses = {
	defense = 60,
	armor = 60,
	mitigation = 1.60,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 510, maxDamage = 600, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 40 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
