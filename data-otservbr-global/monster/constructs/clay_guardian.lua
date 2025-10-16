local mType = Game.createMonsterType("Clay Guardian")
local monster = {}

monster.description = "a clay guardian"
monster.experience = 400
monster.outfit = {
	lookType = 333,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 706
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Horestis Tomb, Middle Spike, Medusa Tower.",
}

monster.health = 625
monster.maxHealth = 625
monster.race = "undead"
monster.corpse = 12837
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
	staticAttackChance = 60,
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
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 164 }, -- gold coin
	{ id = 3147, chance = 80000 }, -- blank rune
	{ id = 10305, chance = 80000 }, -- lump of earth
	{ id = 1781, chance = 23000, maxCount = 10 }, -- small stone
	{ id = 774, chance = 5000, maxCount = 8 }, -- earth arrow
	{ id = 10422, chance = 1000 }, -- clay lump
	{ id = 9057, chance = 1000 }, -- small topaz
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -125 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -30, maxDamage = -150, range = 7, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_EARTHDAMAGE, minDamage = -20, maxDamage = -30, radius = 3, effect = CONST_ME_POFF, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 42,
	mitigation = 0.70,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 40, maxDamage = 130, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 25 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
