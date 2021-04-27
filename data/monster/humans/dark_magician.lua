local mType = Game.createMonsterType("Dark Magician")
local monster = {}

monster.description = "a dark magician"
monster.experience = 185
monster.outfit = {
	lookType = 133,
	lookHead = 116,
	lookBody = 95,
	lookLegs = 50,
	lookFeet = 132,
	lookAddons = 2,
	lookMount = 0
}

monster.raceId = 371
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Hero Cave (Edron), Magician Tower, Dark Cathedral and Yalahar Academy of Magic in \z
		Magician Quarter and a single one on The Witches' Cliff (only accessible during a quest)."
	}

monster.health = 325
monster.maxHealth = 325
monster.race = "blood"
monster.corpse = 20367
monster.speed = 180
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
	targetDistance = 4,
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
	{text = "Feel the power of my runes!", yell = false},
	{text = "Killing you gets expensive!", yell = false},
	{text = "My secrets are mine alone!", yell = false},
	{text = "Stand still!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 75100, maxCount = 55},
	{name = "blank rune", chance = 10000},
	{name = "strong health potion", chance = 3000},
	{name = "strong mana potion", chance = 2860},
	{name = "health potion", chance = 12000},
	{name = "mana potion", chance = 11900},
	{name = "reins", chance = 20}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -40},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -5, maxDamage = -40, range = 7, shootEffect = CONST_ANI_FIRE, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -20, maxDamage = -30, range = 7, shootEffect = CONST_ANI_ENERGY, target = false}
}

monster.defenses = {
	defense = 15,
	armor = 15,
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 60, maxDamage = 80, effect = CONST_ME_MAGIC_GREEN, target = false},
	{name ="invisible", interval = 2000, chance = 10, effect = CONST_ME_MAGIC_BLUE}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = 20},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = 20},
	{type = COMBAT_DEATHDAMAGE , percent = -5}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
