local mType = Game.createMonsterType("Crazed Beggar")
local monster = {}

monster.description = "a crazed beggar"
monster.experience = 35
monster.outfit = {
	lookType = 153,
	lookHead = 59,
	lookBody = 38,
	lookLegs = 38,
	lookFeet = 97,
	lookAddons = 3,
	lookMount = 0
}

monster.raceId = 525
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Factory, Foreigner, and Trade Quarters in Yalahar."
	}

monster.health = 100
monster.maxHealth = 100
monster.race = "blood"
monster.corpse = 20351
monster.speed = 154
monster.manaCost = 300
monster.maxSummons = 0

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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 10,
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
	{text = "Hehehe!", yell = false},
	{text = "Raahhh!", yell = false},
	{text = "You are one of THEM! Die!", yell = false},
	{text = "Wanna buy roses??", yell = false},
	{text = "They're coming! They're coming!", yell = false},
	{text = "Make it stop!", yell = false},
	{text = "Gimme money!", yell = false}
}

monster.loot = {
	{name = "small blue pillow", chance = 420},
	{id = 2072, chance = 360},
	{name = "gold coin", chance = 99000, maxCount = 9},
	{name = "dwarven ring", chance = 120},
	{id = 33528, chance = 55000},
	{name = "wooden hammer", chance = 6500},
	{name = "wooden spoon", chance = 9750},
	{id = 2570, chance = 5650},
	{name = "meat", chance = 9500},
	{name = "roll", chance = 22500},
	{name = "red rose", chance = 4700},
	{name = "sling herb", chance = 420},
	{name = "rum flask", chance = 420},
	{id = 6092, chance = 300},
	{id = 9808, chance = 80}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -25}
}

monster.defenses = {
	defense = 15,
	armor = 15
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 5},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 10},
	{type = COMBAT_DEATHDAMAGE , percent = -10}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
