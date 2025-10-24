local mType = Game.createMonsterType("Tromphonyte")
local monster = {}

monster.description = "Tromphonyte"
monster.experience = 1300
monster.outfit = {
	lookType = 381,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3000
monster.maxHealth = 3000
monster.race = "blood"
monster.corpse = 12325
monster.speed = 120
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
	{ id = 3035, chance = 100000, maxCount = 12 }, -- Platinum Coin
	{ id = 9057, chance = 100000, maxCount = 5 }, -- Small Topaz
	{ id = 236, chance = 100000, maxCount = 2 }, -- Strong Health Potion
	{ id = 237, chance = 100000, maxCount = 2 }, -- Strong Mana Potion
	{ id = 12314, chance = 100000 }, -- Hollow Stampor Hoof
	{ id = 12312, chance = 100000 }, -- Stampor Horn
	{ id = 12313, chance = 100000 }, -- Stampor Talons
	{ id = 3370, chance = 100000 }, -- Knight Armor
	{ id = 7452, chance = 51720 }, -- Spiked Squelcher
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -215 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -170, maxDamage = -300, radius = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -90, maxDamage = -130, shootEffect = CONST_ANI_SMALLSTONE, target = true },
	{ name = "stampor skill reducer", interval = 2000, chance = 10, range = 5, target = false },
}

monster.defenses = {
	defense = 0,
	armor = 0,
	mitigation = 1.11,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 90, maxDamage = 120, effect = CONST_ME_MAGIC_BLUE, target = false },
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
