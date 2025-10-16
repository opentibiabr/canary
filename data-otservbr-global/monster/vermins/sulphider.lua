local mType = Game.createMonsterType("Sulphider")
local monster = {}

monster.description = "a sulphider"
monster.experience = 13328
monster.outfit = {
	lookType = 1546,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2264
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Monster Graveyard",
}

monster.health = 21000
monster.maxHealth = 21000
monster.race = "blood"
monster.corpse = 39275
monster.speed = 215
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
	{ text = "Tikkee...Takka...", yell = false },
}

monster.loot = {
	{ id = 39375, chance = 80000 }, -- sulphider shell
	{ id = 39376, chance = 80000 }, -- sulphur powder
	{ id = 3043, chance = 23000, maxCount = 3 }, -- crystal coin
	{ id = 23373, chance = 23000 }, -- ultimate mana potion
	{ id = 818, chance = 5000 }, -- magma boots
	{ id = 3026, chance = 5000 }, -- white pearl
	{ id = 3320, chance = 5000 }, -- fire axe
	{ id = 3419, chance = 5000 }, -- crown shield
	{ id = 7426, chance = 5000 }, -- amber staff
	{ id = 3057, chance = 1000 }, -- amulet of loss
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1000 },
	{ name = "combat", interval = 3500, chance = 40, type = COMBAT_FIREDAMAGE, minDamage = -650, maxDamage = -1060, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "blast ring", interval = 4000, chance = 35, minDamage = -600, maxDamage = -1100 },
}

monster.defenses = {
	defense = 110,
	armor = 83,
	mitigation = 2.11,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

RegisterPrimalPackBeast(monster)
