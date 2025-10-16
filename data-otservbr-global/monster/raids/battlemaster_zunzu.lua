local mType = Game.createMonsterType("Battlemaster Zunzu")
local monster = {}

monster.description = "Battlemaster Zunzu"
monster.experience = 2500
monster.outfit = {
	lookType = 343,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 635,
	bossRace = RARITY_NEMESIS,
}

monster.health = 4000
monster.maxHealth = 4000
monster.race = "blood"
monster.corpse = 10364
monster.speed = 210
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 150,
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
	{ text = "Hissss!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 136 }, -- gold coin
	{ id = 3032, chance = 80000, maxCount = 10 }, -- small emerald
	{ id = 239, chance = 80000 }, -- great health potion
	{ id = 10289, chance = 80000 }, -- red lantern
	{ id = 10413, chance = 80000 }, -- zaogun flag
	{ id = 10387, chance = 80000 }, -- zaoan legs
	{ id = 10386, chance = 1000 }, -- zaoan shoes
	{ id = 10384, chance = 1000 }, -- zaoan armor
	{ id = 10451, chance = 1000 }, -- jade hat
	{ id = 10414, chance = 80000 }, -- zaogun shoulderplates
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_EARTHDAMAGE, minDamage = -115, maxDamage = -350, range = 1, radius = 1, effect = CONST_ME_POISONAREA, target = true },
}

monster.defenses = {
	defense = 35,
	armor = 45,
	mitigation = 1.60,
	{ name = "combat", interval = 1000, chance = 18, type = COMBAT_HEALING, minDamage = 200, maxDamage = 400, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
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
