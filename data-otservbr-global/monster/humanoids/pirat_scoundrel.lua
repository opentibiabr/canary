local mType = Game.createMonsterType("Pirat Scoundrel")
local monster = {}

monster.description = "a pirat scoundrel"
monster.experience = 1600
monster.outfit = {
	lookType = 1346,
	lookHead = 97,
	lookBody = 119,
	lookLegs = 80,
	lookFeet = 80,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2037
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Pirat Mine, The Wreckoning",
}

monster.health = 2200
monster.maxHealth = 2200
monster.race = "blood"
monster.corpse = 35380
monster.speed = 190
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	targetDistance = 1,
	runHealth = 1,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = false,
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
	{ id = 238, chance = 10760 }, -- Great Mana Potion
	{ id = 3071, chance = 7450 }, -- Wand of Inferno
	{ id = 35572, chance = 6820, maxCount = 10 }, -- Pirate Coin
	{ id = 35588, chance = 7540 }, -- Grappling Hook
	{ id = 35573, chance = 5330 }, -- Pirat's Tail
	{ id = 8084, chance = 4000 }, -- Springsprout Rod
	{ id = 8092, chance = 4750 }, -- Wand of Starstorm
	{ id = 8094, chance = 2920 }, -- Wand of Voodoo
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -110, maxDamage = -180, range = 7, radius = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -100, maxDamage = -140, radius = 3, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -90, maxDamage = -120, radius = 3, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 60,
	mitigation = 1.74,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 26 },
	{ type = COMBAT_EARTHDAMAGE, percent = -30 },
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
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
