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
	lookMount = 0,
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
	Locations = "Alchemist Quarter and Factory Quarter (Yalahar), Robson's Isle, Tiquanda Laboratory.",
}

monster.health = 240
monster.maxHealth = 240
monster.race = "blood"
monster.corpse = 5798
monster.speed = 77
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Take that creature off my back!! I can feel it!", yell = false },
	{ text = "You will regret interrupting my studies!", yell = false },
	{ text = "You will be the next infected one... CRAAAHHH!", yell = false },
	{ text = "Science... is a curse.", yell = false },
	{ text = "Run as fast as you can.", yell = false },
	{ text = "Oh by the gods! What is this... aaaaaargh!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 88230, maxCount = 130 }, -- Gold Coin
	{ id = 3111, chance = 9833 }, -- Fishbone
	{ id = 3377, chance = 7390 }, -- Scale Armor
	{ id = 3492, chance = 9927, maxCount = 2 }, -- Worm
	{ id = 10308, chance = 19430 }, -- Mutated Flesh
	{ id = 3607, chance = 7555 }, -- Cheese
	{ id = 3045, chance = 5195 }, -- Strange Talisman
	{ id = 3264, chance = 4642 }, -- Sword
	{ id = 8894, chance = 2081 }, -- Heavily Rusted Armor
	{ id = 841, chance = 589 }, -- Peanut
	{ id = 3054, chance = 116 }, -- Silver Amulet
	{ id = 3737, chance = 403 }, -- Fern
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -90, condition = { type = CONDITION_POISON, totalDamage = 60, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -50, maxDamage = -60, length = 3, spread = 1, effect = CONST_ME_POISONAREA, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 20, minDamage = -190, maxDamage = -280, effect = CONST_ME_HITBYPOISON, target = true },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -600, range = 7, effect = CONST_ME_STUN, target = true, duration = 30000 },
}

monster.defenses = {
	defense = 15,
	armor = 14,
	mitigation = 0.59,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 220, effect = CONST_ME_GREEN_RINGS, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
