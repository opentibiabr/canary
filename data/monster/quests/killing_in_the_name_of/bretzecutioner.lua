local mType = Game.createMonsterType("Bretzecutioner")
local monster = {}

monster.description = "Bretzecutioner"
monster.experience = 3700
monster.outfit = {
	lookType = 236,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 5600
monster.maxHealth = 5600
monster.race = "undead"
monster.corpse = 6320
monster.speed = 270
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{id = 2148, chance = 100000},
	{id = 2148, chance = 100000, maxCount = 98},
	{id = 2666, chance = 100000},
	{id = 6500, chance = 64000},
	{id = 7368, chance = 100000, maxCount = 10},
	{id = 2489, chance = 68000},
	{id = 2150, chance = 28000, maxCount = 5},
	{id = 2146, chance = 40000, maxCount = 5},
	{id = 2145, chance = 32000, maxCount = 5},
	{id = 11215, chance = 100000},
	{id = 7452, chance = 32000},
	{id = 2152, chance = 100000, maxCount = 8},
	{id = 2393, chance = 24000},
	{id = 7591, chance = 44000, maxCount = 3},
	{id = 7590, chance = 44000, maxCount = 3},
	{id = 8472, chance = 44000, maxCount = 3},
	{id = 7632, chance = 48000},
	{id = 7633, chance = 48000},
	{id = 2645, chance = 4000},
	{id = 7427, chance = 24000},
	{id = 7419, chance = 12000},
	{id = 2125, chance = 24000},
	{id = 2521, chance = 16000},
	{id = 6300, chance = 100000},
	{id = 5741, chance = 4000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -514},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -200, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = false}
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{name ="speed", interval = 2000, chance = 15, speedChange = 420, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 25},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 20},
	{type = COMBAT_FIREDAMAGE, percent = 30},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -15},
	{type = COMBAT_HOLYDAMAGE , percent = -3},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
