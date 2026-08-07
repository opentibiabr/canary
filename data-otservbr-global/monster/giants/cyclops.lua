local mType = Game.createMonsterType("Cyclops")
local monster = {}

monster.description = "a cyclops"
monster.experience = 150
monster.outfit = {
	lookType = 22,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 22
monster.Bestiary = {
	class = "Giant",
	race = BESTY_RACE_GIANT,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Plains of Havoc, Mount Sternum, Femor Hills, Cyclops Camp, Cyclopolis, Ancient Temple, Shadowthorn, \z
	Orc Fort, Mistrock, Foreigner Quarter, Outlaw Camp and in the Cyclops version of the Forsaken Mine. ",
}

monster.health = 260
monster.maxHealth = 260
monster.race = "blood"
monster.corpse = 5962
monster.speed = 95
monster.manaCost = 490

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
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
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Human, uh whil dyh!", yell = false },
	{ text = "Youh ah trak!", yell = false },
	{ text = "Let da mashing begin!", yell = false },
	{ text = "Toks utat.", yell = false },
	{ text = "Il lorstok human!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 82000, maxCount = 47 }, -- Gold Coin
	{ id = 3577, chance = 30000 }, -- Meat
	{ id = 3294, chance = 8000 }, -- Short Sword
	{ id = 9657, chance = 4900 }, -- Cyclops Toe
	{ id = 3410, chance = 2600 }, -- Plate Shield
	{ id = 23986, chance = 2100 }, -- Heavy Old Tome
	{ id = 3413, chance = 1600 }, -- Battle Shield
	{ id = 3269, chance = 990 }, -- Halberd
	{ id = 3384, chance = 230 }, -- Dark Helmet
	{ id = 3012, chance = 220 }, -- Wolf Tooth Chain
	{ id = 24415, chance = 180 }, -- Old Rag
	{ id = 266, chance = 150 }, -- Health Potion
	{ id = 7398, chance = 72 }, -- Cyclops Trophy
	{ id = 3093, chance = 40 }, -- Club Ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -105 },
}

monster.defenses = {
	defense = 20,
	armor = 17,
	mitigation = 0.62,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
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
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
