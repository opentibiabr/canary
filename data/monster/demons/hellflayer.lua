local mType = Game.createMonsterType("Hellflayer")
local monster = {}

monster.description = "a hellflayer"
monster.experience = 11000
monster.outfit = {
	lookType = 856,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1198
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "The Dungeons of The Ruthless Seven."
	}

monster.health = 14000
monster.maxHealth = 14000
monster.race = "blood"
monster.corpse = 25440
monster.speed = 330
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{text = "You should consider bargaining for your life!", yell = false},
	{text = "Your tainted soul belongs to us anyway!", yell = false}
}

monster.loot = {
	{id = 2148, chance = 90000, maxCount = 130},
	{id = 2152, chance = 20000, maxCount = 9},
	{id = 6558, chance = 4000, maxCount = 3},
	{id = 9971, chance = 1300, maxCount = 2},
	{id = 7590, chance = 9600, maxCount = 2},
	{id = 8472, chance = 2300, maxCount = 2},
	{id = 2150, chance = 2000, maxCount = 5},
	{id = 2145, chance = 900, maxCount = 5},
	{id = 2149, chance = 900, maxCount = 5},
	{id = 2147, chance = 2000, maxCount = 5},
	{id = 9970, chance = 900, maxCount = 5},
	{id = 8473, chance = 5300, maxCount = 2},
	{id = 2136, chance = 1000},
	{id = 6500, chance = 1600},
	{id = 7632, chance = 800},
	{id = 2155, chance = 800},
	{id = 7891, chance = 500},
	{id = 7894, chance = 1200},
	{id = 2514, chance = 350},
	{id = 25385, chance = 800},
	{id = 2156, chance = 500},
	{id = 25522, chance = 280},
	{id = 25523, chance = 180},
	{id = 5741, chance = 450},
	{id = 25383, chance = 200},
	{id = 7413, chance = 900},
	{id = 2466, chance = 750},
	{id = 8902, chance = 900},
	{id = 2452, chance = 400}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 200, maxDamage = -869, condition = {type = CONDITION_FIRE, totalDamage = 6, interval = 9000}},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -170, maxDamage = -300, range = 7, shootEffect = CONST_ANI_POISON, target = false},
	{name ="renegade knight", interval = 2000, chance = 20, target = false},
	{name ="choking fear drown", interval = 2000, chance = 20, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -250, maxDamage = -500, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -50, maxDamage = -200, length = 8, spread = 3, effect = CONST_ME_PURPLEENERGY, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -550, radius = 1, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREATTACK, target = true},
	{name ="warlock skill reducer", interval = 2000, chance = 5, range = 5, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 300, maxDamage = -500, radius = 1, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_SLEEP, target = true}
}

monster.defenses = {
	defense = 20,
	armor = 20,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 80, maxDamage = 95, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
