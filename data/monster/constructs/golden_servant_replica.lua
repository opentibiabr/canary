local mType = Game.createMonsterType("Golden Servant Replica")
local monster = {}

monster.description = "a golden servant replica"
monster.experience = 450
monster.outfit = {
	lookType = 396,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1327
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 2,
	Locations = "Replica Dungeon."
	}

monster.health = 2000
monster.maxHealth = 2000
monster.race = "venom"
monster.corpse = 13484
monster.speed = 210
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 80,
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
}

monster.loot = {
	{id = 2796, chance = 1450},
	{id = 9690, chance = 940},
	{id = 2148, chance = 85180, maxCount = 140},
	{id = 7618, chance = 4930},
	{id = 7620, chance = 4950},
	{id = 2381, chance = 3030},
	{id = 8900, chance = 520},
	{id = 2165, chance = 450},
	{id = 13758, chance = 340},
	{id = 13938, chance = 36},
	{id = 2466, chance = 13},
	{id = 2179, chance = 8}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 40, attack = 40},
	{name ="combat", interval = 2000, chance = 11, type = COMBAT_FIREDAMAGE, minDamage = -80, maxDamage = -110, length = 5, spread = 1, effect = CONST_ME_YELLOWENERGY, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -70, maxDamage = -110, range = 7, radius = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_PURPLEENERGY, target = true}
}

monster.defenses = {
	defense = 45,
	armor = 40,
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_HEALING, minDamage = 40, maxDamage = 70, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 80},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -5},
	{type = COMBAT_HOLYDAMAGE , percent = 100},
	{type = COMBAT_DEATHDAMAGE , percent = -5}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
