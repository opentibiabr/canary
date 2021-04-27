local mType = Game.createMonsterType("Vile Grandmaster")
local monster = {}

monster.description = "a vile grandmaster"
monster.experience = 1500
monster.outfit = {
	lookType = 268,
	lookHead = 97,
	lookBody = 0,
	lookLegs = 95,
	lookFeet = 94,
	lookAddons = 1,
	lookMount = 0
}

monster.raceId = 1147
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

monster.health = 1700
monster.maxHealth = 1700
monster.race = "blood"
monster.corpse = 24679
monster.speed = 280
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
	{text = "I will end this now!", yell = false},
	{text = "I've seen orcs tougher than you!", yell = false},
	{text = "Your gods won't help you!", yell = false},
	{text = "Is that the best, you can throw at me?", yell = false},
	{text = "You'll make a fine trophy!", yell = false}
}

monster.loot = {
	{id = 7364, chance = 1210, maxCount = 4},
	{id = 2148, chance = 75410, maxCount = 30},
	{id = 2152, chance = 75410, maxCount = 2},
	{id = 2681, chance = 1210},
	{id = 2666, chance = 1210, maxCount = 2},
	{id = 7591, chance = 1210},
	{id = 2381, chance = 1610},
	{id = 2744, chance = 510},
	{id = 2120, chance = 1510},
	{id = 12466, chance = 910},
	{id = 12406, chance = 910},
	{id = 2147, chance = 810, maxCount = 2},
	{id = 2146, chance = 810, maxCount = 2},
	{id = 2121, chance = 510},
	{id = 5911, chance = 210},
	{id = 2391, chance = 210},
	{id = 2487, chance = 310},
	{id = 2392, chance = 210},
	{id = 2491, chance = 310},
	{id = 2519, chance = 210},
	{id = 2488, chance = 110},
	{id = 2171, chance = 210}
}

monster.attacks = {
	{name ="vile grandmaster", interval = 2000, chance = 15, target = false},
	{name ="melee", interval = 2000, chance = 100, minDamage = 10, maxDamage = -260},
	-- bleed
	{name ="condition", type = CONDITION_BLEEDING, interval = 2000, chance = 20, minDamage = -150, maxDamage = -225, radius = 4, shootEffect = CONST_ANI_THROWINGKNIFE, target = true}
}

monster.defenses = {
	defense = 50,
	armor = 35,
	{name ="combat", interval = 4000, chance = 15, type = COMBAT_HEALING, minDamage = 220, maxDamage = 280, effect = CONST_ME_MAGIC_BLUE, target = false}
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
