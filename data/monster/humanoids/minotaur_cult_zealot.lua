local mType = Game.createMonsterType("Minotaur Cult Zealot")
local monster = {}

monster.description = "a minotaur cult zealot"
monster.experience = 1350
monster.outfit = {
	lookType = 29,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1510
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Minotaurs Cult Cave."
	}

monster.health = 1800
monster.maxHealth = 1800
monster.race = "blood"
monster.corpse = 5983
monster.speed = 250
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
	canPushCreatures = false,
	staticAttackChance = 95,
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
	{text = "Kirll Karrrl!", yell = false},
	{text = "Kaplar!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 100000, maxCount = 150},
	{name = "snakebite rod", chance = 11670},
	{name = "taurus mace", chance = 5360},
	{name = "cultish robe", chance = 9200},
	{name = "purple robe", chance = 16230},
	{name = "strong mana potion", chance = 10660, maxCount = 3},
	{name = "small ruby", chance = 2030, maxCount = 2},
	{name = "small topaz", chance = 2680, maxCount = 2},
	{name = "yellow gem", chance = 220},
	{name = "platinum coin", chance = 39350, maxCount = 3},
	{name = "small emerald", chance = 2540, maxCount = 2},
	{name = "small sapphire", chance = 2170, maxCount = 2},
	{name = "small diamond", chance = 2900, maxCount = 2},
	{name = "small amethyst", chance = 2610, maxCount = 2},
	{name = "red piece of cloth", chance = 2460},
	{name = "red gem", chance = 70},
	{name = "minotaur leather", chance = 4780},
	{name = "minotaur horn", chance = 2320, maxCount = 2}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -180, maxDamage = -230, range = 7, shootEffect = CONST_ANI_WHIRLWINDAXE, target = true},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -180, maxDamage = -250, range = 7, effect = CONST_ME_EXPLOSIONHIT, target = true}
}

monster.defenses = {
	defense = 30,
	armor = 30
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
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
