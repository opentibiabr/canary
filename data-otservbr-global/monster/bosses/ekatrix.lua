local mType = Game.createMonsterType("Ekatrix")
local monster = {}

monster.description = "Ekatrix"
monster.experience = 200
monster.outfit = {
	lookType = 54,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 500
monster.maxHealth = 500
monster.race = "blood"
monster.corpse = 18254
monster.speed = 51
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1140,
	bossRace = RARITY_ARCHFOE,
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
	rewardBoss = true,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 30,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
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
	{ id = 3031, chance = 80000, maxCount = 60 }, -- gold coin
	{ id = 3454, chance = 80000 }, -- broom
	{ id = 9652, chance = 80000 }, -- witch broom
	{ id = 3598, chance = 80000, maxCount = 10 }, -- cookie
	{ id = 3565, chance = 80000 }, -- cape
	{ id = 5940, chance = 80000 }, -- wolf tooth chain
	{ id = 3562, chance = 80000 }, -- coat
	{ id = 3736, chance = 80000 }, -- star herb
	{ id = 3069, chance = 80000 }, -- necrotic rod
	{ id = 12548, chance = 80000 }, -- bag of apple slices
	{ id = 3083, chance = 80000 }, -- garlic necklace
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -20 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -30, maxDamage = -60, range = 5, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "firefield", interval = 2000, chance = 10, range = 5, radius = 1, shootEffect = CONST_ANI_FIRE, target = true },
}

monster.defenses = {
	defense = 10,
	armor = 10,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
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
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
