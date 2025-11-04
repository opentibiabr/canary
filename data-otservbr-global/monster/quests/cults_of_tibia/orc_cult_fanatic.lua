local mType = Game.createMonsterType("Orc Cult Fanatic")
local monster = {}

monster.description = "an orc cult fanatic"
monster.experience = 1100
monster.outfit = {
	lookType = 59,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1506
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 1,
	Locations = "Edron Orc Cave.",
}

monster.health = 1300
monster.maxHealth = 1300
monster.race = "blood"
monster.corpse = 6001
monster.speed = 115
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
	staticAttackChance = 95,
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
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 135 }, -- Gold Coin
	{ id = 3578, chance = 30900 }, -- Fish
	{ id = 11479, chance = 19970 }, -- Orc Leather
	{ id = 3410, chance = 15110 }, -- Plate Shield
	{ id = 3725, chance = 15430, maxCount = 4 }, -- Brown Mushroom
	{ id = 11480, chance = 12050 }, -- Skull Belt
	{ id = 9639, chance = 10240 }, -- Cultish Robe
	{ id = 239, chance = 10570 }, -- Great Health Potion
	{ id = 3030, chance = 10629, maxCount = 3 }, -- Small Ruby
	{ id = 3091, chance = 8630 }, -- Sword Ring
	{ id = 3369, chance = 10700 }, -- Warrior Helmet
	{ id = 3357, chance = 5610 }, -- Plate Armor
	{ id = 3557, chance = 4480 }, -- Plate Legs
	{ id = 3372, chance = 2510 }, -- Brass Legs
	{ id = 10196, chance = 1060 }, -- Orc Tooth
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -330, range = 7, shootEffect = CONST_ANI_THROWINGKNIFE, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 22,
	mitigation = 0.99,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
