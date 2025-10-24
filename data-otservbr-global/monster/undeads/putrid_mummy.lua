local mType = Game.createMonsterType("Putrid Mummy")
local monster = {}

monster.description = "a putrid mummy"
monster.experience = 900
monster.outfit = {
	lookType = 976,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1415
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Caverna Exanima.",
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "undead"
monster.corpse = 6004
monster.speed = 85
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canPushCreatures = false,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "We will make you one of us!", yell = false },
	{ text = "Come to mummy!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 64205, maxCount = 64 }, -- Gold Coin
	{ id = 2894, chance = 8472 }, -- Broken Flask
	{ id = 3042, chance = 9305, maxCount = 3 }, -- Scarab Coin
	{ id = 25697, chance = 9848 }, -- Green Bandage
	{ id = 25702, chance = 12690 }, -- Little Bowl of Myrrh
	{ id = 25701, chance = 9801 }, -- Single Human Eye
	{ id = 3038, chance = 1823 }, -- Green Gem
	{ id = 12483, chance = 2518 }, -- Pharaoh Banner
	{ id = 3027, chance = 1015 }, -- Black Pearl
	{ id = 3299, chance = 589 }, -- Poison Dagger
	{ id = 10290, chance = 1000 }, -- Mini Mummy
	{ id = 3081, chance = 100 }, -- Stone Skin Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -100, maxDamage = -150, range = 1, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_CARNIPHILA, target = true },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -226, range = 7, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = true, duration = 10000 },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	mitigation = 0.91,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
