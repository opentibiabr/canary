local mType = Game.createMonsterType("Memory of a Golem")
local monster = {}

monster.description = "a memory of a golem"
monster.experience = 1620
monster.outfit = {
	lookType = 600,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3660
monster.maxHealth = 3660
monster.race = "venom"
monster.corpse = 20972
monster.speed = 130
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
	rewardBoss = false,
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
	{ id = 3032, chance = 6765 }, -- Small Emerald
	{ id = 3031, chance = 100000 }, -- Gold Coin
	{ id = 7643, chance = 4624 }, -- Ultimate Health Potion
	{ id = 21755, chance = 12700 }, -- Bronze Gear Wheel
	{ id = 238, chance = 13882 }, -- Great Mana Potion
	{ id = 9057, chance = 6406 }, -- Small Topaz
	{ id = 3037, chance = 1420 }, -- Yellow Gem
	{ id = 21167, chance = 1423 }, -- Heat Core
	{ id = 37531, chance = 3970 }, -- Candy Floss (Large)
	{ id = 37468, chance = 1190 }, -- Special Fx Box
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 60, attack = 50 },
	{ name = "melee", interval = 2000, chance = 2, skill = 86, attack = 100 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -50, maxDamage = -150, range = 7, shootEffect = CONST_ANI_ENERGY, target = false },
	{ name = "war golem skill reducer", interval = 2000, chance = 16, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 40,
	mitigation = 1.40,
	{ name = "speed", interval = 2000, chance = 13, speedChange = 404, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
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
