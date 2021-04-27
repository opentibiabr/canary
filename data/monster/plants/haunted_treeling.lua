local mType = Game.createMonsterType("Haunted Treeling")
local monster = {}

monster.description = "a haunted treeling"
monster.experience = 310
monster.outfit = {
	lookType = 310,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 511
monster.Bestiary = {
	class = "Plant",
	race = BESTY_RACE_PLANT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Vengoth surface, Vengoth Castle (Boreth's tower), Northern Zao Plantations, Tiquanda Laboratory, \z
		Dryad Gardens."
	}

monster.health = 450
monster.maxHealth = 450
monster.race = "undead"
monster.corpse = 9867
monster.speed = 230
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
	staticAttackChance = 85,
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
	{text = "Knarrrz", yell = false},
	{text = "Huuhuuhuuuhuuaarrr", yell = false},
	{text = "Knorrrrrr", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 91920, maxCount = 95},
	{id = 4860, chance = 29190},
	{name = "red mushroom", chance = 7700},
	{name = "health potion", chance = 5130},
	{name = "white mushroom", chance = 5030, maxCount = 2},
	{name = "haunted piece of wood", chance = 4950},
	{name = "orange mushroom", chance = 1800},
	{name = "strong health potion", chance = 1040},
	{name = "dwarven ring", chance = 660},
	{name = "small emerald", chance = 620},
	{name = "bullseye potion", chance = 100}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -150},
	{name ="combat", interval = 2000, chance = 5, type = COMBAT_MANADRAIN, minDamage = -30, maxDamage = -100, radius = 4, effect = CONST_ME_GREEN_RINGS, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = -700, length = 5, spread = 3, effect = CONST_ME_SMALLPLANTS, target = false, duration = 15000},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -100, range = 7, radius = 1, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_CARNIPHILA, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -55, maxDamage = -100, radius = 4, effect = CONST_ME_HITBYPOISON, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, radius = 1, effect = CONST_ME_POISONAREA, target = false}
}

monster.defenses = {
	defense = 0,
	armor = 20
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -5},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 15},
	{type = COMBAT_HOLYDAMAGE , percent = 20},
	{type = COMBAT_DEATHDAMAGE , percent = 1}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
