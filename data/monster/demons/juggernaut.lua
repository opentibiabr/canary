local mType = Game.createMonsterType("Juggernaut")
local monster = {}

monster.description = "a juggernaut"
monster.experience = 11200
monster.outfit = {
	lookType = 244,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 296
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Deep in Pits of Inferno (Apocalypse's throne room), The Dark Path, \z
		The Blood Halls, The Vats, The Hive, The Shadow Nexus, a room deep in Formorgar Mines, Roshamuul Prison, Oramond Dungeon, Grounds of Destruction."
	}

monster.health = 20000
monster.maxHealth = 20000
monster.race = "blood"
monster.corpse = 6336
monster.speed = 340
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 60,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{text = "RAAARRR!", yell = false},
	{text = "GRRRRRR!", yell = false},
	{text = "WAHHHH!", yell = false}
}

monster.loot = {
	{id = 2136, chance = 550},
	{name = "small ruby", chance = 20000, maxCount = 4},
	{name = "gold coin", chance = 100000, maxCount = 100},
	{name = "gold coin", chance = 100000, maxCount = 100},
	{name = "gold coin", chance = 100000, maxCount = 100},
	{name = "gold coin", chance = 100000, maxCount = 100},
	{name = "small emerald", chance = 20000, maxCount = 5},
	{name = "platinum coin", chance = 100000, maxCount = 15},
	{name = "violet gem", chance = 830},
	{name = "green gem", chance = 869},
	{name = "red gem", chance = 13850},
	{name = "dragon hammer", chance = 9000},
	{name = "heavy mace", chance = 400},
	{name = "war axe", chance = 400},
	{name = "golden armor", chance = 550},
	{name = "golden legs", chance = 500},
	{name = "knight armor", chance = 4990},
	{name = "mastermind shield", chance = 800},
	{id = 2578, chance = 280},
	{name = "ham", chance = 60000, maxCount = 8},
	{name = "soul orb", chance = 33333},
	{name = "demonic essence", chance = 45333},
	{name = "concentrated demonic blood", chance = 25000, maxCount = 4},
	{name = "onyx arrow", chance = 11111, maxCount = 15},
	{name = "assassin star", chance = 25000, maxCount = 10},
	{name = "titan axe", chance = 4430},
	{name = "spiked squelcher", chance = 7761},
	{name = "great mana potion", chance = 35000},
	{name = "great health potion", chance = 32000},
	{name = "skullcracker armor", chance = 400},
	{name = "gold ingot", chance = 7692, maxCount = 2}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1470},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -780, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = false}
}

monster.defenses = {
	defense = 60,
	armor = 60,
	{name ="speed", interval = 2000, chance = 15, speedChange = 520, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 400, maxDamage = 900, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 40},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 20},
	{type = COMBAT_FIREDAMAGE, percent = 30},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = -5},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
