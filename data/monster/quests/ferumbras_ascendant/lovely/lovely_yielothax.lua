local mType = Game.createMonsterType("Lovely Yielothax")
local monster = {}

monster.description = "a lovely yielothax"
monster.experience = 1250
monster.outfit = {
	lookType = 408,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "venom"
monster.corpse = 13752
monster.speed = 300
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
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
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "IIEEH!! Iiih iih ih iiih!!!", yell = true},
	{text = "Iiiieeeh iiiieh iiieeh!", yell = true},
	{text = "Bsssmm bssmm bsssmmm", yell = true}
}

monster.loot = {
	{id = 7440, chance = 490},
	{id = 13881, chance = 300},
	{id = 13942, chance = 320},
	{id = 2148, chance = 99800, maxCount = 227},
	{id = 2789, chance = 9930, maxCount = 3},
	{id = 7588, chance = 19910},
	{id = 7589, chance = 19920},
	{id = 2145, chance = 4860, maxCount = 5},
	{id = 2151, chance = 950},
	{id = 2164, chance = 4020},
	{id = 13877, chance = 270},
	{id = 2189, chance = 510},
	{id = 2438, chance = 520},
	{id = 10221, chance = 570},
	{id = 7889, chance = 830},
	{id = 7895, chance = 480}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 70, attack = 50},
	{name ="combat", interval = 2000, chance = 18, type = COMBAT_LIFEDRAIN, minDamage = -70, maxDamage = -130, length = 4, spread = 3, effect = CONST_ME_ENERGYAREA, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -50, maxDamage = -150, length = 5, spread = 3, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -75, maxDamage = -120, radius = 3, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_HITBYPOISON, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -120, maxDamage = -215, radius = 3, effect = CONST_ME_HITBYPOISON, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 13, minDamage = -50, maxDamage = -50, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_HITBYPOISON, target = true}
}

monster.defenses = {
	defense = 45,
	armor = 30,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 100},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 100},
	{type = COMBAT_HOLYDAMAGE , percent = 100},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
