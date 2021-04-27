local mType = Game.createMonsterType("Glooth Brigand")
local monster = {}

monster.description = "a glooth brigand"
monster.experience = 1900
monster.outfit = {
	lookType = 137,
	lookHead = 114,
	lookBody = 114,
	lookLegs = 109,
	lookFeet = 114,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1120
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Underground Glooth Factory."
	}

monster.health = 2400
monster.maxHealth = 2400
monster.race = "blood"
monster.corpse = 24257
monster.speed = 320
monster.manaCost = 450
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 5
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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
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
}

monster.loot = {
	{id = 2148, chance = 100000, maxCount = 100},
	{id = 2152, chance = 100000, maxCount = 3},
	{id = 23574, chance = 9090},
	{id = 24185, chance = 7692},
	{id = 7590, chance = 5882},
	{id = 23514, chance = 4000},
	{id = 24183, chance = 3030},
	{id = 8472, chance = 2500},
	{id = 23517, chance = 2000},
	{id = 8473, chance = 2000},
	{id = 23549, chance = 1515},
	{id = 23554, chance = 1515},
	{id = 7386, chance = 1000},
	{id = 7884, chance = 1000},
	{id = 7632, chance = 1000},
	{id = 7887, chance = 1000},
	{id = 7412, chance = 1000},
	{id = 2155, chance = 1000},
	{id = 7886, chance = 502},
	{id = 7419, chance = 502},
	{id = 23538, chance = 502},
	{id = 23529, chance = 502},
	{id = 23536, chance = 502},
	{id = 7903, chance = 502}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 80, attack = 68},
	{name ="combat", interval = 2000, chance = 50, type = COMBAT_PHYSICALDAMAGE, minDamage = -40, maxDamage = -200, range = 8, shootEffect = CONST_ANI_ARROW, target = false}
}

monster.defenses = {
	defense = 26,
	armor = 26,
	{name ="combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 200, maxDamage = 245, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 25},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = -5},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
