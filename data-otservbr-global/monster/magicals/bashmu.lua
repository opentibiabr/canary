local mType = Game.createMonsterType("Bashmu")
local monster = {}

monster.description = "a bashmu"
monster.experience = 5000
monster.outfit = {
	lookType = 1408,
	lookHead = 0,
	lookBody = 50,
	lookLegs = 42,
	lookFeet = 79,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2100
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Salt Caves.",
}

monster.health = 8200
monster.maxHealth = 8200
monster.race = "blood"
monster.corpse = 36804
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
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
	staticAttackChance = 70,
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
	{ id = 3035, chance = 80000, maxCount = 19 }, -- platinum coin
	{ id = 3315, chance = 23000 }, -- guardian halberd
	{ id = 36823, chance = 23000 }, -- bashmu feather
	{ id = 814, chance = 5000 }, -- terra amulet
	{ id = 815, chance = 5000 }, -- glacier amulet
	{ id = 3028, chance = 5000 }, -- small diamond
	{ id = 3036, chance = 5000 }, -- violet gem
	{ id = 7642, chance = 5000 }, -- great spirit potion
	{ id = 9302, chance = 5000 }, -- sacred tree amulet
	{ id = 16119, chance = 5000 }, -- blue crystal shard
	{ id = 16121, chance = 5000 }, -- green crystal shard
	{ id = 25737, chance = 5000 }, -- rainbow quartz
	{ id = 36820, chance = 5000 }, -- bashmu fang
	{ id = 36821, chance = 5000 }, -- bashmu tongue
	{ id = 817, chance = 1000 }, -- magma amulet
	{ id = 7407, chance = 1000 }, -- haunted blade
	{ id = 7454, chance = 1000 }, -- glorious axe
	{ id = 23526, chance = 1000 }, -- collar of blue plasma
	{ id = 23528, chance = 1000 }, -- collar of red plasma
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600 },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -800, length = 4, spread = 0, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -500, range = 3, radius = 3, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -400, maxDamage = -800, range = 7, shootEffect = CONST_ANI_EARTHARROW, target = true },
}

monster.defenses = {
	defense = 72,
	armor = 72,
	mitigation = 2.16,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 250, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 340, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
