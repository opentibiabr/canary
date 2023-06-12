local mType = Game.createMonsterType("Stalking Stalk")
local monster = {}

monster.description = "a Stalking Stalk"
monster.experience = 11569
monster.outfit = {
	lookType = 1554,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0
}

monster.raceId = 2272
monster.Bestiary = {
	class = "Plant",
	race = BESTY_RACE_PLANT,
	toKill = 5000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 1,
	Locations = "Monster Graveyard"
}

monster.health = 17100
monster.maxHealth = 17100
monster.race = "blood"
monster.corpse = 39307
monster.speed = 190
monster.manaCost = 0
monster.maxSummons = 0

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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 2,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Sizzzle...", yell = false},
}

monster.loot = {
	{name = "Stalking Seeds", chance = 21520},
	{name = "Crystal Coin", chance = 16570, minCount = 1, maxCount = 3},
	{name = "Small Diamond", chance = 7140, minCount = 1, maxCount = 3},
	{name = "Green Crystal Fragment", chance = 5030},
	{name = "Dragon Necklace", chance = 4540},
	{name = "Opal", chance = 3960, minCount = 1, maxCount = 2},
	{name = "Magma Coat", chance = 2160},
	{name = "Bow", chance = 2000},
	{name = "Green Gem", chance = 1780},
	{name = "Warrior's Axe", chance = 1700},
	{name = "Muck Rod", chance = 1310},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 300, maxDamage = -400, effect = CONST_ME_CARNIPHILA},
	{name ="combat", interval = 2500, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 1012, maxDamage = -1049, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_HITBYFIRE, target = true},
	{name ="combat", interval = 1900, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 1020, maxDamage = -1090, range = 5, radius = 4,  shootEffect = CONST_ANI_FIRE, effect = CONST_ME_PLANTATTACK, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -800, length = 7, spread = 0, effect = CONST_ME_PINK_ENERGY_SPARK, target = false},
}

monster.defenses = {
	defense = 110,
	armor = 76,
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -25},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 25},
	{type = COMBAT_FIREDAMAGE, percent = 25},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 10}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
