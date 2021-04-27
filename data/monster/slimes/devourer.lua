local mType = Game.createMonsterType("Devourer")
local monster = {}

monster.description = "a devourer"
monster.experience = 1755
monster.outfit = {
	lookType = 617,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1056
monster.Bestiary = {
	class = "Slime",
	race = BESTY_RACE_SLIME,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Rathleton Sewers, Lower Rathleton, Oramond/Western Plains, \z
		Underground Glooth Factory, Jaccus Maxxen's Dungeon."
	}

monster.health = 1900
monster.maxHealth = 1900
monster.race = "venom"
monster.corpse = 23484
monster.speed = 200
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 60000,
	chance = 0
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
	{text = "*gulp*", yell = false},
	{text = "*Bruaarrr!*", yell = false},
	{text = "*omnnommm nomm*", yell = false}
}

monster.loot = {
	{id = 2148, chance = 100000, maxCount = 165},
	{id = 2152, chance = 9100, maxCount = 2},
	{id = 23553, chance = 1670},
	{id = 2151, chance = 940},
	{id = 2146, chance = 1170, maxCount = 3},
	{id = 2150, chance = 1030, maxCount = 3},
	{id = 9970, chance = 1030, maxCount = 3},
	{id = 2149, chance = 1170, maxCount = 3},
	{id = 2147, chance = 1190, maxCount = 3},
	{id = 2145, chance = 1050, maxCount = 3},
	{id = 2154, chance = 1090},
	{id = 2155, chance = 100},
	{id = 23535, chance = 210},
	{id = 23554, chance = 130},
	{id = 23550, chance = 350},
	{id = 23549, chance = 510},
	{id = 23551, chance = 390},
	{id = 23529, chance = 370},
	{id = 8912, chance = 250},
	{id = 2181, chance = 260}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 62, attack = 50, condition = {type = CONDITION_POISON, totalDamage = 360, interval = 4000}},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -40, maxDamage = -125, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_MAGIC_RED, target = true},
	{name ="combat", interval = 2000, chance = 8, type = COMBAT_EARTHDAMAGE, minDamage = -50, maxDamage = -160, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_GREEN_RINGS, target = true},
	{name ="devourer wave", interval = 2000, chance = 5, minDamage = -50, maxDamage = -150, target = false},
	{name ="devourer paralyze", interval = 2000, chance = 9, target = false},
	{name ="combat", interval = 2000, chance = 11, type = COMBAT_EARTHDAMAGE, minDamage = -50, maxDamage = -150, length = 1, spread = 0, effect = CONST_ME_SMOKE, target = false},
	{name ="combat", interval = 2000, chance = 7, type = COMBAT_EARTHDAMAGE, minDamage = -120, maxDamage = -135, radius = 4, effect = CONST_ME_GREEN_RINGS, target = false}
}

monster.defenses = {
	defense = 25,
	armor = 15,
	{name ="combat", interval = 2000, chance = 6, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_GREEN, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 15},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 10}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
