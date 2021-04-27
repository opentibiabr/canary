local mType = Game.createMonsterType("Nomad")
local monster = {}

monster.description = "a nomad"
monster.experience = 60
monster.outfit = {
	lookType = 146,
	lookHead = 114,
	lookBody = 20,
	lookLegs = 22,
	lookFeet = 2,
	lookAddons = 2,
	lookMount = 0
}

monster.raceId = 310
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 1,
	Locations = "Ankrahmun Pharaoh Tombs, Deeper Drefia, Kha'zeel Mountains, Northern Darama Desert, \z
		Southern Darama Desert, Yalahar Foreigner Quarter, Yalahar Trade Quarter."
	}

monster.health = 160
monster.maxHealth = 160
monster.race = "blood"
monster.corpse = 20466
monster.speed = 190
monster.manaCost = 420
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
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
	{text = "We are the true sons of the desert!", yell = false},
	{text = "I will leave your remains to the vultures!", yell = false},
	{text = "Your riches will be mine!", yell = false},
	{text = "We are swift as the wind of the desert!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 56250, maxCount = 40},
	{name = "axe", chance = 2730},
	{name = "mace", chance = 2120},
	{name = "iron helmet", chance = 650},
	{name = "brass armor", chance = 2350},
	{name = "steel shield", chance = 920},
	{name = "nomad parchment", chance = 200},
	{name = "potato", chance = 4840, maxCount = 3},
	{name = "dirty turban", chance = 2160},
	{name = "rope belt", chance = 6420}
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
