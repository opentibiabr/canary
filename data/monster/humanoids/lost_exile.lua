local mType = Game.createMonsterType("Lost Exile")
local monster = {}

monster.description = "a lost exile"
monster.experience = 1800
monster.outfit = {
	lookType = 537,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1529
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "South east of the Gnome Deep Hub's entrance."
	}

monster.health = 1600
monster.maxHealth = 1600
monster.race = "blood"
monster.corpse = 33430
monster.speed = 170
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
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
	staticAttackChance = 90,
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
	{text = "**", yell = false},
	{text = "**", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 100000, maxCount = 200},
	{name = "platinum coin", chance = 60240, maxCount = 2},
	{name = "strong health potion", chance = 10950, maxCount = 2},
	{name = "great mana potion", chance = 8330, maxCount = 2},
	{name = "brown mushroom", chance = 16900, maxCount = 2},
	{id = 13757, chance = 13100},
	{name = "holy ash", chance = 13100},
	{name = "small topaz", chance = 10240},
	{name = "lost husher's staff", chance = 6900},
	{name = "skull shatterer", chance = 7620},
	{name = "wimp tooth chain", chance = 11900},
	{name = "red hair dye", chance = 12620},
	{name = "basalt fetish", chance = 8100},
	{name = "bonecarving knife", chance = 8100},
	{name = "basalt figurine", chance = 8100},
	{name = "bone fetish", chance = 8881},
	{name = "dwarven ring", chance = 1043},
	{name = "guardian shield", chance = 1430},
	{name = "buckle", chance = 1900},
	{name = "clay lump", chance = 710},
	{name = "knight axe", chance = 950},
	{name = "terra boots", chance = 240},
	{name = "suspicious device", chance = 250},
	{name = "tower shield", chance = 240},
	{name = "terra legs", chance = 240},
	{name = "fire axe", chance = 710},
	{name = "skull staff", chance = 480},
	{name = "spiked squelcher", chance = 240}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -120},
	{name ="sudden death", interval = 2000, chance = 15, minDamage = -150, maxDamage = -350, range = 3, length = 6, spread = 3, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -150, maxDamage = -250, range = 3, length = 5, spread = 5, effect = CONST_ME_SMOKE, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -150, maxDamage = -290, range = 3, length = 5, spread = 5, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_POISONAREA, target = false},
	{name ="sudden death", interval = 2000, chance = 15, minDamage = -70, maxDamage = -250, range = 7, target = false},
	{name ="drunk", interval = 2000, chance = 10, range = 7, shootEffect = CONST_ANI_ENERGY, target = false, duration = 5000}
}

monster.defenses = {
	defense = 20,
	armor = 20,
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 0, maxDamage = 160, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 30},
	{type = COMBAT_ENERGYDAMAGE, percent = 30},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 30},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 30},
	{type = COMBAT_HOLYDAMAGE , percent = -30},
	{type = COMBAT_DEATHDAMAGE , percent = 30}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
