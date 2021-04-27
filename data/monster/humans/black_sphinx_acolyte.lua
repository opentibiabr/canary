local mType = Game.createMonsterType("Black Sphinx Acolyte")
local monster = {}

monster.description = "a black sphinx acolyte"
monster.experience = 7200
monster.outfit = {
	lookType = 1200,
	lookHead = 114,
	lookBody = 95,
	lookLegs = 94,
	lookFeet = 95,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1800
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Issavi Sewers, Kilmaresh Catacombs and Kilmaresh Mountains (above and under ground)."
	}

monster.health = 8100
monster.maxHealth = 8100
monster.race = "blood"
monster.corpse = 36258
monster.speed = 310
monster.manaCost = 0
monster.maxSummons = 1

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
	canPushCreatures = false,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.summons = {
	{name = "Skeleton Elite Warrior", chance = 10, interval = 2000, max = 1}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Darkness is the mother of all knowledge!", yell = false},
	{text = "Get thee gone, unworthy!", yell = false},
	{text = "The Black Sphinx will prevail!", yell = false}
}

monster.loot = {
	{name = "Platinum Coin", chance = 100000, maxCount = 5},
	{name = "Blue Crystal Shard", chance = 5000},
	{name = "Snakebite Rod", chance = 4700},
	{name = "Underworld Rod", chance = 3400},
	{name = "Violet Gem", chance = 2600},
	{name = "Opal", chance = 2200, maxCount = 2},
	{name = "Wand of Voodoo", chance = 2200},
	{id = 36166, chance = 3400},
	{name = "Small Enchanted Emerald", chance = 1500, maxCount = 3}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -400, radius = 3, effect = CONST_ME_SMALLPLANTS, target = false},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -450, range = 4, radius = 3, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true}
}

monster.defenses = {
	defense = 82,
	armor = 82
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 10},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -30},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
