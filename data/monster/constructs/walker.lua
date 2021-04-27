local mType = Game.createMonsterType("Walker")
local monster = {}

monster.description = "a walker"
monster.experience = 2200
monster.outfit = {
	lookType = 605,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1043
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 1,
	Locations = "A few spawns in the Underground Glooth Factory, Glooth Factory, and Rathleton Sewers."
	}

monster.health = 3000
monster.maxHealth = 3000
monster.race = "venom"
monster.corpse = 23343
monster.speed = 300
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5
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
}

monster.loot = {
	{id = 23569, chance = 3548},
	{id = 23541, chance = 1490},
	{id = 2148, chance = 100000, maxCount = 200},
	{id = 2152, chance = 51610, maxCount = 3},
	{id = 9970, chance = 16130, maxCount = 3},
	{id = 2149, chance = 6450, maxCount = 2},
	{id = 8472, chance = 3230},
	{id = 7591, chance = 3230},
	{id = 7590, chance = 2300},
	{id = 23540, chance = 1780},
	{id = 2645, chance = 450}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 70, attack = 50},
	{name ="walker skill reducer", interval = 2000, chance = 21, target = false},
	{name ="combat", interval = 2000, chance = 17, type = COMBAT_FIREDAMAGE, minDamage = -125, maxDamage = -245, length = 8, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false}
}

monster.defenses = {
	defense = 45,
	armor = 40
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 50},
	{type = COMBAT_FIREDAMAGE, percent = 35},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 5},
	{type = COMBAT_HOLYDAMAGE , percent = 40},
	{type = COMBAT_DEATHDAMAGE , percent = 10}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
