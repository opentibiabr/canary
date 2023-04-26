local mType = Game.createMonsterType("Nighthunter")
local monster = {}

monster.description = "a Nighthunter"
monster.experience = 12647
monster.outfit = {
	lookType = 1552,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0
}

monster.raceId = 2270
monster.Bestiary = {
	class = "Mammal",
	race = BESTY_RACE_MAMMAL,
	toKill = 5000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 1,
	Locations = "Monster Graveyard"
}

monster.health = 19200
monster.maxHealth = 19200
monster.race = "blood"
monster.corpse = 39299
monster.speed = 205
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
	{text = "Shriiiiek! Shriiiiek!", yell = false},
}

monster.loot = {
	{name = "Crystal Coin", chance = 34190},
	{name = "Nighthunter Wing", chance = 24370, minCount = 1, maxCount = 2},
	{name = "Ultimate Health Potion", chance = 12640, minCount = 1, maxCount = 3},
	{name = "Red Crystal Fragment", chance = 3980},
	{name = "Green Crystal Shard", chance = 3670},
	{name = "Cyan Crystal Fragment", chance = 3080},
	{name = "Yellow Gem", chance = 2940},
	{name = "Crystal Sword", chance = 1590},
	{name = "Warrior's Axe", chance = 1400},
	{name = "Spellbook of Mind Control", chance = 960},
	{name = "Stone Skin Amulet", chance = 850},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -300, maxDamage = -450, length = 5, spread = 2, effect = CONST_ME_ENERGYAREA, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -260, maxDamage = -450, range = 7, radius = 3, effect = CONST_ME_ENERGYAREA, target = true}
}

monster.defenses = {
	defense = 85,
	armor = 81,
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 20},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = -5},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = -20},
	{type = COMBAT_DEATHDAMAGE , percent = 10}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)