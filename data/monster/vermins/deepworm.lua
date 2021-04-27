local mType = Game.createMonsterType("Deepworm")
local monster = {}

monster.description = "a deepworm"
monster.experience = 230
monster.outfit = {
	lookType = 1033,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1531
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Gnome Deep Hub."
	}

monster.health = 4500
monster.maxHealth = 4500
monster.race = "blood"
monster.corpse = 30780
monster.speed = 204
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
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
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
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
	{text = "*bluuuuuure*", yell = false},
	{text = "*slurp slurp ... slurp*", yell = false}
}

monster.loot = {
	{name = "Deepworm Jaws", chance = 24010},
	{name = "Life Ring", chance = 7320},
	{name = "Meat", chance = 19660, maxCount = 4},
	{name = "Ham", chance = 19660, maxCount = 4},
	{name = "Wood Mushroom", chance = 22280},
	{name = "Dark Mushroom", chance = 14960},
	{name = "Green Mushroom", chance = 18520},
	{name = "Green Crystal Shard", chance = 5360},
	{id = 30828, chance = 13210, maxCount = 2},
	{name = "Deepworm Spikes", chance = 9880},
	{name = "Small Enchanted Amethyst", chance = 3430, maxCount = 2},
	{name = "Terra Amulet", chance = 5060},
	{name = "Springsprout Rod", chance = 1120},
	{name = "Sacred Tree Amulet", chance = 2390},
	{id = 7632, chance = 860},
	{name = "Suspicious Device", chance = 530}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -190, maxDamage = -300, range = 7, length = 6, spread = 2, effect = CONST_ME_POISONAREA, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -400, length = 3, spread = 3, effect = CONST_ME_POISONAREA, target = false}
}

monster.defenses = {
	defense = 5,
	armor = 10
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 30},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
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
