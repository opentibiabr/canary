--# Monster converted using Devm monster converter #--
local mType = Game.createMonsterType("Skeleton")
local monster = {}

monster.description = "a skeleton"
monster.experience = 35
monster.outfit = {
	lookType = 33,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 33
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "In many dungeons around Tibia, like the Ancient Temple and Ghostlands. \z
		Also found in Rookgaard tombs and north east of Port Hope, in the jungle of Tiquanda, \z
		beneath Fenrock and in the desert Tombs, Vengoth Castle."
	}

monster.health = 50
monster.maxHealth = 50
monster.race = "undead"
monster.corpse = 5972
monster.speed = 77
monster.manaCost = 300

monster.changeTarget = {
	interval = 4000,
	chance = 0
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
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
	{id = 2920, chance = 10000}, -- torch
	{id = 2920, chance = 9880}, -- torch
	{id = 3031, chance = 43900, maxCount = 10}, -- gold coin
	{id = 3115, chance = 49100}, -- bone
	{id = 3264, chance = 1940}, -- sword
	{id = 3276, chance = 4850}, -- hatchet
	{id = 3286, chance = 4850}, -- mace
	{id = 3367, chance = 7520}, -- viking helmet
	{id = 3411, chance = 2090}, -- brass shield
	{id = 11481, chance = 9940}, -- pelvis bone
	{id = 23986, chance = 1000} -- heavy old tome
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -20},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -7, maxDamage = -13, range = 1, target = false}
}

monster.defenses = {
	defense = 10,
	armor = 10
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -5},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
