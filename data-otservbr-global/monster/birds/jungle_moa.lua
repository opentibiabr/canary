local mType = Game.createMonsterType("Jungle Moa")
local monster = {}

monster.description = "a Jungle Moa"
monster.experience = 1200
monster.outfit = {
	lookType = 1534,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0
}

monster.raceId = 2257
monster.Bestiary = {
	class = "Bird",
	race = BESTY_RACE_BIRD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 2,
	Occurrence = 0,
	Locations = "Around Port Hope, Arena and Zoo Quarter in Yalahar, few on Zao steppes."
}

monster.health = 1300
monster.maxHealth = 1300
monster.race = "blood"
monster.corpse = 39208
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
	targetDistance = 1,
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
	{text = "Kreeee. Kreeeee.!", yell = false},
}

monster.loot = {
	{id = 39546, chance = 0},
	{name = "Gold Coin", chance = 100000, maxCount = 250},
	{name = "meat", chance = 100000, maxCount = 5},
	{name = "Jungle Moa Claw", chance = 7730},
	{name = "Cyan Crystal Fragment", chance = 3090},
	{name = "Jungle Moa Feather", chance = 100000, maxCount = 5},
	{name = "Jungle Moa Egg", chance = 15640},
	{name = "Spellbook of Enlightenment", chance = 1980},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -216},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_ENERGYDAMAGE, minDamage = -80, maxDamage = -100, range = 5, shootEffect = CONST_ANI_ENERGY, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -60, maxDamage = -140, range = 7, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -130, maxDamage = -170, length = 8, spread = 3, effect = CONST_ME_PURPLEENERGY, target = false},
}

monster.defenses = {
	defense = 110,
	armor = 120,
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 20},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = -5},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = -20},
	{type = COMBAT_DEATHDAMAGE , percent = 10}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)