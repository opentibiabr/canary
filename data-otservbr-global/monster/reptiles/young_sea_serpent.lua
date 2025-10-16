local mType = Game.createMonsterType("Young Sea Serpent")
local monster = {}

monster.description = "a young sea serpent"
monster.experience = 1000
monster.outfit = {
	lookType = 317,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 439
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Sea Serpent Area.",
}

monster.health = 1050
monster.maxHealth = 1050
monster.race = "blood"
monster.corpse = 8965
monster.speed = 240
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	staticAttackChance = 85,
	targetDistance = 1,
	runHealth = 400,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "HISSSS", yell = true },
	{ text = "CHHHRRRR", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 174 }, -- gold coin
	{ id = 3282, chance = 80000 }, -- morning star
	{ id = 3266, chance = 23000 }, -- battle axe
	{ id = 8894, chance = 23000 }, -- heavily rusted armor
	{ id = 236, chance = 5000 }, -- strong health potion
	{ id = 9666, chance = 5000 }, -- sea serpent scale
	{ id = 3305, chance = 5000 }, -- battle hammer
	{ id = 3029, chance = 5000, maxCount = 2 }, -- small sapphire
	{ id = 237, chance = 5000 }, -- strong mana potion
	{ id = 8895, chance = 1000 }, -- rusted armor
	{ id = 3049, chance = 1000 }, -- stealth ring
	{ id = 3061, chance = 260 }, -- life crystal
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -10, maxDamage = -250, length = 7, spread = 2, effect = CONST_ME_SMALLPLANTS, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = -80, maxDamage = -250, length = 7, spread = 2, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "young sea serpent drown", interval = 2000, chance = 15, range = 5, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 20,
	mitigation = 0.78,
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 25, maxDamage = 175, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 400, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -5 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
