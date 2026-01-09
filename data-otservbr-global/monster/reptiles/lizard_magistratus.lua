local mType = Game.createMonsterType("Lizard Magistratus")
local monster = {}

monster.description = "a lizard magistratus"
monster.experience = 2000
monster.outfit = {
	lookType = 115,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"LizardMagistratusDeath",
}

monster.raceId = 655
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Razzachai.",
}

monster.health = 6250
monster.maxHealth = 6250
monster.race = "blood"
monster.corpse = 6041
monster.speed = 128
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Shhhhhhhh.", yell = false },
	{ text = "I can't work wizh zuch dizturbancez!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 78460, maxCount = 50 }, -- Gold Coin
	{ id = 3035, chance = 15610, maxCount = 20 }, -- Platinum Coin
	{ id = 3030, chance = 9210, maxCount = 5 }, -- Small Ruby
	{ id = 237, chance = 7610 }, -- Strong Mana Potion
	{ id = 238, chance = 5280 }, -- Great Mana Potion
	{ id = 5876, chance = 1280 }, -- Lizard Leather
	{ id = 5881, chance = 640 }, -- Lizard Scale
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -60 },
	{ name = "lizard magistratus curse", interval = 2000, chance = 10, range = 5, target = false },
}

monster.defenses = {
	defense = 15,
	armor = 25,
	mitigation = 1.18,
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 85 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
