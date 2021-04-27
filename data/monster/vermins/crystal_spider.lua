local mType = Game.createMonsterType("Crystal Spider")
local monster = {}

monster.description = "a crystal spider"
monster.experience = 900
monster.outfit = {
	lookType = 263,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 330
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Atop of the Formorgar Glacier and deep inside Formorgar Mines, Frost Dragon Tunnel, \z
		Ice Witch Temple, Nibelor Ice Cave, the Crystal Caves in The Inquisition Quest, Mushroom Gardens."
	}

monster.health = 1250
monster.maxHealth = 1250
monster.race = "venom"
monster.corpse = 7344
monster.speed = 230
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15
}

monster.strategiesTarget = {
	nearest = 70,
	health = 20,
	random = 10,
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
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{text = "Screeech!", yell = false}
}

monster.loot = {
	{id = 2124, chance = 1560},
	{name = "crystal necklace", chance = 1640},
	{name = "gold coin", chance = 99998, maxCount = 100},
	{name = "gold coin", chance = 99998, maxCount = 92},
	{id = 2169, chance = 1480},
	{name = "platinum amulet", chance = 130},
	{name = "steel helmet", chance = 5200},
	{name = "plate armor", chance = 9993},
	{name = "knight armor", chance = 560},
	{name = "knight legs", chance = 760},
	{name = "jewelled backpack", chance = 80},
	{name = "spider silk", chance = 2010},
	{name = "shard", chance = 740},
	{name = "sniper arrow", chance = 5840, maxCount = 6},
	{name = "sapphire hammer", chance = 140},
	{name = "crystal sword", chance = 2490},
	{name = "strong mana potion", chance = 14950},
	{name = "glacier mask", chance = 670}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250, condition = {type = CONDITION_POISON, totalDamage = 160, interval = 4000}},
	{name ="speed", interval = 2000, chance = 15, speedChange = -800, range = 7, radius = 6, effect = CONST_ME_POFF, target = false, duration = 15000},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -50, maxDamage = -100, range = 7, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = true},
	{name ="speed", interval = 2000, chance = 20, speedChange = -600, range = 7, shootEffect = CONST_ANI_SNOWBALL, target = true, duration = 10000}
}

monster.defenses = {
	defense = 0,
	armor = 43,
	{name ="speed", interval = 2000, chance = 15, speedChange = 250, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -20},
	{type = COMBAT_EARTHDAMAGE, percent = 20},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 100},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
