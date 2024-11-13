local mType = Game.createMonsterType("Rukor Zad")
local monster = {}

monster.description = "Rukor Zad"
monster.experience = 380
monster.outfit = {
	lookType = 152,
	lookHead = 95,
	lookBody = 95,
	lookLegs = 95,
	lookFeet = 95,
	lookAddons = 3,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 435,
	bossRace = RARITY_NEMESIS,
}

monster.health = 380
monster.maxHealth = 380
monster.race = "blood"
monster.corpse = 18297
monster.speed = 107
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I can kill a man in a thousand ways. And that`s only with a spoon!", yell = false },
	{ text = "You shouldn`t have come here!", yell = false },
	{ text = "Haiiii!", yell = false },
	{ text = "You are no match for a master assassin!", yell = false },
	{ text = "I'll teach you the art of death!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 93210, maxCount = 50 }, -- gold coin
	{ id = 3287, chance = 9210, maxCount = 14 }, -- throwing star
	{ id = 7366, chance = 6200, maxCount = 7 }, -- viper star
	{ id = 3351, chance = 4190 }, -- steel helmet
	{ id = 3409, chance = 1940 }, -- steel shield
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -170 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -100, range = 7, shootEffect = CONST_ANI_THROWINGSTAR, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -100, range = 7, shootEffect = CONST_ANI_POISONARROW, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -8, maxDamage = -8, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false },
	{ name = "drunk", interval = 3000, chance = 34, range = 7, target = false, duration = 5000 },
}

monster.defenses = {
	defense = 15,
	armor = 15,
	--	mitigation = ???,
	{ name = "invisible", interval = 2000, chance = 10, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 1 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
