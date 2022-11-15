local mType = Game.createMonsterType("Poisonous Carnisylvan")
local monster = {}

monster.description = "a poisonous carnisylvan"
monster.experience = 4400
monster.outfit = {
	lookType = 1418,
	lookHead = 23,
	lookBody = 98,
	lookLegs = 22,
	lookFeet = 61,
	lookAddons = 1,
	lookMount = 0
}

monster.raceId = 2108
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Forest of Life"
}

monster.health = 8000
monster.maxHealth = 8000
monster.race = "blood"
monster.corpse = 36890
monster.speed = 105
monster.manaCost = 0

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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.summon = {
	maxSummons = 1,
	summons = {
		{name = "Carnisylvan Sapling", chance = 70, interval = 2000, count =1}
	}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "OH NO, YOU WON'T!", yell = false}
}

monster.loot = {
	{name = "platinum coin", chance = 70000, maxCount = 17},
	{name = "carnisylvan bark", chance = 12040, maxCount = 2},
	{name = "mushroom pie", chance = 8640, maxCount = 1},
	{name = "carnisylvan finger", chance = 8640, maxCount = 4},
	{name = "emerald bangle", chance = 4970},
	{name = "great spirit potion", chance = 6810, maxCount = 5},
	{name = "guardian halberd", chance = 4970},
	{id = 23542, chance = 4970}, -- collar of blue plasma
	{name = "terra rod", chance = 7330},
	{name = "underworld rod", chance = 6280},
	{name = "diamond sceptre", chance = 4710},
	{name = "fire mushroom", chance = 3140},
	{name = "knight axe", chance = 5760},
	{name = "wand of starstorm", chance = 4710},
	{name = "sacred tree amulet", chance = 2880},
	{id = 281, chance = 2090}, -- giant shimmering pearl (green)
	{name = "gemmed figurine", chance = 790},
	{name = "human teeth", chance = 520}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -480},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_EARTHDAMAGE, minDamage = -350, maxDamage = -520, radius = 4, range = 5, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_POISONAREA, target = true},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -350, maxDamage = -450, range = 5, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_POISONAREA, target = true},
}

monster.defenses = {
	defense = 37,
	armor = 37,
	{name ="speed", interval = 2000, chance = 8, speedChange = 250, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 25},
	{type = COMBAT_FIREDAMAGE, percent = -15},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -5},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 5}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
