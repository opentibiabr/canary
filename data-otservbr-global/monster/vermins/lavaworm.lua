local mType = Game.createMonsterType("Lavaworm")
local monster = {}

monster.description = "a lavaworm"
monster.experience = 6500
monster.outfit = {
	lookType = 1394,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2088
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Grotto of the Lost.",
}

monster.health = 7500
monster.maxHealth = 7500
monster.race = "fire"
monster.corpse = 36679
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	level = 3,
	color = 205,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 18 }, -- Platinum Coin
	{ id = 9058, chance = 18544 }, -- Gold Ingot
	{ id = 16120, chance = 12556 }, -- Violet Crystal Shard
	{ id = 36769, chance = 7905 }, -- Lavaworm Spike Roots
	{ id = 3038, chance = 4916 }, -- Green Gem
	{ id = 36770, chance = 5289 }, -- Lavaworm Spikes
	{ id = 3036, chance = 8315 }, -- Violet Gem
	{ id = 3369, chance = 1558 }, -- Warrior Helmet
	{ id = 8082, chance = 3872 }, -- Underworld Rod
	{ id = 8094, chance = 1784 }, -- Wand of Voodoo
	{ id = 16119, chance = 3450 }, -- Blue Crystal Shard
	{ id = 25698, chance = 3130 }, -- Butterfly Ring
	{ id = 36771, chance = 3359 }, -- Lavaworm Jaws
	{ id = 3391, chance = 755 }, -- Crusader Helmet
	{ id = 3373, chance = 383 }, -- Strange Helmet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600 },
	{ name = "combat", interval = 2750, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -600, maxDamage = -760, range = 5, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 2000, chance = 60, type = COMBAT_FIREDAMAGE, minDamage = -700, maxDamage = -780, radius = 4, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2750, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -550, maxDamage = -700, range = 5, radius = 3, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_EXPLOSIONHIT, target = true },
}

monster.defenses = {
	defense = 60,
	armor = 60,
	mitigation = 1.60,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
