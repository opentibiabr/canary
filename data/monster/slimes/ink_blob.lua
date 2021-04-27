local mType = Game.createMonsterType("Ink Blob")
local monster = {}

monster.description = "an ink blob"
monster.experience = 14450
monster.outfit = {
	lookType = 1064,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1658
monster.Bestiary = {
	class = "Slime",
	race = BESTY_RACE_SLIME,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Secret Library."
	}

monster.health = 9500
monster.maxHealth = 9500
monster.race = "undead"
monster.corpse = 33345
monster.speed = 380
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
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
	canPushCreatures = false,
	staticAttackChance = 85,
	targetDistance = 1,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{name = "Platinum Coin", chance = 120000, maxCount = 4},
	{name = "Envenomed Arrow", chance = 1200, maxCount = 14},
	{id = 33315, chance = 1200, maxCount = 4},
	{name = "Poisonous Slime", chance = 1200, maxCount = 4},
	{name = "Small Diamond", chance = 1200, maxCount = 4},
	{name = "Small Topaz", chance = 1200, maxCount = 4},
	{id = 7633, chance = 900, maxCount = 4},
	{name = "Blue Gem", chance = 950, maxCount = 4},
	{name = "Terra Boots", chance = 850, maxCount = 4},
	{name = "Terra Hood", chance = 980, maxCount = 4},
	{name = "Protection Amulet", chance = 1200, maxCount = 4},
	{name = "Sacred Tree Amulet", chance = 1200, maxCount = 4},
	{name = "Springsprout Rod", chance = 790, maxCount = 4},
	{name = "Stone Skin Amulet", chance = 1200, maxCount = 4},
	{name = "Terra Legs", chance = 650, maxCount = 4},
	{name = "Terra Mantle", chance = 550, maxCount = 4},
	{name = "Clay Lump", chance = 1200, maxCount = 4},
	{name = "Terra Amulet", chance = 1200, maxCount = 4}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 45, attack = 40, condition = {type = CONDITION_POISON, totalDamage = 280, interval = 4000}},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 13, minDamage = -400, maxDamage = -580, radius = 4, effect = CONST_ME_POISONAREA, target = false},
	{name ="combat", interval = 2000, chance = 11, type = COMBAT_EARTHDAMAGE, minDamage = -285, maxDamage = -480, radius = 3, shootEffect = CONST_ANI_ENVENOMEDARROW, effect = CONST_ME_GREEN_RINGS, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -260, maxDamage = -505, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true}
}

monster.defenses = {
	defense = 15,
	armor = 15,
	{name ="combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 20, maxDamage = 30, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 30},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
