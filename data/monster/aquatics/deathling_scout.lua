local mType = Game.createMonsterType("Deathling Scout")
local monster = {}

monster.description = "a deathling scout"
monster.experience = 6300
monster.outfit = {
	lookType = 413,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1667
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Deepling Ancestorial Grounds and Sunken Temple."
	}

monster.health = 7200
monster.maxHealth = 7200
monster.race = "blood"
monster.corpse = 33373
monster.speed = 310
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
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
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
	{text = "VBOX°O", yell = false},
	{text = "O(J-\"LJ-T =|-°", yell = false}
}

monster.loot = {
	{name = "crystalline arrow", chance = 25260, maxCount = 25},
	{name = "Vortex Bolt", chance = 21340, maxCount = 25},
	{name = "Small Emerald", chance = 20910, maxCount = 12},
	{name = "Deepling Warts", chance = 20280},
	{name = "Deeptags", chance = 15100},
	{name = "Deepling Filet", chance = 14630},
	{name = "Small Enchanted Sapphire", chance = 13000, maxCount = 8},
	{name = "Deepling Ridge", chance = 11240},
	{name = "Great Mana Potion", chance = 10000},
	{name = "Great Health Potion", chance = 10000},
	{name = "Heavy Trident", chance = 6620},
	{name = "Eye of a Deepling", chance = 6070},
	{name = "Warrior's Shield", chance = 3630},
	{name = "Warrior's Axe", chance = 3470},
	{name = "Life Ring", chance = 3000},
	{name = "Fish Fin", chance = 920},
	{name = "Necklace of the Deep", chance = 440}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300, effect = CONST_ME_DRAWBLOOD},
	{name ="combat", interval = 4000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -400, range = 5, shootEffect = CONST_ANI_HUNTINGSPEAR, target = false},
	{name ="combat", interval = 4000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -150, maxDamage = -300, range = 5, shootEffect = CONST_ANI_LARGEROCK, target = false},
	{name ="combat", interval = 4000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -350, maxDamage = -550, radius = 3, effect = CONST_ME_POFF, target = false}
}

monster.defenses = {
	defense = 72,
	armor = 72
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 100},
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
