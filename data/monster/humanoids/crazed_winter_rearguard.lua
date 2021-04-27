local mType = Game.createMonsterType("Crazed Winter Rearguard")
local monster = {}

monster.description = "a Crazed Winter Rearguard"
monster.experience = 4700
monster.outfit = {
	lookType = 1136,
	lookHead = 86,
	lookBody = 85,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1731
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Court of Winter, Dream Labyrinth."
	}

monster.health = 5200
monster.maxHealth = 5200
monster.race = "blood"
monster.corpse = 34764
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
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{name = "platinum coin", chance = 100000, maxCount = 5},
	{name = "red crystal fragment", chance = 1000000},
	{name = "red gem", chance = 1000000},
	{name = "ice rapier", chance = 15000},
	{name = "ultimate health potion", chance = 21550},
	{name = "great spirit potion", chance = 23550},
	{id = 34696, chance = 14750, maxCount = 2},
	{name = "life crystal", chance = 17550},
	{name = "dream essence egg", chance = 6350},
	{name = "elven astral observer", chance = 14600},
	{name = "glacier mask", chance = 6850},
	{name = "moonlight rod", chance = 11250},
	{name = "small enchanted sapphire", chance = 6850, maxCount = 7},
	{name = "northwind rod", chance = 1000},
	{name = "glacier amulet", chance = 500},
	{name = "hailstorm rod", chance = 1000},
	{name = "glacier robe", chance = 500},
	{name = "cyan crystal fragment", chance = 500},
	{name = "elven amulet", chance = 500},
	{name = "blue gem", chance = 1800}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -110, maxDamage = -400},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = -200, maxDamage = -300, radius = 3, effect = CONST_ME_ICEAREA, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = -250, maxDamage = -300, range = 7, shootEffect = CONST_ANI_ICE, target = false}
}

monster.defenses = {
	defense = 20,
	armor = 70
}

monster.reflects = {
	{type = COMBAT_ICEDAMAGE, percent = 70}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 30},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 100},
	{type = COMBAT_HOLYDAMAGE , percent = 50},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = true},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
