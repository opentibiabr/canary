local mType = Game.createMonsterType("Burster Spectre")
local monster = {}

monster.description = "a Burster Spectre"
monster.experience = 6000
monster.outfit = {
	lookType = 1122,
	lookHead = 7,
	lookBody = 19,
	lookLegs = 86,
	lookFeet = 19,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1726
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Haunted Tomb west of Darashia, Buried Cathedral."
	}

monster.health = 6500
monster.maxHealth = 6500
monster.race = "blood"
monster.corpse = 34801
monster.speed = 400
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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
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
	{text = "We came tooo thiiiiss wooorld to... get youuu!", yell = false}
}

monster.loot = {
	{name = "platinum coin", chance = 100000, maxCount = 7},
	{name = "great spirit potion", chance = 100000, maxCount = 3},
	{name = "protection amulet", chance = 15000},
	{name = "life crystal", chance = 12050},
	{name = "silver amulet", chance = 15000},
	{name = "wand of voodoo", chance = 11050},
	{name = "wand of cosmic energy", chance = 11800},
	{name = "dragon necklace", chance = 16600},
	{name = "stone skin amulet", chance = 8860},
	{id = 34720, chance = 15600},
	{name = "glacier amulet", chance = 16890},
	{name = "orb", chance = 18980},
	{name = "hailstorm rod", chance = 17550},
	{name = "elven amulet", chance = 1800},
	{name = "garlic necklace", chance = 2640},
	{name = "platinum amulet", chance = 2600},
	{name = "mind stone", chance = 1800},
	{name = "glacial rod", chance = 520},
	{name = "shockwave amulet", chance = 620},
	{name = "strange symbol", chance = 720},
	{name = "hexagonal ruby", chance = 480}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -400, maxDamage = -580},
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_LIFEDRAIN, minDamage = -270, maxDamage = -390, radius = 4, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_ICEDAMAGE, minDamage = -280, maxDamage = -410, radius = 4, effect = CONST_ME_ICEAREA, target = true},
	{name ="combat", interval = 2000, chance = 5200, type = COMBAT_ICEDAMAGE, minDamage = -280, maxDamage = -370, effect = CONST_ME_ICEATTACK, target = true},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -200, maxDamage = -290, length = 5, spread = 3, effect = CONST_ME_ICEATTACK, target = false}
}

monster.defenses = {
	defense = 70,
	armor = 70,
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.reflects = {
	{type = COMBAT_ICEDAMAGE, percent = 133}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 100},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = -20},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 70},
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
