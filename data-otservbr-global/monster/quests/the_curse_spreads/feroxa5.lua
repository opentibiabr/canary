local mType = Game.createMonsterType("Feroxa5")
local monster = {}

monster.name = "Feroxa"
monster.description = "Feroxa"
monster.experience = 0
monster.outfit = {
	lookType = 731,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 150000
monster.maxHealth = 150000
monster.race = "blood"
monster.corpse = 22089
monster.speed = 175
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 2,
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
	canWalkOnEnergy = false,
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
	{ id = 16119, chance = 10000, maxCount = 5 }, -- blue crystal shard
	{ id = 16120, chance = 10000, maxCount = 5 }, -- violet crystal shard
	{ id = 16124, chance = 10000, maxCount = 5 }, -- blue crystal splinter
	{ id = 3041, chance = 2500 }, -- blue gem
	{ id = 3039, chance = 2500 }, -- red gem
	{ id = 3079, chance = 1500 }, -- boots of haste
	{ id = 3035, chance = 100000, maxCount = 50 }, -- platinum coin
	{ id = 7643, chance = 10000, maxCount = 5 }, -- ultimate health potion
	{ id = 238, chance = 10000, maxCount = 5 }, -- great mana potion
	{ id = 239, chance = 10000, maxCount = 5 }, -- great health potion
	{ id = 22062, chance = 10000, unique = true }, -- werewolf helmet
	{ id = 22060, chance = 1500 }, -- werewolf amulet
	{ id = 22084, chance = 1500 }, -- wolf backpack
	{ id = 7436, chance = 1500 }, -- angelic axe
	{ id = 7419, chance = 1500 }, -- dreaded cleaver
	{ id = 22085, chance = 1500 }, -- fur armor
	{ id = 22086, chance = 1500 }, -- badger boots
	{ id = 22104, chance = 12000 }, -- trophy of feroxa
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1400, maxDamage = -1800 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -700, maxDamage = -1050, radius = 6, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = -700, maxDamage = -1250, length = 9, spread = 0, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -450, maxDamage = -700, radius = 7, effect = CONST_ME_BLOCKHIT, target = false },
}

monster.defenses = {
	defense = 55,
	armor = 50,
	{ name = "speed", interval = 2000, chance = 12, speedChange = 1250, effect = CONST_ME_MAGIC_RED, target = false, duration = 10000 },
	{ name = "feroxa summon", interval = 2000, chance = 20, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
