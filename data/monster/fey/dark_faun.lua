local mType = Game.createMonsterType("Dark Faun")
local monster = {}

monster.description = "a dark faun"
monster.experience = 900
monster.outfit = {
	lookType = 980,
	lookHead = 94,
	lookBody = 114,
	lookLegs = 57,
	lookFeet = 94,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1496
monster.Bestiary = {
	class = "Fey",
	race = BESTY_RACE_FEY,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Feyrist (nighttime) and its underground (all day)."
	}

monster.health = 1100
monster.maxHealth = 1100
monster.race = "blood"
monster.corpse = 29101
monster.speed = 216
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
	random = 10
}

monster.respawnType = {
	period = RESPAWNPERIOD_NIGHT,
	underground = true
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 20,
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
	{text = "Blood, fight and rage!", yell = false},
	{text = "This will be your last dance!", yell = false},
	{text = "You're a threat to this realm! You have to die!", yell = false},
	{text = "This is a nightmare and you won't wake up!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 30000, maxCount = 112},
	{name = "wood cape", chance = 492},
	{name = "wooden spellbook", chance = 92},
	{name = "mandrake", chance = 50},
	{name = "leaf legs", chance = 492},
	{name = "small stone", chance = 492, maxCount = 4},
	{name = "small enchanted sapphire", chance = 492, maxCount = 2},
	{name = "shimmering beetles", chance = 492},
	{name = "cave turnip", chance = 55000, maxCount = 4},
	{name = "leaf legs", chance = 719},
	{name = "dark mushroom", chance = 719},
	{name = "panpipes", chance = 719},
	{name = "prismatic quartz", chance = 719},
	{name = "leaf star", chance = 10000, maxCount = 8},
	{name = "strong health potion", chance = 6800, maxCount = 2},
	{name = "goat grass", chance = 5155},
	{name = "great health potion", chance = 591}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -515},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -60, maxDamage = -115, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true},
	{name ="drunk", interval = 2000, chance = 11, length = 4, spread = 2, effect = CONST_ME_SOUND_PURPLE, target = false, duration = 25000},
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -100, range = 7, shootEffect = CONST_ANI_LEAFSTAR, target = false}
}

monster.defenses = {
	defense = 50,
	armor = 50,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 85, maxDamage = 105, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 70},
	{type = COMBAT_FIREDAMAGE, percent = -5},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 40}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
