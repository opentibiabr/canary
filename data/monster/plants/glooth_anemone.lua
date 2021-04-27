local mType = Game.createMonsterType("Glooth Anemone")
local monster = {}

monster.description = "a glooth anemone"
monster.experience = 1755
monster.outfit = {
	lookType = 604,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1042
monster.Bestiary = {
	class = "Plant",
	race = BESTY_RACE_PLANT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Rathleton Sewers, Underground Glooth Factory, Jaccus Maxxen's Dungeon."
	}

monster.health = 2400
monster.maxHealth = 2400
monster.race = "venom"
monster.corpse = 23359
monster.speed = 180
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 2000,
	chance = 3
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
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "*shglib*", yell = false}
}

monster.loot = {
	{id = 23515, chance = 3190},
	{id = 23568, chance = 2020},
	{id = 2796, chance = 3180},
	{id = 23554, chance = 320},
	{id = 2148, chance = 100000, maxCount = 170},
	{id = 7588, chance = 6690, maxCount = 2},
	{id = 7589, chance = 6690, maxCount = 2},
	{id = 8473, chance = 960},
	{id = 2152, chance = 57320, maxCount = 3},
	{id = 9970, chance = 1240, maxCount = 3},
	{id = 2149, chance = 1600, maxCount = 3},
	{id = 2147, chance = 1150, maxCount = 3},
	{id = 23535, chance = 140},
	{id = 23543, chance = 700},
	{id = 23550, chance = 120},
	{id = 23549, chance = 370},
	{id = 23551, chance = 240},
	{id = 23529, chance = 370}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 60, attack = 50},
	{name ="combat", interval = 2000, chance = 9, type = COMBAT_EARTHDAMAGE, minDamage = -100, maxDamage = -200, range = 7, radius = 4, shootEffect = CONST_ANI_GLOOTHSPEAR, effect = CONST_ME_HITBYPOISON, target = true},
	{name ="combat", interval = 2000, chance = 7, type = COMBAT_LIFEDRAIN, minDamage = -50, maxDamage = -100, range = 7, radius = 1, shootEffect = CONST_ANI_POISON, effect = CONST_ME_MAGIC_RED, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, radius = 5, effect = CONST_ME_MAGIC_RED, target = false}
}

monster.defenses = {
	defense = 25,
	armor = 15,
	{name ="combat", interval = 2000, chance = 9, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_GREEN, target = false},
	{name ="glooth anemone summon", interval = 2000, chance = 14, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -5},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 5}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
