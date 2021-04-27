local mType = Game.createMonsterType("Faun")
local monster = {}

monster.description = "a faun"
monster.experience = 800
monster.outfit = {
	lookType = 980,
	lookHead = 81,
	lookBody = 115,
	lookLegs = 114,
	lookFeet = 81,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1434
monster.Bestiary = {
	class = "Fey",
	race = BESTY_RACE_FEY,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Feyrist (daytime)."
	}

monster.health = 900
monster.maxHealth = 900
monster.race = "blood"
monster.corpse = 29102
monster.speed = 210
monster.manaCost = 450
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

monster.respawnType = {
	period = RESPAWNPERIOD_DAY,
	underground = false
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
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
	{text = "Are you posing a threat to this realm? I suppose so.", yell = false},
	{text = "In vino veritas! Hahaha!", yell = false},
	{text = "Wine, women and song!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 30000, maxCount = 136},
	{name = "goat grass", chance = 5155},
	{name = "leaf star", chance = 10000, maxCount = 7},
	{name = "grapes", chance = 30100, maxCount = 2},
	{name = "small enchanted sapphire", chance = 492, maxCount = 2},
	{name = "leaf legs", chance = 492},
	{name = "dandelion seeds", chance = 5800},
	{name = "shimmering beetles", chance = 492},
	{name = "panpipes", chance = 172},
	{name = "cookie", chance = 55000, maxCount = 5},
	{name = "great health potion", chance = 6400, maxCount = 2},
	{name = "wooden spellbook", chance = 92},
	{name = "strong health potion", chance = 6800, maxCount = 2},
	{name = "fresh fruit", chance = 3400, maxCount = 3},
	{name = "rainbow quartz", chance = 1086, maxCount = 4},
	{name = "small stone", chance = 492, maxCount = 3},
	{name = "wood cape", chance = 492},
	{id = 5792, chance = 80},
	{name = "mandrake", chance = 50}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -370},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -60, maxDamage = -115, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true},
	{name ="drunk", interval = 2000, chance = 11, length = 4, spread = 2, effect = CONST_ME_SOUND_PURPLE, target = false, duration = 25000},
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -100, range = 7, shootEffect = CONST_ANI_LEAFSTAR, target = false}
}

monster.defenses = {
	defense = 45,
	armor = 45,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 75, maxDamage = 90, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 70},
	{type = COMBAT_FIREDAMAGE, percent = -15},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 30},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
