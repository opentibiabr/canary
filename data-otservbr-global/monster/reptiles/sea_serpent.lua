local mType = Game.createMonsterType("Sea Serpent")
local monster = {}

monster.description = "a sea serpent"
monster.experience = 2300
monster.outfit = {
	lookType = 275,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 438
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Sea Serpent Area and Seacrest Grounds.",
}

monster.health = 1950
monster.maxHealth = 1950
monster.race = "blood"
monster.corpse = 949
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
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
	{ text = "CHHHRRRR", yell = true },
	{ text = "HISSSS", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 236 }, -- gold coin
	{ id = 3583, chance = 80000, maxCount = 2 }, -- dragon ham
	{ id = 3035, chance = 80000, maxCount = 3 }, -- platinum coin
	{ id = 9666, chance = 23000 }, -- sea serpent scale
	{ id = 3557, chance = 23000 }, -- plate legs
	{ id = 3029, chance = 23000, maxCount = 3 }, -- small sapphire
	{ id = 236, chance = 5000 }, -- strong health potion
	{ id = 3297, chance = 5000 }, -- serpent sword
	{ id = 237, chance = 5000 }, -- strong mana potion
	{ id = 8042, chance = 5000 }, -- spirit cloak
	{ id = 3098, chance = 5000 }, -- ring of healing
	{ id = 8083, chance = 1000 }, -- northwind rod
	{ id = 238, chance = 1000 }, -- great mana potion
	{ id = 815, chance = 1000 }, -- glacier amulet
	{ id = 823, chance = 260 }, -- glacier kilt
	{ id = 3049, chance = 260 }, -- stealth ring
	{ id = 8043, chance = 260 }, -- focus cape
	{ id = 9303, chance = 260 }, -- leviathans amulet
	{ id = 8050, chance = 260 }, -- crystalline armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -60, maxDamage = -300, length = 7, spread = 2, effect = CONST_ME_SMALLPLANTS, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -101, maxDamage = -300, length = 7, spread = 2, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "sea serpent drown", interval = 2000, chance = 15, range = 5, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 25,
	mitigation = 1.04,
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 70, maxDamage = 273, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 400, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
