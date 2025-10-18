local mType = Game.createMonsterType("Tazhadur")
local monster = {}

monster.description = "Tazhadur"
monster.experience = 9000
monster.outfit = {
	lookType = 947,
	lookHead = 24,
	lookBody = 119,
	lookLegs = 19,
	lookFeet = 95,
	lookAddons = 3,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1390,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 10000
monster.maxHealth = 10000
monster.race = "blood"
monster.corpse = 25065
monster.speed = 175
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
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
}

monster.loot = {
	{ id = 3031, chance = 90789, maxCount = 99 }, -- Gold Coin
	{ id = 5920, chance = 100000 }, -- Green Dragon Scale
	{ id = 5877, chance = 99230 }, -- Green Dragon Leather
	{ id = 3275, chance = 10740 }, -- Double Axe
	{ id = 3085, chance = 7670 }, -- Dragon Necklace
	{ id = 3322, chance = 4350 }, -- Dragon Hammer
	{ id = 3416, chance = 5630 }, -- Dragon Shield
	{ id = 3386, chance = 2810 }, -- Dragon Scale Mail
	{ id = 24937, chance = 100000, maxCount = 2 }, -- Dragon Blood
	{ id = 24938, chance = 100000 }, -- Dragon Tongue
	{ id = 24940, chance = 100000 }, -- Tooth of Tazhadur
	{ id = 236, chance = 1280 }, -- Strong Health Potion
	{ id = 3071, chance = 2560 }, -- Wand of Inferno
	{ id = 3583, chance = 41430, maxCount = 3 }, -- Dragon Ham
	{ id = 7430, chance = 1020 }, -- Dragonbone Staff
	{ id = 3028, chance = 260 }, -- Small Diamond
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 112, attack = 85 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -110, maxDamage = -495, range = 7, radius = 5, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -310, maxDamage = -495, length = 9, spread = 4, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -710, maxDamage = -895, length = 9, spread = 3, effect = CONST_ME_FIREAREA, target = false },
}

monster.defenses = {
	defense = 64,
	armor = 52,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 150, maxDamage = 450, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
