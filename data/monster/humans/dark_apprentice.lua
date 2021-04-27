local mType = Game.createMonsterType("Dark Apprentice")
local monster = {}

monster.description = "a dark apprentice"
monster.experience = 100
monster.outfit = {
	lookType = 133,
	lookHead = 78,
	lookBody = 57,
	lookLegs = 95,
	lookFeet = 115,
	lookAddons = 1,
	lookMount = 0
}

monster.raceId = 372
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Magician Tower, Dark Cathedral, Hero Cave, Magician Quarter."
	}

monster.health = 225
monster.maxHealth = 225
monster.race = "blood"
monster.corpse = 20363
monster.speed = 172
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
	{text = "Outch!", yell = false},
	{text = "Oops, I did it again.", yell = false},
	{text = "From the spirits that I called Sir, deliver me!", yell = false},
	{text = "I must dispose of my masters enemies!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 7500, maxCount = 45},
	{name = "wand of decay", chance = 110},
	{name = "wand of dragonbreath", chance = 1980},
	{name = "blank rune", chance = 8125, maxCount = 3},
	{name = "health potion", chance = 2900},
	{name = "mana potion", chance = 2980},
	{name = "reins", chance = 10}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -60},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -2, maxDamage = -26, range = 7, shootEffect = CONST_ANI_FIRE, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -10, maxDamage = -20, range = 7, shootEffect = CONST_ANI_ENERGY, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -24, range = 7, shootEffect = CONST_ANI_SMALLSTONE, target = false},
	{name ="outfit", interval = 2000, chance = 1, range = 3, shootEffect = CONST_ANI_EXPLOSION, target = true, duration = 2000, outfitMonster = "cyclops"},
	{name ="outfit", interval = 2000, chance = 1, radius = 4, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 2000, outfitItem = 2324}
}

monster.defenses = {
	defense = 15,
	armor = 15,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 30, maxDamage = 40, effect = CONST_ME_MAGIC_GREEN, target = false},
	{name ="outfit", interval = 2000, chance = 5, target = true, duration = 3000, outfitMonster = "green frog"}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = -5}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
