local mType = Game.createMonsterType("Sister Hetai")
local monster = {}

monster.description = "Sister Hetai"
monster.experience = 20500
monster.outfit = {
	lookType = 1199,
	lookHead = 114,
	lookBody = 19,
	lookLegs = 94,
	lookFeet = 78,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 25000
monster.maxHealth = 25000
monster.race = "blood"
monster.corpse = 31419
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 2104,
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
	{ id = 37002, chance = 80000 }, -- tagraltinlaid scabbard
	{ id = 813, chance = 80000 }, -- terra boots
	{ id = 3370, chance = 80000 }, -- knight armor
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3032, chance = 80000 }, -- small emerald
	{ id = 828, chance = 80000 }, -- lightning headband
	{ id = 3028, chance = 80000 }, -- small diamond
	{ id = 25737, chance = 80000 }, -- rainbow quartz
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 822, chance = 80000 }, -- lightning legs
	{ id = 3071, chance = 80000 }, -- wand of inferno
	{ id = 816, chance = 80000 }, -- lightning pendant
	{ id = 37003, chance = 80000 }, -- eyeembroidered veil
	{ id = 31323, chance = 80000 }, -- sea horse figurine
	{ id = 8043, chance = 80000 }, -- focus cape
	{ id = 826, chance = 80000 }, -- magma coat
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 8082, chance = 80000 }, -- underworld rod
	{ id = 3267, chance = 80000 }, -- dagger
	{ id = 9302, chance = 80000 }, -- sacred tree amulet
	{ id = 818, chance = 80000 }, -- magma boots
	{ id = 8092, chance = 80000 }, -- wand of starstorm
	{ id = 21169, chance = 80000 }, -- metal spats
	{ id = 3097, chance = 80000 }, -- dwarven ring
	{ id = 3073, chance = 80000 }, -- wand of cosmic energy
	{ id = 3098, chance = 80000 }, -- ring of healing
	{ id = 31324, chance = 80000 }, -- golden mask
	{ id = 14042, chance = 80000 }, -- warriors shield
	{ id = 22193, chance = 80000 }, -- onyx chip
	{ id = 830, chance = 80000 }, -- terra hood
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -270, maxDamage = -500 },
	{ name = "targetfirering", interval = 2000, chance = 40, minDamage = -500, maxDamage = -650, target = true },
	{ name = "combat", interval = 2000, chance = 70, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -500, radius = 2, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_EXPLOSIONHIT, target = true },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -750, radius = 4, effect = CONST_ME_ENERGYAREA, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 82,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -25 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
