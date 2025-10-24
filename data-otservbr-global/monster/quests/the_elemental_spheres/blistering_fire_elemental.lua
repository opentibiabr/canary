local mType = Game.createMonsterType("Blistering Fire Elemental")
local monster = {}

monster.description = "a blistering fire elemental"
monster.experience = 1300
monster.outfit = {
	lookType = 242,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "fire"
monster.corpse = 8136
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.strategiesTarget = {
	nearest = 80,
	random = 20,
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
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "FCHHHRRR", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 87459, maxCount = 170 }, -- Gold Coin
	{ id = 3030, chance = 5187, maxCount = 3 }, -- Small Ruby
	{ id = 9636, chance = 10769 }, -- Fiery Heart
	{ id = 941, chance = 8053 }, -- Glimmering Soil
	{ id = 8093, chance = 409 }, -- Wand of Draconia
	{ id = 12600, chance = 310 }, -- Coal
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350 },
	{ name = "combat", interval = 1000, chance = 11, type = COMBAT_FIREDAMAGE, minDamage = -65, maxDamage = -510, length = 7, spread = 0, effect = CONST_ME_FIREAREA, target = false },
	-- fire
	{ name = "condition", type = CONDITION_FIRE, interval = 1000, chance = 12, minDamage = -50, maxDamage = -200, radius = 6, effect = CONST_ME_FIREAREA, target = false },
	{ name = "firefield", interval = 1000, chance = 15, range = 7, radius = 3, shootEffect = CONST_ANI_FIRE, target = true },
}

monster.defenses = {
	defense = 20,
	armor = 20,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 25 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
