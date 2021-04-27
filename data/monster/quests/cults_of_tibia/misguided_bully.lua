local mType = Game.createMonsterType("Misguided Bully")
local monster = {}

monster.description = "a misguided bully"
monster.experience = 1200
monster.outfit = {
	lookType = 159,
	lookHead = 58,
	lookBody = 22,
	lookLegs = 41,
	lookFeet = 76,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1412
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Misguided Camp accessible via Outlaw Camp's portal."
	}

monster.health = 2000
monster.maxHealth = 2000
monster.race = "blood"
monster.corpse = 29361
monster.speed = 240
monster.manaCost = 390
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 95,
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
	{text = "Found one!", yell = false},
	{text = "Fortune brought you here, now let us lead you.", yell = false},
	{text = "You shall be guided.", yell = false}
}

monster.loot = {
	{id = 2148, chance = 100000, maxCount = 153},
	{id = 28657, chance = 5610},
	{id = 9971, chance = 4930},
	{id = 2158, chance = 4630}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -320},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -180, maxDamage = -230, range = 7, shootEffect = CONST_ANI_SPEAR, target = true}
}

monster.defenses = {
	defense = 35,
	armor = 35,
	{name ="heal monster", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -1},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = -1},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -1},
	{type = COMBAT_HOLYDAMAGE , percent = 1},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
