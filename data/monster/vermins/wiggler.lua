local mType = Game.createMonsterType("Wiggler")
local monster = {}

monster.description = "a wiggler"
monster.experience = 900
monster.outfit = {
	lookType = 510,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 899
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Can be found in Truffels Garden as well as the Mushroom Gardens."
	}

monster.health = 1200
monster.maxHealth = 1200
monster.race = "venom"
monster.corpse = 18483
monster.speed = 360
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 359,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
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
	{text = "Zzzrp", yell = false},
	{text = "Crick! Crick!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 100000, maxCount = 100},
	{name = "platinum coin", chance = 14790},
	{name = "terra rod", chance = 850},
	{name = "serpent sword", chance = 1360},
	{name = "black shield", chance = 1320},
	{name = "white mushroom", chance = 7142, maxCount = 5},
	{name = "blue piece of cloth", chance = 2080},
	{name = "yellow piece of cloth", chance = 2160},
	{name = "strong health potion", chance = 4930},
	{name = "strong mana potion", chance = 5250},
	{name = "crystalline arrow", chance = 15540, maxCount = 5},
	{name = "green crystal splinter", chance = 3600},
	{name = "green crystal fragment", chance = 2070},
	{name = "drill bolt", chance = 15260, maxCount = 5}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200, condition = {type = CONDITION_POISON, totalDamage = 500, interval = 4000}},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -180, maxDamage = -270, length = 4, spread = 3, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -160, maxDamage = -200, range = 7, shootEffect = CONST_ANI_POISONARROW, effect = CONST_ME_SMALLPLANTS, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = -700, length = 3, spread = 2, effect = CONST_ME_HITAREA, target = false, duration = 30000}
}

monster.defenses = {
	defense = 15,
	armor = 15,
	{name ="speed", interval = 2000, chance = 15, speedChange = 510, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 5},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -5},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
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
