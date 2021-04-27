local mType = Game.createMonsterType("Glooth Golem")
local monster = {}

monster.description = "a glooth golem"
monster.experience = 1606
monster.outfit = {
	lookType = 600,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1038
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Glooth Factory, Underground Glooth Factory, Rathleton Sewers, Jaccus Maxxens Dungeon, \z
		Oramond Dungeon (depending on Magistrate votes)."
	}

monster.health = 2700
monster.maxHealth = 2700
monster.race = "venom"
monster.corpse = 23343
monster.speed = 260
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
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
	{text = "*slosh*", yell = false},
	{text = "*clank*", yell = false}
}

monster.loot = {
	{id = 5880, chance = 530},
	{id = 23554, chance = 720},
	{id = 23541, chance = 1720},
	{id = 23536, chance = 370},
	{id = 2148, chance = 100000, maxCount = 200},
	{id = 24124, chance = 1470},
	{id = 9690, chance = 690},
	{id = 23514, chance = 1970},
	{id = 2152, chance = 6010, maxCount = 4},
	{id = 23474, chance = 2840},
	{id = 8473, chance = 4470},
	{id = 7590, chance = 9280},
	{id = 23538, chance = 690},
	{id = 23550, chance = 440},
	{id = 23549, chance = 230},
	{id = 23551, chance = 290},
	{id = 2154, chance = 730},
	{id = 9970, chance = 1560, maxCount = 4},
	{id = 2149, chance = 1590, maxCount = 4}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 60, attack = 50},
	{name ="melee", interval = 2000, chance = 2, skill = 86, attack = 100},
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -125, maxDamage = -245, range = 7, shootEffect = CONST_ANI_ENERGY, target = false},
	{name ="war golem skill reducer", interval = 2000, chance = 16, target = false},
	{name ="war golem electrify", interval = 2000, chance = 9, range = 7, target = false}
}

monster.defenses = {
	defense = 45,
	armor = 40,
	{name ="speed", interval = 2000, chance = 13, speedChange = 404, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 5},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 15},
	{type = COMBAT_DEATHDAMAGE , percent = 30}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
