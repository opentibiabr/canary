local mType = Game.createMonsterType("Minotaur Hunter")
local monster = {}

monster.description = "a minotaur hunter"
monster.experience = 1700
monster.outfit = {
	lookType = 612,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1052
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Oramond/Southern Plains, Minotaur Hills, \z
		Oramond Dungeon (depending on Magistrate votes), Underground Glooth Factory."
	}

monster.health = 1400
monster.maxHealth = 1400
monster.race = "blood"
monster.corpse = 23466
monster.speed = 230
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 2000,
	chance = 11
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
	targetDistance = 4,
	runHealth = 300,
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
	{text = "You are marked for death!", yell = false},
	{text = "This time the prey is you!", yell = false},
	{text = "You are hunted!", yell = false},
	{text = "Bullseye!", yell = false},
	{text = "You'll make a fine trophy!", yell = false}
}

monster.loot = {
	{id = 2260, chance = 13600, maxCount = 2},
	{id = 2148, chance = 99500, maxCount = 199},
	{id = 3965, chance = 14880, maxCount = 5},
	{id = 2152, chance = 33890, maxCount = 3},
	{id = 7378, chance = 11410, maxCount = 5},
	{id = 7588, chance = 10350, maxCount = 2},
	{id = 7589, chance = 10620, maxCount = 2},
	{id = 5944, chance = 7430},
	{id = 5878, chance = 5030},
	{id = 12428, chance = 4720, maxCount = 2},
	{id = 2147, chance = 2640, maxCount = 3},
	{id = 2150, chance = 2580, maxCount = 3},
	{id = 2165, chance = 2220},
	{id = 5912, chance = 1670},
	{id = 5910, chance = 1420},
	{id = 5911, chance = 1360},
	{id = 23546, chance = 640},
	{id = 2154, chance = 470},
	{id = 2156, chance = 400},
	{id = 7401, chance = 190},
	{id = 23537, chance = 170}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 50, attack = 50},
	{name ="combat", interval = 2000, chance = 22, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -150, range = 7, shootEffect = CONST_ANI_SPEAR, effect = CONST_ME_EXPLOSIONAREA, target = false},
	-- bleed
	{name ="condition", type = CONDITION_BLEEDING, interval = 2000, chance = 40, minDamage = -300, maxDamage = -400, range = 7, radius = 3, shootEffect = CONST_ANI_THROWINGKNIFE, effect = CONST_ME_HITAREA, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -160, maxDamage = -260, range = 7, radius = 2, shootEffect = CONST_ANI_BURSTARROW, effect = CONST_ME_EXPLOSIONHIT, target = true},
	{name ="combat", interval = 2000, chance = 14, type = COMBAT_LIFEDRAIN, minDamage = -35, maxDamage = -150, radius = 4, effect = CONST_ME_EXPLOSIONAREA, target = false}
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{name ="combat", interval = 2000, chance = 7, type = COMBAT_HEALING, minDamage = 95, maxDamage = 180, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 10, speedChange = 520, effect = CONST_ME_POFF, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -5},
	{type = COMBAT_HOLYDAMAGE , percent = 10},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
