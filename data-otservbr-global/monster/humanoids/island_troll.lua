local mType = Game.createMonsterType("Island Troll")
local monster = {}

monster.description = "an island troll"
monster.experience = 20
monster.outfit = {
	lookType = 282,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 277
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 250,
	FirstUnlock = 10,
	SecondUnlock = 100,
	CharmsPoints = 5,
	Stars = 1,
	Occurrence = 0,
	Locations = "Goroma.",
}

monster.health = 50
monster.maxHealth = 50
monster.race = "blood"
monster.corpse = 865
monster.speed = 63
monster.manaCost = 290

monster.changeTarget = {
	interval = 5000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 15,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Hmmm, turtles", yell = false },
	{ text = "Hmmm, dogs", yell = false },
	{ text = "Hmmm, worms", yell = false },
	{ text = "Groar", yell = false },
	{ text = "Gruntz!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 59920, maxCount = 10 }, -- Gold Coin
	{ id = 5901, chance = 29986 }, -- Wood
	{ id = 3268, chance = 17767 }, -- Hand Axe
	{ id = 3552, chance = 10066 }, -- Leather Boots
	{ id = 3355, chance = 9973 }, -- Leather Helmet
	{ id = 3003, chance = 7773 }, -- Rope
	{ id = 3277, chance = 20156 }, -- Spear
	{ id = 3412, chance = 15144 }, -- Wooden Shield
	{ id = 5096, chance = 5291 }, -- Mango
	{ id = 3336, chance = 5380 }, -- Studded Club
	{ id = 901, chance = 137 }, -- Marlin
	{ id = 3054, chance = 75 }, -- Silver Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -10 },
}

monster.defenses = {
	defense = 10,
	armor = 6,
	mitigation = 0.20,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
