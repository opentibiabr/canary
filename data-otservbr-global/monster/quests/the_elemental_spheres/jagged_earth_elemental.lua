local mType = Game.createMonsterType("Jagged Earth Elemental")
local monster = {}

monster.description = "a jagged earth elemental"
monster.experience = 1300
monster.outfit = {
	lookType = 285,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "undead"
monster.corpse = 8105
monster.speed = 140
monster.manaCost = 0

monster.changeTarget = {
	interval = 20000,
	chance = 50,
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
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 1,
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
	{ text = "*STOMP STOMP*", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 83005, maxCount = 180 }, -- Gold Coin
	{ id = 10305, chance = 48117 }, -- Lump of Earth
	{ id = 940, chance = 8304 }, -- Natural Soil
	{ id = 3032, chance = 6330, maxCount = 2 }, -- Small Emerald
	{ id = 1781, chance = 23302, maxCount = 10 }, -- Small Stone
	{ id = 3130, chance = 19721 }, -- Twigs
	{ id = 647, chance = 1822 }, -- Seeds
	{ id = 10422, chance = 853 }, -- Clay Lump
	{ id = 12600, chance = 490 }, -- Coal
	{ id = 5880, chance = 521 }, -- Iron Ore
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -100, maxDamage = -250, length = 6, spread = 0, effect = CONST_ME_STONES, target = false },
	{ name = "combat", interval = 1000, chance = 11, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -200, range = 7, radius = 6, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_POISONAREA, target = true },
}

monster.defenses = {
	defense = 25,
	armor = 25,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 85 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 45 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
