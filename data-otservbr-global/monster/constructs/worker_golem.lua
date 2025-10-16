local mType = Game.createMonsterType("Worker Golem")
local monster = {}

monster.description = "a worker golem"
monster.experience = 1250
monster.outfit = {
	lookType = 304,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 503
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Factory Quarter.",
}

monster.health = 1470
monster.maxHealth = 1470
monster.race = "venom"
monster.corpse = 8887
monster.speed = 80
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
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
	isPreyExclusive = true,
}

monster.light = {
	level = 3,
	color = 35,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "INTRUDER ALARM!", yell = true },
	{ text = "klonk klonk klonk", yell = false },
	{ text = "Rrrtttarrrttarrrtta", yell = false },
	{ text = "Awaiting orders.", yell = false },
	{ text = "Secret objective complete.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 140 }, -- gold coin
	{ id = 238, chance = 5000 }, -- great mana potion
	{ id = 239, chance = 5000 }, -- great health potion
	{ id = 953, chance = 5000, maxCount = 5 }, -- nail
	{ id = 8895, chance = 5000 }, -- rusted armor
	{ id = 9655, chance = 5000 }, -- gear crystal
	{ id = 3028, chance = 1000, maxCount = 2 }, -- small diamond
	{ id = 3048, chance = 1000 }, -- might ring
	{ id = 3061, chance = 1000 }, -- life crystal
	{ id = 3279, chance = 1000 }, -- war hammer
	{ id = 5880, chance = 1000 }, -- iron ore
	{ id = 7439, chance = 1000 }, -- berserk potion
	{ id = 7452, chance = 1000 }, -- spiked squelcher
	{ id = 7642, chance = 1000 }, -- great spirit potion
	{ id = 8775, chance = 1000 }, -- gear wheel
	{ id = 8898, chance = 1000 }, -- rusted legs
	{ id = 7428, chance = 260 }, -- bonebreaker
	{ id = 9066, chance = 260 }, -- crystal pedestal
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -240 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -125, range = 7, shootEffect = CONST_ANI_SMALLSTONE, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 35,
	mitigation = 1.32,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
