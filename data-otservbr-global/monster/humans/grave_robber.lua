local mType = Game.createMonsterType("Grave Robber")
local monster = {}

monster.description = "a grave robber"
monster.experience = 65
monster.outfit = {
	lookType = 146,
	lookHead = 57,
	lookBody = 95,
	lookLegs = 57,
	lookFeet = 19,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 867
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 2,
	Locations = "Horestis Tomb.",
}

monster.health = 165
monster.maxHealth = 165
monster.race = "blood"
monster.corpse = 18130
monster.speed = 95
monster.manaCost = 435

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
	convinceable = true,
	pushable = true,
	rewardBoss = false,
	illusionable = false,
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
}

monster.loot = {
	{ id = 3031, chance = 55440, maxCount = 38 }, -- Gold Coin
	{ id = 11492, chance = 6110 }, -- Rope Belt
	{ id = 8010, chance = 5230, maxCount = 3 }, -- Potato
	{ id = 3274, chance = 3150 }, -- Axe
	{ id = 3359, chance = 1850 }, -- Brass Armor
	{ id = 11456, chance = 1720 }, -- Dirty Turban
	{ id = 3286, chance = 1400 }, -- Mace
	{ id = 3353, chance = 650 }, -- Iron Helmet
	{ id = 3409, chance = 880 }, -- Steel Shield
	{ id = 7533, chance = 360 }, -- Nomad Parchment
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -90 },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 15, minDamage = -100, maxDamage = -160, range = 7, radius = 1, shootEffect = CONST_ANI_POISON, target = true },
}

monster.defenses = {
	defense = 15,
	armor = 7,
	mitigation = 0.38,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
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
