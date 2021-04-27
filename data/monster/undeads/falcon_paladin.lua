local mType = Game.createMonsterType("Falcon Paladin")
local monster = {}

monster.description = "a falcon paladin"
monster.experience = 6544
monster.outfit = {
	lookType = 1071,
	lookHead = 57,
	lookBody = 94,
	lookLegs = 38,
	lookFeet = 86,
	lookAddons = 2,
	lookMount = 0
}

monster.raceId = 1647
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Falcon Bastion."
	}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "blood"
monster.corpse = 32558
monster.speed = 220
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

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Uuunngh!", yell = false}
}

monster.loot = {
	{name = "Platinum Coin", chance = 90000, maxCount = 5},
	{name = "Small Diamond", chance = 41000, maxCount = 2},
	{name = "Great Spirit Potion", chance = 41000, maxCount = 2},
	{name = "Small Emerald", chance = 40000, maxCount = 2},
	{name = "Small Amethyst", chance = 40000, maxCount = 3},
	{name = "Assassin Star", chance = 25700, maxCount = 10},
	{name = "Small Ruby", chance = 20700, maxCount = 2},
	{name = "Small Topaz", chance = 20100, maxCount = 2},
	{name = "Onyx Arrow", chance = 14000, maxCount = 15},
	{name = "Red Gem", chance = 7500, maxCount = 3},
	{name = "Green Gem", chance = 4880},
	{name = "Violet Gem", chance = 4180},
	{id = 7633, chance = 2260},
	{name = "Damaged Armor Plates", chance = 1120},
	{name = "Falcon Crest", chance = 730},
	{name = "Golden Armor", chance = 310},
	{name = "Mastermind Shield", chance = 310}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250},
	{name ="combat", interval = 2000, chance = 50, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -550, range = 5, shootEffect = CONST_ANI_ROYALSPEAR, target = true},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = 500, range = 5, shootEffect = CONST_ANI_BOLT, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -350, maxDamage = -450, range = 7, radius = 2, shootEffect = CONST_ANI_POWERBOLT, effect = CONST_ME_ENERGYHIT, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -250, maxDamage = -350, length = 5, spread = 3, effect = CONST_ME_PURPLEENERGY, target = false}
}

monster.defenses = {
	defense = 50,
	armor = 82
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -5},
	{type = COMBAT_DEATHDAMAGE , percent = 55}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
