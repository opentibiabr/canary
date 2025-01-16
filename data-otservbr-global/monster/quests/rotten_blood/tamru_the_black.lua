local mType = Game.createMonsterType("Tamru the Black")
local monster = {}

monster.description = "a Tamru the Black"
monster.experience = 11200
monster.outfit = {
	lookType = 1646,
	lookHead = 95,
	lookBody = 132,
	lookLegs = 76,
	lookFeet = 76,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 15500
monster.maxHealth = 15500
monster.race = "undead"
monster.corpse = 44043
monster.speed = 180
monster.manaCost = 0

monster.bosstiary = {
	bossRaceId = 2405,
	bossRace = RARITY_NEMESIS,
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	runHealth = 800,
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

monster.voices = {}

monster.loot = {
	{ name = "platinum coin", chance = 11576, maxCount = 32 },
	{ name = "small diamond", chance = 12440, maxCount = 3 },
	{ name = "lightning pendant", chance = 10722, maxCount = 1 },
	{ name = "moonlight crystals", chance = 12403, maxCount = 8 },
	{ name = "silver moon coin", chance = 9617, maxCount = 1 },
	{ name = "weretiger tooth", chance = 5986, maxCount = 1 },
	{ name = "yellow gem", chance = 13110, maxCount = 1 },
	--{ name = "moon compass", chance = 10045, maxCount = 1 },
	{ name = "moon pin", chance = 7275, maxCount = 1 },
	{ name = "noble axe", chance = 6154, maxCount = 1 },
	{ name = "white gem", chance = 6291, maxCount = 1 },
	{ name = "crystal mace", chance = 11375, maxCount = 1 },
	{ name = "blue gem", chance = 12692, maxCount = 1 },
	{ name = "blue robe", chance = 5027, maxCount = 1 },
	{ name = "giant sapphire", chance = 5011, maxCount = 1 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -615, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -100, maxDamage = -400, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },
	{ name = "speed", interval = 4000, chance = 20, speedChange = -350, range = 7, shootEffect = CONST_ANI_POISON, target = true, duration = 12000 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -574, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -300, maxDamage = -646, radius = 3, effect = CONST_ME_POFF, target = false },
}

monster.defenses = {
	defense = 83,
	armor = 83,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 60 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
