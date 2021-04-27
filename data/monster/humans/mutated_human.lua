local mType = Game.createMonsterType("Mutated Human")
local monster = {}

monster.description = "a mutated human"
monster.experience = 150
monster.outfit = {
	lookType = 323,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 521
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Alchemist Quarter and Factory Quarter (Yalahar), Robson's Isle, Tiquanda Laboratory."
	}

monster.health = 240
monster.maxHealth = 240
monster.race = "blood"
monster.corpse = 9107
monster.speed = 154
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
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
	{text = "Take that creature off my back!! I can feel it!", yell = false},
	{text = "You will regret interrupting my studies!", yell = false},
	{text = "You will be the next infected one... CRAAAHHH!", yell = false},
	{text = "Science... is a curse.", yell = false},
	{text = "Run as fast as you can.", yell = false},
	{text = "Oh by the gods! What is this... aaaaaargh!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 44000, maxCount = 80},
	{name = "gold coin", chance = 44000, maxCount = 50},
	{name = "strange talisman", chance = 4980},
	{name = "silver amulet", chance = 70},
	{name = "fishbone", chance = 10050},
	{id = 2376, chance = 5030},
	{name = "scale armor", chance = 8080},
	{id = 2696, chance = 8000},
	{name = "fern", chance = 420},
	{name = "worm", chance = 7110, maxCount = 2},
	{name = "peanut", chance = 580},
	{id = 9808, chance = 190},
	{name = "mutated flesh", chance = 19940}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -90, condition = {type = CONDITION_POISON, totalDamage = 60, interval = 4000}},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -50, maxDamage = -60, length = 3, spread = 1, effect = CONST_ME_POISONAREA, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 20, minDamage = -190, maxDamage = -280, effect = CONST_ME_HITBYPOISON, target = true},
	{name ="speed", interval = 2000, chance = 10, speedChange = -600, range = 7, effect = CONST_ME_STUN, target = true, duration = 30000}
}

monster.defenses = {
	defense = 15,
	armor = 15,
	{name ="speed", interval = 2000, chance = 15, speedChange = 220, effect = CONST_ME_GREEN_RINGS, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 20},
	{type = COMBAT_HOLYDAMAGE , percent = -25},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
