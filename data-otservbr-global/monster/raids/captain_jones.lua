local mType = Game.createMonsterType("Captain Jones")
local monster = {}

monster.description = "Captain Jones"
monster.experience = 620
monster.outfit = {
	lookType = 196,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 430,
	bossRace = RARITY_NEMESIS,
}

monster.health = 555
monster.maxHealth = 555
monster.race = "undead"
monster.corpse = 5565
monster.speed = 85
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
	rewardBoss = true,
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
	{ text = "Join my crew ... forever.", yell = false },
	{ text = "You are lost!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 150 }, -- Gold Coin
	{ id = 3566, chance = 1000 }, -- Red Robe
	{ id = 3382, chance = 1000 }, -- Crown Legs
	{ id = 8043, chance = 1000 }, -- Focus Cape
	{ id = 3049, chance = 12500 }, -- Stealth Ring
	{ id = 3271, chance = 1000 }, -- Spike Sword
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -95, condition = { type = CONDITION_POISON, totalDamage = 2, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -30, maxDamage = -80, radius = 1, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -130, maxDamage = -150, range = 1, radius = 1, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "outfit", interval = 2000, chance = 5, range = 3, shootEffect = CONST_ANI_EXPLOSION, target = true, duration = 4000, outfitMonster = "Skeleton" },
}

monster.defenses = {
	defense = 0,
	armor = 0,
	mitigation = 0.99,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 40, maxDamage = 70, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 100 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
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
