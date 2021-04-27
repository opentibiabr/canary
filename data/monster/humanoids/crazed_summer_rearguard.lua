local mType = Game.createMonsterType("Crazed Summer Rearguard")
local monster = {}

monster.description = "a Crazed Summer Rearguard"
monster.experience = 4700
monster.outfit = {
	lookType = 1136,
	lookHead = 1,
	lookBody = 94,
	lookLegs = 20,
	lookFeet = 119,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1733
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 5,
	Occurrence = 0,
	Locations = "Court of Winter, Dream Labyrinth."
	}

monster.health = 5300
monster.maxHealth = 5300
monster.race = "blood"
monster.corpse = 34719
monster.speed = 400
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
	canPushCreatures = true,
	staticAttackChance = 90,
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
	{text = "Is this real life?", yell = false},
	{text = "Weeeuuu weeeuuu!!!", yell = false}
}

monster.loot = {
	{name = "power bolt", chance = 1000000},
	{name = "small enchanted sapphire", chance = 1000000, maxCount = 2},
	{name = "platinum coin", chance = 1000000, maxCount = 5},
	{id = 5921, chance = 1500},
	{name = "dream essence egg", chance = 1155},
	{name = "elvish talisman", chance = 1355},
	{name = "violet crystal shard", chance = 1475},
	{name = "small enchanted ruby", chance = 1755},
	{name = "red crystal fragment", chance = 1565},
	{name = "leaf star", chance = 11100, maxCount = 8},
	{id = 26185, chance = 1000},
	{name = "sun fruit", chance = 25800},
	{id = 26198, chance = 1590},-- collar of blue plasma
	{name = "wood cape", chance = 30000},
	{name = "small diamond", chance = 800},
	{name = "yellow gem", chance = 640},
	{name = "crystal crossbow", chance = 600}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -210, maxDamage = -530},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -270, maxDamage = -710, length = 3, spread = 0, effect = CONST_ME_FIREAREA, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -250, maxDamage = -300, range = 7, shootEffect = CONST_ANI_FIRE, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -380, radius = 5, effect = CONST_ME_EXPLOSIONHIT, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -350, radius = 5, effect = CONST_ME_EXPLOSIONAREA, target = true}
}

monster.defenses = {
	defense = 20,
	armor = 70
}

monster.reflects = {
	{type = COMBAT_FIREDAMAGE, percent = 70}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 30},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = 50},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = true},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
