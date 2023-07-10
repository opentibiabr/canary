local mType = Game.createMonsterType("Afflicted Strider")
local monster = {}

monster.description = "an afflicted strider"
monster.experience = 5700
monster.outfit = {
	lookType = 1403,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 2094
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Antrum of the Fallen"
}
	
monster.health = 10000
monster.maxHealth = 10000
monster.race = "blood"
monster.corpse = 36716
monster.speed = 135
monster.manaCost = 0

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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
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
	{text = "Knorror norror", yell = false},
}

monster.loot = {
	{name = "platinum coin", chance = 70000, maxCount = 16},
	{name = "afflicted strider worms", chance = 10940, maxCount = 3},
	{name = "guardian halberd", chance = 9410},
	{name = "crystal sword", chance = 8940},
	{name = "violet gem", chance = 6940, maxCount = 1},
	{name = "violet crystal shard", chance = 5410},
	{name = "doublet", chance = 5060},
	{name = "green crystal shard", chance = 6820},
	{name = "belted cape", chance = 3760},
	{name = "afflicted strider head", chance = 4820},
	{name = "knight armor", chance = 4590},
	{name = "spirit cloak", chance = 3060},
	{name = "magma coat", chance = 2470},
	{name = "serpent sword", chance = 2240},
	{name = "machete", chance = 3760},
	{name = "broadsword", chance = 1060},
	{name = "focus cape", chance = 2240},
	{name = "ice rapier", chance = 2240},
	{name = "titan axe", chance = 1880},
	{name = "haunted blade", chance = 1410},
	{name = "mercenary sword", chance = 1530},
	{name = "knight axe", chance = 1290}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600},
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -550, maxDamage = -650, range = 3, shootEffect = CONST_ANI_POISON, target = true},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_DEATHDAMAGE, minDamage = -650, maxDamage = -800, radius = 5, effect = CONST_ME_GROUNDSHAKER, target = false}
}

monster.defenses = {
	defense = 68,
	armor = 68,
	{name ="speed", interval = 2000, chance = 25, speedChange = 450, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 5},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 10},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 15}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
