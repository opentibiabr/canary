local mType = Game.createMonsterType("Meandering Mushroom")
local monster = {}

monster.description = "a Meandering Mushroom"
monster.experience = 19800
monster.outfit = {
	lookType = 1621,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 2376
monster.Bestiary = {
	class = "Plant",
	race = BESTY_RACE_PLANT,
	toKill = 5000,
	FirstUnlock = 25,
	SecondUnlock = 3394,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Sanctuary."
	}

monster.health = 29100
monster.maxHealth = 29100
monster.race = "undead"
monster.corpse = 43559
monster.speed = 205
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	runHealth = 800,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
}

monster.loot = {
	{name = "crystal coin", chance = 70540},
	{name = "platinum coin", chance = 90540, maxCount = 50},
	{name = "ultimate health potion", chance = 32220, maxCount = 7},
	{name = "small diamond", chance = 65560, maxCount = 7},
	{name = "gold ingot", chance = 25560},
	{name = "blue crystal splinter", chance = 25560},
	{name = "cyan crystal fragment", chance = 25560},
	{name = "red crystal fragment", chance = 25560},
	{name = "giant sword", chance = 13500},
	{name = "war axe", chance = 9500},
	{name = "mercenary sword", chance = 11500},
	{name = "green crystal fragment", chance = 9500},
	{name = "onyx chip", chance = 7500},
	{name = "crystal sword", chance = 4710},
	{id = 43848, chance = 13000},
	{id = 43849, chance = 16500},
	{id = 43858, chance = 9000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -850, maxDamage = -1200},
	{name ="combat", interval = 3000, chance = 24, type = COMBAT_EARTHDAMAGE, minDamage = -900, maxDamage = -1300, range = 7, radius = 3, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -1100, maxDamage = -1400, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	{name ="combat", interval = 3000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -450, maxDamage = -1100, radius = 4, effect = CONST_ME_FIREAREA, target = false}
}


monster.defenses = {
	defense = 100,
	armor = 115
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -10},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 50},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = -30},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
