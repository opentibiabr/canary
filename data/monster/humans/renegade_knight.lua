local mType = Game.createMonsterType("Renegade Knight")
local monster = {}

monster.description = "a renegade knight"
monster.experience = 1200
monster.outfit = {
	lookType = 268,
	lookHead = 97,
	lookBody = 132,
	lookLegs = 76,
	lookFeet = 98,
	lookAddons = 2,
	lookMount = 0
}

monster.raceId = 1146
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Old Fortress (north of Edron), Old Masonry, Forbidden Temple (Carlin)."
	}

monster.health = 1450
monster.maxHealth = 1450
monster.race = "blood"
monster.corpse = 24676
monster.speed = 270
monster.manaCost = 390
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "I'll teach you a lesson!", yell = false},
	{text = "Take this!", yell = false},
	{text = "Let's see how good you are!", yell = false},
	{text = "Feel my steel!", yell = false},
	{text = "A challenge at last!", yell = false}
}

monster.loot = {
	{id = 2544, chance = 90450, maxCount = 10},
	{id = 2148, chance = 75410, maxCount = 30},
	{id = 2681, chance = 1210},
	{id = 7591, chance = 1210},
	{id = 2666, chance = 1210, maxCount = 2},
	{id = 7364, chance = 1210, maxCount = 4},
	{id = 2487, chance = 210},
	{id = 2491, chance = 310},
	{id = 2519, chance = 210},
	{id = 2488, chance = 110},
	{id = 2392, chance = 310},
	{id = 2381, chance = 1610},
	{id = 2744, chance = 510},
	{id = 2120, chance = 1510},
	{id = 1949, chance = 910},
	{id = 12466, chance = 910},
	{id = 12406, chance = 910},
	{id = 2121, chance = 510}
}

monster.attacks = {
	{name ="renegade knight", interval = 2000, chance = 30, target = false},
	{name ="melee", interval = 2000, chance = 100, minDamage = 10, maxDamage = -175}
}

monster.defenses = {
	defense = 50,
	armor = 35,
	{name ="combat", interval = 4000, chance = 25, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 10},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 10},
	{type = COMBAT_DEATHDAMAGE , percent = -10}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
