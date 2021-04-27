local mType = Game.createMonsterType("Hive Overseer")
local monster = {}

monster.description = "a hive overseer"
monster.experience = 5500
monster.outfit = {
	lookType = 458,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 801
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 2,
	Locations = "The Hive towers: on the highest floor of each tower, \z
		and in many of the closed rooms accessed with pheromones; \z
		many in the large underground room of the west tower. \z
		Liberty Bay Hive Outpost: one spawn on the second floor underground."
	}

monster.health = 7500
monster.maxHealth = 7500
monster.race = "venom"
monster.corpse = 15354
monster.speed = 230
monster.manaCost = 0
monster.maxSummons = 2

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
	pushable = true,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 95,
	targetDistance = 4,
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

monster.summons = {
	{name = "Spidris Elite", chance = 40, interval = 2000, max = 2}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Zopp!", yell = false},
	{text = "Kropp!", yell = false}
}

monster.loot = {
	{name = "small ruby", chance = 16000, maxCount = 2},
	{name = "gold coin", chance = 40000, maxCount = 100},
	{name = "gold coin", chance = 58000, maxCount = 98},
	{name = "platinum coin", chance = 84000, maxCount = 6},
	{name = "steel boots", chance = 550},
	{name = "great mana potion", chance = 18000},
	{id = 7632, chance = 6000},
	{name = "ultimate health potion", chance = 12000},
	{name = "gold ingot", chance = 29000},
	{name = "kollos shell", chance = 28000},
	{name = "compound eye", chance = 16000},
	{name = "calopteryx cape", chance = 830},
	{name = "carapace shield", chance = 920},
	{name = "hive scythe", chance = 1650},
	{name = "gooey mass", chance = 13000, maxCount = 2},
	{name = "hive bow", chance = 830}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -60, maxDamage = -80, radius = 4, effect = CONST_ME_POISONAREA, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 20, minDamage = -600, maxDamage = -1000, radius = 4, effect = CONST_ME_GREEN_RINGS, target = false}
}

monster.defenses = {
	defense = 45,
	armor = 45,
	{name ="combat", interval = 2000, chance = 50, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 500, maxDamage = 700, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 60},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 70},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 10},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
