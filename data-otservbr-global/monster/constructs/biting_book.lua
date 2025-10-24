local mType = Game.createMonsterType("Biting Book")
local monster = {}

monster.description = "a biting book"
monster.experience = 9350
monster.outfit = {
	lookType = 1066,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1656
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Secret Library earth, energy, fire and ice sections. Also two incarcerated in the Issavi prison, reachable from the city Library.",
}

monster.health = 6500
monster.maxHealth = 6500
monster.race = "ink"
monster.corpse = 28609
monster.speed = 240
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	staticAttackChance = 90,
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
	{ id = 3035, chance = 75166, maxCount = 46 }, -- Platinum Coin
	{ id = 28569, chance = 61934, maxCount = 6 }, -- Book Page
	{ id = 28570, chance = 41252, maxCount = 9 }, -- Glowing Rune
	{ id = 28566, chance = 28863 }, -- Silken Bookmark
	{ id = 3116, chance = 7876, maxCount = 2 }, -- Big Bone
	{ id = 3577, chance = 3845, maxCount = 5 }, -- Meat
	{ id = 3016, chance = 1764 }, -- Ruby Necklace
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1055 },
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1210, radius = 5, effect = CONST_ME_SMOKE, target = false },
	{ name = "combat", interval = 1000, chance = 14, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1210, radius = 3, effect = CONST_ME_BATS, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 76,
	mitigation = 1.88,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
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
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
