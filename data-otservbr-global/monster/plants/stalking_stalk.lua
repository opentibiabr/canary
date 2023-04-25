local mType = Game.createMonsterType("Stalking Stalk")
local monster = {}

monster.description = "a Stalking Stalk"
monster.experience = 11569
monster.outfit = {
	lookType = 1554,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0
}

monster.raceId = 2272
monster.Bestiary = {
	class = "Plant",
	race = BESTY_RACE_PLANT,
	toKill = 5000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 100,
	Stars = 3,
	Occurrence = 0,
	Locations = "Deep inside the Tiquanda Jungle including Tiquanda Laboratory and a small cave, \z
		Forbidden Lands, Deeper Banuta, Arena and Zoo quarter in Yalahar."
}

monster.health = 17100
monster.maxHealth = 17100
monster.race = "blood"
monster.corpse = 39307
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
	{name = "platinum coin", chance = 100000, maxCount = 13},
	{name = "Crystal Coin", chance = 100000, maxCount = 3},	
	{name = "Dragon Necklace", chance = 12430},
	{name = "naga archer scales", chance = 15640},
	{name = "Stalking Seeds", chance = 12980, maxCount = 13},
	{name = "Magma Coat", chance = 9430},
	{name = "Warrior's Axe", chance = 9530},
	{name = "Muck Rod", chance = 12590},
	{name = "Green Crystal Fragment", chance = 13830},
	{name = "Opal", chance = 9430},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 300, maxDamage = -400, effect = CONST_ME_CARNIPHILA},
	{name ="combat", interval = 2500, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 1020, maxDamage = -1090, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_HITBYFIRE, target = true},
	{name ="combat", interval = 1900, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 1020, maxDamage = -1090, range = 5, radius = 4,  shootEffect = CONST_ANI_FIRE, effect = CONST_ME_PLANTATTACK, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -800, length = 7, spread = 0, effect = CONST_ME_PINK_ENERGY_SPARK, target = false},
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