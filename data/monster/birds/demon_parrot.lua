local mType = Game.createMonsterType("Demon Parrot")
local monster = {}

monster.description = "a demon parrot"
monster.experience = 225
monster.outfit = {
	lookType = 217,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 562
monster.Bestiary = {
	class = "Bird",
	race = BESTY_RACE_BIRD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 1,
	Locations = "Isle of Evil."
	}

monster.health = 360
monster.maxHealth = 360
monster.race = "blood"
monster.corpse = 6056
monster.speed = 320
monster.manaCost = 250
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 20
}

monster.strategiesTarget = {
	nearest = 100,
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
	{text = "ISHH THAT THE BESHHT YOU HAVE TO OFFERRR, TIBIANSHH?", yell = false},
	{text = "YOU ARRRRRE DOOMED!", yell = false},
	{text = "I SHHMELL FEEAARRR!", yell = false},
	{text = "MY SHHEED IS FEARRR AND MY HARRRVEST ISHH YOURRR SHHOUL!", yell = false},
	{text = "Your shhoooul will be mineee!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 81630, maxCount = 99}
}

monster.attacks = {
	{name ="melee", interval = 1200, chance = 100, minDamage = 0, maxDamage = -100},
	{name ="drunk", interval = 1000, chance = 30, length = 5, spread = 3, effect = CONST_ME_SOUND_RED, target = false},
	{name ="combat", interval = 1000, chance = 30, type = COMBAT_LIFEDRAIN, minDamage = -25, maxDamage = -45, range = 5, shootEffect = CONST_ANI_SUDDENDEATH, target = false},
	{name ="combat", interval = 1000, chance = 30, type = COMBAT_LIFEDRAIN, minDamage = -15, maxDamage = -45, range = 1, target = false}
}

monster.defenses = {
	defense = 18,
	armor = 18
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
