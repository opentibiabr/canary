local mType = Game.createMonsterType("Massive Earth Elemental")
local monster = {}

monster.description = "a massive earth elemental"
monster.experience = 950
monster.outfit = {
	lookType = 285,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 455
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Forbidden Lands, on top of a hill in the northern part of the Arena and Zoo Quarter, \z
		Lower Spike, Truffels Garden and Mushroom Gardens."
	}

monster.health = 1330
monster.maxHealth = 1330
monster.race = "undead"
monster.corpse = 8105
monster.speed = 185
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
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true
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
	{name = "small stone", chance = 25280, maxCount = 10},
	{name = "gold coin", chance = 32000, maxCount = 100},
	{name = "gold coin", chance = 32000, maxCount = 100},
	{name = "gold coin", chance = 32000, maxCount = 41},
	{name = "stone skin amulet", chance = 980},
	{name = "protection amulet", chance = 1580},
	{id = 3097, chance = 2790}, -- dwarven ring
	{name = "diamond sceptre", chance = 150},
	{name = "terra amulet", chance = 500},
	{id = 8895, chance = 3300}, -- rusted armor
	{name = "small topaz", chance = 5280, maxCount = 2},
	{name = "lump of earth", chance = 40680},
	{name = "clay lump", chance = 480},
	{id = 12600, chance = 430} -- coal
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -110},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -99, maxDamage = -145, range = 7, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_GREEN_RINGS, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -95, maxDamage = -169, range = 7, radius = 2, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_POFF, target = true},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 15, minDamage = -300, maxDamage = -320, length = 6, spread = 3, effect = CONST_ME_BIGPLANTS, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -200, maxDamage = -220, radius = 5, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false},
	{name ="speed", interval = 2000, chance = 20, speedChange = -330, range = 5, effect = CONST_ME_SMALLPLANTS, target = true, duration = 5000}
}

monster.defenses = {
	defense = 35,
	armor = 35,
	{name ="combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 150, maxDamage = 180, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 20},
	{type = COMBAT_ENERGYDAMAGE, percent = 90},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -15},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 100},
	{type = COMBAT_HOLYDAMAGE , percent = 50},
	{type = COMBAT_DEATHDAMAGE , percent = 45}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
