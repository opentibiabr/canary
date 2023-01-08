local mType = Game.createMonsterType("Gazer Spectre")
local monster = {}

monster.description = "a Gazer Spectre"
monster.experience = 4200
monster.outfit = {
	lookType = 1122,
	lookHead = 94,
	lookBody = 21,
	lookLegs = 77,
	lookFeet = 78,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1725
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Haunted Temple, Buried Cathedral."
	}

monster.health = 4500
monster.maxHealth = 4500
monster.race = "blood"
monster.corpse = 30167
monster.speed = 195
monster.manaCost = 0

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
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Deathhh... is... a.... doooor!!", yell = false},
	{text = "Tiiimeee... is... a... windowww!", yell = false}
}

monster.loot = {
	{name = "platinum coin", chance = 100000, maxCount = 5},
	{name = "brown crystal splinter", chance = 900},
	{name = "red crystal fragment", chance = 8500},
	{name = "small enchanted ruby", chance = 7500},
	{name = "small diamond", chance = 6000},
	{name = "small sapphire", chance = 5000},
	{id= 3039, chance = 4000}, -- red gem
	{name = "yellow gem", chance = 3000},
	{id = 29299, chance = 1100}, -- golden idol of tukh
	{name = "wand of draconia", chance = 3500},
	{name = "wand of inferno", chance = 1100},
	{id = 30084, chance = 700}, -- red ectoplasm
	{name = "magma coat", chance = 900},
	{name = "prismatic quartz", chance = 1500},
	{name = "small enchanted emerald", chance = 800},
	{name = "onyx chip", chance = 770},
	{name = "hexagonal ruby", chance = 500}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -250, maxDamage = -480},
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -350, range = 7, shootEffect = CONST_ANI_FIRE, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -350, radius = 3, effect = CONST_ME_FIREATTACK, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -250, maxDamage = -430, length = 4, spread = 3, effect = CONST_ME_YELLOWENERGY, target = false}
}

monster.defenses = {
	defense = 78,
	armor = 78,
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.reflects = {
	{type = COMBAT_FIREDAMAGE, percent = 133}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 85},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 70},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -30},
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
