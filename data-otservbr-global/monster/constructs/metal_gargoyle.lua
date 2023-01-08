local mType = Game.createMonsterType("Metal Gargoyle")
local monster = {}

monster.description = "a metal gargoyle"
monster.experience = 1278
monster.outfit = {
	lookType = 601,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1039
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Workshop Quarter, Glooth Factory, Underground Glooth Factory, Abandoned Sewers, \z
		Oramond Dungeon (depending on Magistrate votes), Jaccus Maxxens Dungeon."
	}

monster.health = 2100
monster.maxHealth = 2100
monster.race = "venom"
monster.corpse = 20976
monster.speed = 95
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{text = "*stomp*", yell = false},
	{text = "clonk", yell = false}
}

monster.loot = {
	{id = 3031, chance = 100000, maxCount = 200}, -- gold coin
	{id = 21755, chance = 1490}, -- bronze gear wheel
	{id = 21193, chance = 17160}, -- metal jaw
	{id = 3035, chance = 43280, maxCount = 2}, -- platinum coin
	{id = 236, chance = 9700, maxCount = 2}, -- strong health potion
	{id = 237, chance = 9700, maxCount = 2}, -- strong mana potion
	{id = 21171, chance = 1490}, -- metal bat
	{id = 8082, chance = 1490}, -- underworld rod
	{id = 3051, chance = 2240}, -- energy ring
	{id = 3052, chance = 750}, -- life ring
	{id = 10310, chance = 2240}, -- shiny stone
	{id = 21169, chance = 1490}, -- metal spats
	{id = 21168, chance = 1490}, -- alloy legs
	{id = 8896, chance = 2990} -- slightly rusted armor
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 84, attack = 50},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -125, maxDamage = -230, length = 8, spread = 3, effect = CONST_ME_YELLOWENERGY, target = false},
	{name ="combat", interval = 2000, chance = 9, type = COMBAT_LIFEDRAIN, minDamage = -85, maxDamage = -150, range = 7, radius = 3, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true},
	{name ="metal gargoyle curse", interval = 2000, chance = 13, target = false}
}

monster.defenses = {
	defense = 42,
	armor = 21
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 15},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -5},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 80}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
