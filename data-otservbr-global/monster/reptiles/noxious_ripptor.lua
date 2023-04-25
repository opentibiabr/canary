local mType = Game.createMonsterType("Noxious Ripptor")
local monster = {}

monster.description = "a Noxious Ripptor"
monster.experience = 13190
monster.outfit = {
	lookType = 1558,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0
}

monster.raceId = 2276
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 5000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 100,
	Stars = 3,
	Occurrence = 0,
	Locations = "Beregar, Black Knight's Villa, Chor, Ghostlands, Chyllfroest, Crystal Gardens, \z
		Crystal Grounds, Dragon Lair (Edron), Drillworm Cave, Folda, Hero Fortress, Kazordoon, \z
		Green Djinn Tower, Mushroom Fields,Paradox Tower, Plains of Havoc, Plague Spike, \z
		Poachers' Camp (Ferngrims Gate), Stonehome, Tiquanda, Truffels Garden, \z
		Vandura Mountain, Vega, Venore, Wyvern Cave (Ferngrims Gate), Wyvern Hill and Wyvern Ulderek's Rock Cave."
}

monster.health = 21500
monster.maxHealth = 21500
monster.race = "blood"
monster.corpse = 39323
monster.speed = 182
monster.manaCost = 0
monster.maxSummons = 0


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
	targetDistance = 2,
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

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "The Moon Goddess is ashamed of you!", yell = false},
}

monster.loot = {
	{id = 39546, chance = 0},
	{name = "platinum coin", chance = 50000, maxCount = 13},
	{name = "Crystal Coin", chance = 25000, maxCount = 3},
	{name = "Ripptor Claw", chance = 12500},
	{name = "Ripptor Scales", chance = 10430},
	{name = "Sacred Tree Amulet", chance = 15640},
	{name = "Ultimate Health Potion", chance = 1980, maxCount = 5},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 300, maxDamage = -801},
	{name ="combat", interval = 3000, chance = 47, type = COMBAT_PHYSICALDAMAGE, minDamage = -800, maxDamage = -1500, effect = CONST_ME_YELLOWSMOKE, target = true},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -475, range = 7, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_ENERGYAREA, target = true},
	{name ="combat", interval = 2000, chance = 31, type = COMBAT_ENERGYDAMAGE, minDamage = -800, maxDamage = -1500, radius = 4, effect = CONST_ME_YELLOWENERGY, target = true},
}

monster.defenses = {
	defense = 110,
	armor = 120,
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 20},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = -5},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = -20},
	{type = COMBAT_DEATHDAMAGE , percent = 10}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)