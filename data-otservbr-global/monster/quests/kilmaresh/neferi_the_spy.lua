local mType = Game.createMonsterType("Neferi the Spy")
local monster = {}

monster.description = "Neferi the Spy"
monster.experience = 19650
monster.outfit = {
	lookType = 149,
	lookHead = 95,
	lookBody = 121,
	lookLegs = 94,
	lookFeet = 1,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 28000
monster.maxHealth = 28000
monster.race = "blood"
monster.corpse = 36982
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 2105,
	bossRace = RARITY_ARCHFOE,
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
	{ id = 37003, chance = 80000 }, -- eyeembroidered veil
	{ id = 37002, chance = 80000 }, -- tagraltinlaid scabbard
	{ id = 813, chance = 80000 }, -- terra boots
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 3370, chance = 80000 }, -- knight armor
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 3318, chance = 80000 }, -- knight axe
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 31323, chance = 80000 }, -- sea horse figurine
	{ id = 3067, chance = 80000 }, -- hailstorm rod
	{ id = 3280, chance = 80000 }, -- fire sword
	{ id = 3065, chance = 80000 }, -- terra rod
	{ id = 7643, chance = 80000 }, -- ultimate health potion
	{ id = 3267, chance = 80000 }, -- dagger
	{ id = 7642, chance = 80000 }, -- great spirit potion
	{ id = 828, chance = 80000 }, -- lightning headband
	{ id = 16120, chance = 80000 }, -- violet crystal shard
	{ id = 8073, chance = 80000 }, -- spellbook of warding
	{ id = 819, chance = 80000 }, -- glacier shoes
	{ id = 829, chance = 80000 }, -- glacier mask
	{ id = 822, chance = 80000 }, -- lightning legs
	{ id = 31324, chance = 80000 }, -- golden mask
	{ id = 3049, chance = 80000 }, -- stealth ring
	{ id = 830, chance = 80000 }, -- terra hood
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -150, maxDamage = -350 },
	{ name = "combat", interval = 2000, chance = 60, type = COMBAT_EARTHDAMAGE, minDamage = -700, maxDamage = -1100, radius = 3, effect = CONST_ME_SMALLPLANTS, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -650, maxDamage = -800, range = 5, radius = 3, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = {
	defense = 60,
	armor = 82,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
