local mType = Game.createMonsterType("Nomad Female")
local monster = {}

monster.name = "Nomad"
monster.description = "a nomad"
monster.experience = 60
monster.outfit = {
	lookType = 150,
	lookHead = 96,
	lookBody = 39,
	lookLegs = 40,
	lookFeet = 3,
	lookAddons = 3,
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
monster.corpse = 18181
monster.speed = 95
monster.manaCost = 0

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
	pushable = true,
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
	canWalkOnPoison = false
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
	{id = 3031, chance = 56000, maxCount = 40}, -- gold coin
	{id = 11492, chance = 6420}, -- rope belt
	{id = 8010, chance = 4840, maxCount = 3}, -- potato
	{id = 3274, chance = 2730}, -- axe
	{id = 3359, chance = 2350}, -- brass armor
	{id = 3286, chance = 2150}, -- mace
	{id = 11456, chance = 2140}, -- dirty turban
	{id = 3409, chance = 900}, -- steel shield
	{id = 3353, chance = 660}, -- iron helmet
	{id = 7533, chance = 210} -- nomad parchment
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
