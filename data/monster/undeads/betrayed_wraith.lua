local mType = Game.createMonsterType("Betrayed Wraith")
local monster = {}

monster.description = "a betrayed wraith"
monster.experience = 3500
monster.outfit = {
	lookType = 233,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 284
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Pits of Inferno, Helheim, The Inquisition Quest, Roshamuul Prison."
	}

monster.health = 4200
monster.maxHealth = 4200
monster.race = "undead"
monster.corpse = 6316
monster.speed = 346
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 300,
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
	{text = "Rrrah!", yell = false},
	{text = "Gnarr!", yell = false},
	{text = "Tcharrr!", yell = false}
}

monster.loot = {
	{name = "small diamond", chance = 11800, maxCount = 4},
	{name = "gold coin", chance = 100000, maxCount = 200},
	{name = "platinum coin", chance = 100000, maxCount = 8},
	{name = "power bolt", chance = 50000, maxCount = 5},
	{name = "orichalcum pearl", chance = 8000, maxCount = 2},
	{name = "skull helmet", chance = 390},
	{name = "golden figurine", chance = 160},
	{name = "soul orb", chance = 10000},
	{id = 6300, chance = 390},
	{name = "demonic essence", chance = 19430},
	{name = "concentrated demonic blood", chance = 65250},
	{name = "assassin star", chance = 10780, maxCount = 5},
	{name = "mercenary sword", chance = 1890},
	{name = "bloody edge", chance = 80},
	{name = "great mana potion", chance = 15000, maxCount = 3},
	{name = "ultimate health potion", chance = 15410},
	{name = "unholy bone", chance = 18410}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450},
	{name ="betrayed wraith skill reducer", interval = 2000, chance = 10, target = false},
	{name ="speed", interval = 2000, chance = 20, speedChange = -600, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = true, duration = 3000}
}

monster.defenses = {
	defense = 55,
	armor = 55,
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 350, maxDamage = 600, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="invisible", interval = 2000, chance = 10},
	{name ="speed", interval = 2000, chance = 15, speedChange = 460, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = -20},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
