local mType = Game.createMonsterType("Orc Shaman")
local monster = {}

monster.description = "an orc shaman"
monster.experience = 110
monster.outfit = {
	lookType = 6,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 6
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Edron Orc Cave, Temple of Xayepocax, below Point of No Return in Outlaw Camp, Venore Orc Cave, \z
		Maze of Lost Souls, Orc Fort, north west of Thais, Elvenbane, Plains Of Havoc, Foreigner Quarter, Zao Orc Land."
	}

monster.health = 115
monster.maxHealth = 115
monster.race = "blood"
monster.corpse = 5978
monster.speed = 140
monster.manaCost = 0
monster.maxSummons = 4

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 15,
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

monster.summons = {
	{name = "Snake", chance = 20, interval = 2000, max = 4}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Huumans stinkk!", yell = false},
	{text = "Grak brrretz gulu.", yell = false}
}

monster.loot = {
	{id = 1958, chance = 520},
	{name = "gold coin", chance = 90000, maxCount = 5},
	{name = "wand of decay", chance = 1000},
	{name = "spear", chance = 4850},
	{name = "chain armor", chance = 8750},
	{name = "corncob", chance = 10600, maxCount = 2},
	{name = "orc tooth", chance = 2100},
	{name = "broken shamanic staff", chance = 10300},
	{name = "shamanic hood", chance = 6860},
	{name = "orc leather", chance = 4300},
	{id = 26654, chance = 1000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -15},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -20, maxDamage = -31, range = 7, shootEffect = CONST_ANI_ENERGYBALL, target = false},
	{name ="combat", interval = 2000, chance = 5, type = COMBAT_FIREDAMAGE, minDamage = -5, maxDamage = -43, range = 7, radius = 1, shootEffect = CONST_ANI_FIRE, target = true}
}

monster.defenses = {
	defense = 10,
	armor = 10,
	{name ="combat", interval = 2000, chance = 60, type = COMBAT_HEALING, minDamage = 27, maxDamage = 43, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 50},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 25},
	{type = COMBAT_DEATHDAMAGE , percent = -5}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
