local mType = Game.createMonsterType("Nomad Female")
local monster = {}

monster.name = "Nomad"
monster.description = "a nomad"
monster.experience = 60
monster.outfit = {
	lookType = 150,
	lookHead = 115,
	lookBody = 39,
	lookLegs = 59,
	lookFeet = 2,
	lookAddons = 2,
	lookMount = 0
}

monster.raceId = 776
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 1,
	Locations = "Drefia, Ankrahmun."
	}

monster.health = 160
monster.maxHealth = 160
monster.race = "blood"
monster.corpse = 20462
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 15,
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
	{text = "I will leave your remains to the vultures!", yell = false},
	{text = "We are the true sons of the desert!", yell = false},
	{text = "We are swift as the wind of the desert!", yell = false},
	{text = "Your riches will be mine!", yell = false}
}

monster.loot = {
	{id = 2148, chance = 56000, maxCount = 40},
	{id = 12448, chance = 6420},
	{id = 8838, chance = 4840, maxCount = 3},
	{id = 2386, chance = 2730},
	{id = 2465, chance = 2350},
	{id = 2398, chance = 2150},
	{id = 12412, chance = 2140},
	{id = 2509, chance = 900},
	{id = 2459, chance = 660},
	{id = 8267, chance = 210}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -80},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, radius = 1, effect = CONST_ME_SOUND_WHITE, target = false}
}

monster.defenses = {
	defense = 15,
	armor = 15
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -10},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 20},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = 20},
	{type = COMBAT_DEATHDAMAGE , percent = -10}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
