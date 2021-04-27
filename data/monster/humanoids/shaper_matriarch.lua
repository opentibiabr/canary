local mType = Game.createMonsterType("Shaper Matriarch")
local monster = {}

monster.description = "a shaper matriarch"
monster.experience = 1650
monster.outfit = {
	lookType = 933,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1394
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Old Masonry, small dungeon under the Formorgar Mines."
	}

monster.health = 2000
monster.maxHealth = 2000
monster.race = "blood"
monster.corpse = 27739
monster.speed = 260
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0
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
	pushable = true,
	rewardBoss = false,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 15,
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
	{text = "Tar Marra Zik Tazz!", yell = false}
}

monster.loot = {
	{id = 27058, chance = 6000},
	{id = 2144, chance = 2500},
	{id = 27051, chance = 18000, maxCount = 2},
	{id = 27053, chance = 15000},
	{id = 2792, chance = 6800},
	{id = 27060, chance = 4300},
	{id = 2148, chance = 50320, maxCount = 150},
	{id = 2152, chance = 80000, maxCount = 2},
	{id = 27630, chance = 2800},
	{id = 27054, chance = 20000},
	{id = 2214, chance = 1300},
	{id = 9822, chance = 4500},
	{id = 2229, chance = 10000},
	{id = 2147, chance = 4000},
	{id = 2197, chance = 1500},
	{id = 7589, chance = 15000},
	{id = 27055, chance = 15000},
	{id = 2188, chance = 2000},
	{id = 8922, chance = 800},
	{id = 2031, chance = 2000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 15, attack = 25},
	{name ="combat", interval = 2000, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = -35, maxDamage = -160, range = 7, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_POISONAREA, target = false},
	{name ="combat", interval = 2000, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = -35, maxDamage = -160, radius = 3, effect = CONST_ME_ENERGYHIT, target = false},
	{name ="combat", interval = 2000, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -400, length = 6, spread = 3, effect = CONST_ME_MORTAREA, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 40,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 400, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 40},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -20},
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
