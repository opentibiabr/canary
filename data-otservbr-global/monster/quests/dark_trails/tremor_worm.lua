local mType = Game.createMonsterType("Tremor Worm")
local monster = {}

monster.description = "a tremor worm"
monster.experience = 80000
monster.outfit = {
	lookType = 295,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 125000
monster.maxHealth = 125000
monster.race = "blood"
monster.corpse = 0
monster.speed = 85
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
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
	rewardBoss = false,
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
	{ id = 21902, chance = 1000 }, -- glooth glider crank
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 25 }, -- platinum coin
	{ id = 16126, chance = 80000 }, -- red crystal fragment
	{ id = 16125, chance = 80000 }, -- cyan crystal fragment
	{ id = 16127, chance = 80000 }, -- green crystal fragment
	{ id = 16121, chance = 80000 }, -- green crystal shard
	{ id = 16120, chance = 80000, maxCount = 2 }, -- violet crystal shard
	{ id = 3028, chance = 80000, maxCount = 5 }, -- small diamond
	{ id = 7642, chance = 80000 }, -- great spirit potion
	{ id = 238, chance = 80000, maxCount = 15 }, -- great mana potion
	{ id = 239, chance = 80000, maxCount = 15 }, -- great health potion
	{ id = 7643, chance = 80000, maxCount = 10 }, -- ultimate health potion
	{ id = 3098, chance = 80000 }, -- ring of healing
	{ id = 8082, chance = 80000 }, -- underworld rod
	{ id = 3053, chance = 80000 }, -- time ring
	{ id = 21203, chance = 80000, maxCount = 3 }, -- glooth bag
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3030, chance = 80000 }, -- small ruby
	{ id = 21164, chance = 80000 }, -- glooth cape
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3081, chance = 80000 }, -- stone skin amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -0, maxDamage = -400 },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 75 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 75 },
	{ type = COMBAT_EARTHDAMAGE, percent = 75 },
	{ type = COMBAT_FIREDAMAGE, percent = 75 },
	{ type = COMBAT_LIFEDRAIN, percent = 75 },
	{ type = COMBAT_MANADRAIN, percent = 75 },
	{ type = COMBAT_DROWNDAMAGE, percent = 75 },
	{ type = COMBAT_ICEDAMAGE, percent = 75 },
	{ type = COMBAT_HOLYDAMAGE, percent = 75 },
	{ type = COMBAT_DEATHDAMAGE, percent = 75 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
