local mType = Game.createMonsterType("Yakchal")
local monster = {}

monster.description = "Yakchal"
monster.experience = 4400
monster.outfit = {
	lookType = 149,
	lookHead = 8,
	lookBody = 0,
	lookLegs = 85,
	lookFeet = 85,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 5750
monster.maxHealth = 5750
monster.race = "blood"
monster.corpse = 20546
monster.speed = 220
monster.manaCost = 0
monster.maxSummons = 4

monster.changeTarget = {
	interval = 2000,
	chance = 5
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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 50,
	targetDistance = 4,
	runHealth = 100,
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

monster.summons = {
	{name = "Ice Golem", chance = 13, interval = 1000}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "YOU BETTER DIE TO MY MINIONS BECAUSE YOU'LL WISH YOU DID IF I COME FOR YOU!", yell = false},
	{text = "DESTROY THE INFIDELS", yell = false},
	{text = "You are mine!", yell = false},
	{text = "I will make you all pay!", yell = false},
	{text = "No one will stop my plans!", yell = false},
	{text = "You are responsible for this!", yell = false}
}

monster.loot = {
	{id = 7290, chance = 100000},
	{id = 2148, chance = 97000, maxCount = 283},
	{id = 5912, chance = 74000},
	{id = 7440, chance = 65000},
	{id = 9971, chance = 33000},
	{id = 7449, chance = 22000},
	{id = 2201, chance = 15000},
	{id = 7896, chance = 12000},
	{id = 7590, chance = 9500},
	{id = 7443, chance = 8000},
	{id = 7897, chance = 8000},
	{id = 2436, chance = 8000},
	{id = 7459, chance = 6350},
	{id = 7439, chance = 4700},
	{id = 2168, chance = 4700},
	{id = 7410, chance = 4700},
	{id = 2195, chance = 1500},
	{id = 2796, chance = 1500}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -389},
	{name ="combat", interval = 2000, chance = 18, type = COMBAT_ICEDAMAGE, minDamage = 0, maxDamage = -430, radius = 4, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEAREA, target = true},
	{name ="combat", interval = 3000, chance = 34, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -300, range = 7, radius = 3, shootEffect = CONST_ANI_SNOWBALL, target = true},
	{name ="speed", interval = 2000, chance = 10, speedChange = -300, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000}
}

monster.defenses = {
	defense = 20,
	armor = 15,
	{name ="combat", interval = 1000, chance = 25, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 50},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
