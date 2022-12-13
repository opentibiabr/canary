local mType = Game.createMonsterType("Cave Devourer")
local monster = {}

monster.description = "a cave devourer"
monster.experience = 2380
monster.outfit = {
	lookType = 1036,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1544
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Warzone 5."
	}

monster.health = 5400
monster.maxHealth = 5400
monster.race = "blood"
monster.corpse = 27559
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
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
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "*grrruuuuuuuuaaaaaaaar*", yell = false},
	{text = "*roooooo*", yell = false}
}

monster.loot = {
	{name = "cave devourer eyes", chance = 24580},
	{name = "cave devourer maw", chance = 27540},
	{name = "small enchanted sapphire", chance = 8050},
	{name = "small enchanted ruby", chance = 6780},
	{name = "crystalline arrow", chance = 23520, maxCount = 40},
	{name = "blue crystal shard", chance = 10590},
	{name = "violet crystal shard", chance = 7630},
	{name = "green crystal shard", chance = 8900},
	{name = "cyan crystal fragment", chance = 5720},
	{name = "slime heart", chance = 13770, maxCount = 4},
	{name = "cave devourer legs", chance = 17160},
	{id = 3049, chance = 2540}, -- stealth ring
	{name = "suspicious device", chance = 420}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400},
	{name ="stalagmite rune", interval = 2000, chance = 15, minDamage = -190, maxDamage = -300, range = 7, length = 6, spread = 3, shootEffect = CONST_ANI_POISON, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -70, maxDamage = -160, range = 3, length = 6, spread = 3, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -90, maxDamage = -160, range = 3, length = 6, spread = 3, effect = CONST_ME_HITBYFIRE, target = false},
	{name ="stone shower rune", interval = 2000, chance = 10, minDamage = -230, maxDamage = -450, range = 7, target = false}
}

monster.defenses = {
	defense = 5,
	armor = 10
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = -20},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
