local mType = Game.createMonsterType("Memory of a Book")
local monster = {}

monster.description = "a memory of a book"
monster.experience = 1770
monster.outfit = {
	lookType = 1060,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3670
monster.maxHealth = 3670
monster.race = "undead"
monster.corpse = 28586
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.strategiesTarget = {
	nearest = 100,
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
	{ id = 3130, chance = 8747 }, -- Twigs
	{ id = 16127, chance = 5002 }, -- Green Crystal Fragment
	{ id = 16119, chance = 5376 }, -- Blue Crystal Shard
	{ id = 16121, chance = 4122 }, -- Green Crystal Shard
	{ id = 37530, chance = 1748 }, -- Bottle of Champagne
	{ id = 37468, chance = 1248 }, -- Special Fx Box
	{ id = 3031, chance = 100000 }, -- Gold Coin
	{ id = 7643, chance = 10247 }, -- Ultimate Health Potion
	{ id = 3114, chance = 8625 }, -- Skull (Item)
	{ id = 3111, chance = 7622 }, -- Fishbone
	{ id = 7642, chance = 15246 }, -- Great Spirit Potion
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100 },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -50, maxDamage = -150, range = 7, shootEffect = CONST_ANI_ICE, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 45,
	mitigation = 1.20,
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
