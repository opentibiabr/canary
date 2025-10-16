local mType = Game.createMonsterType("Sulphur Spouter")
local monster = {}

monster.description = "a sulphur spouter"
monster.experience = 11517
monster.outfit = {
	lookType = 1547,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2265
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Monster Graveyard",
}

monster.health = 19000
monster.maxHealth = 19000
monster.race = "blood"
monster.corpse = 39279
monster.speed = 180
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
	targetDistance = 2,
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
	{ text = "Gruugl...", yell = false },
}

monster.loot = {
	{ id = 39376, chance = 80000 }, -- sulphur powder
	{ id = 3043, chance = 23000, maxCount = 2 }, -- crystal coin
	{ id = 23373, chance = 23000, maxCount = 2 }, -- ultimate mana potion
	{ id = 3037, chance = 5000 }, -- yellow gem
	{ id = 36706, chance = 5000 }, -- red gem
	{ id = 3371, chance = 5000 }, -- knight legs
	{ id = 8899, chance = 5000 }, -- slightly rusted legs
	{ id = 14042, chance = 5000 }, -- warriors shield
	{ id = 3048, chance = 5000 }, -- might ring
	{ id = 3280, chance = 1000 }, -- fire sword
	{ id = 16163, chance = 1000 }, -- crystal crossbow
	{ id = 23533, chance = 1000 }, -- ring of red plasma
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -801 },
	{ name = "combat", interval = 3500, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = -800, maxDamage = -1200, range = 4, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_YELLOW_RINGS, target = true },
	{ name = "combat", interval = 4000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -800, maxDamage = -1200, radius = 4, effect = CONST_ME_YELLOWSMOKE, target = true },
	{ name = "sulphur spouter wave", interval = 4500, chance = 30, minDamage = -650, maxDamage = -900 },
}

monster.defenses = {
	defense = 110,
	armor = 84,
	mitigation = 2.05,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
