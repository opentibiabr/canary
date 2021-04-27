local mType = Game.createMonsterType("Sea Serpent")
local monster = {}

monster.description = "a sea serpent"
monster.experience = 2300
monster.outfit = {
	lookType = 275,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 438
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Sea Serpent Area and Seacrest Grounds."
	}

monster.health = 1950
monster.maxHealth = 1950
monster.race = "blood"
monster.corpse = 8307
monster.speed = 480
monster.manaCost = 390
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
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
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
	{text = "CHHHRRRR", yell = false},
	{text = "HISSSS", yell = false}
}

monster.loot = {
	{name = "small sapphire", chance = 5600, maxCount = 3},
	{name = "gold coin", chance = 38000, maxCount = 100},
	{name = "gold coin", chance = 30000, maxCount = 100},
	{name = "gold coin", chance = 30000, maxCount = 36},
	{name = "platinum coin", chance = 25000, maxCount = 3},
	{name = "stealth ring", chance = 400},
	{name = "ring of healing", chance = 1100},
	{name = "serpent sword", chance = 4200},
	{name = "plate legs", chance = 7150},
	{name = "dragon ham", chance = 60000, maxCount = 2},
	{name = "strong health potion", chance = 5500},
	{name = "strong mana potion", chance = 3850},
	{name = "great mana potion", chance = 920},
	{name = "glacier amulet", chance = 880},
	{name = "glacier kilt", chance = 430},
	{name = "spirit cloak", chance = 2900},
	{name = "focus cape", chance = 370},
	{name = "crystalline armor", chance = 90},
	{name = "northwind rod", chance = 930},
	{name = "sea serpent scale", chance = 10200}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -60, maxDamage = -300, length = 7, spread = 2, effect = CONST_ME_SMALLPLANTS, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -101, maxDamage = -300, length = 7, spread = 2, effect = CONST_ME_ICEATTACK, target = false},
	{name ="sea serpent drown", interval = 2000, chance = 15, range = 5, target = false}
}

monster.defenses = {
	defense = 45,
	armor = 45,
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 70, maxDamage = 273, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = 400, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -15},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 30},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 100},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 10}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
