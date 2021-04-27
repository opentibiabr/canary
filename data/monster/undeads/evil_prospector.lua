local mType = Game.createMonsterType("Evil Prospector")
local monster = {}

monster.description = "Evil Prospector"
monster.experience = 7500
monster.outfit = {
	lookType = 1268,
	lookHead = 0,
	lookBody = 13,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 1,
	lookMount = 0
}

monster.raceId = 1885
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Barren Drift."
	}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "undead"
monster.corpse = 37445
monster.speed = 220
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
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
	targetDistance = 3,
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
}

monster.loot = {
	{name = "platinum coin", chance = 100000, maxCount = 5},
	{name = "spectral silver nugget", chance = 17110, maxCount = 2},
	{name = "wand of starstorm", chance = 13160, maxCount = 10},
	{name = "lightning pendant", chance = 9210},
	{name = "emerald bangle", chance = 3950},
	{name = "strange talisman", chance = 2630},
	{name = "wand of defiance", chance = 2630},
	{name = "lightning headband", chance = 1320}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -500},
	{name ="combat", interval = 1700, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -250, maxDamage = -550, radius = 3, shootEffect = CONST_ANI_ENVENOMEDARROW, target = true},
	{name ="combat", interval = 1700, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -250, maxDamage = -550, length = 4, spread = 3, effect = CONST_ME_ENERGYHIT, target = false},
	{name ="combat", interval = 1700, chance = 35, type = COMBAT_DEATHDAMAGE, minDamage = -250, maxDamage = -550, radius = 3, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 1700, chance = 35, type = COMBAT_HOLYDAMAGE, minDamage = -250, maxDamage = -400, radius = 3, effect = CONST_ME_HOLYAREA, target = false},
	{name ="combat", interval = 1700, chance = 13, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -450, range = 4, radius = 4, effect = CONST_ME_ENERGYAREA, target = true}
}

monster.defenses = {
	defense = 40,
	armor = 100
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 100},
	{type = COMBAT_ENERGYDAMAGE, percent = 30},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 60},
	{type = COMBAT_DEATHDAMAGE , percent = -10}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
