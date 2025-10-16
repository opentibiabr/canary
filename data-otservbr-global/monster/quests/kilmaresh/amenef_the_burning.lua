local mType = Game.createMonsterType("Amenef the Burning")
local monster = {}

monster.description = "Amenef the Burning"
monster.experience = 21500
monster.outfit = {
	lookType = 541,
	lookHead = 113,
	lookBody = 114,
	lookLegs = 113,
	lookFeet = 113,
	lookAddons = 1,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 2103,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 26000
monster.maxHealth = 26000
monster.race = "blood"
monster.corpse = 31646
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	rewardBoss = true,
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
	{ id = 3315, chance = 80000 }, -- guardian halberd
	{ id = 7456, chance = 80000 }, -- noble axe
	{ id = 8073, chance = 80000 }, -- spellbook of warding
	{ id = 3370, chance = 80000 }, -- knight armor
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 8084, chance = 80000 }, -- springsprout rod
	{ id = 8092, chance = 80000 }, -- wand of starstorm
	{ id = 3326, chance = 80000 }, -- epee
	{ id = 7440, chance = 80000 }, -- mastermind potion
	{ id = 7386, chance = 80000 }, -- mercenary sword
	{ id = 37003, chance = 80000 }, -- eyeembroidered veil
	{ id = 37002, chance = 80000 }, -- tagraltinlaid scabbard
	{ id = 7404, chance = 80000 }, -- assassin dagger
	{ id = 8899, chance = 80000 }, -- slightly rusted legs
	{ id = 14040, chance = 80000 }, -- warriors axe
	{ id = 3379, chance = 80000 }, -- doublet
	{ id = 8896, chance = 80000 }, -- slightly rusted armor
	{ id = 3097, chance = 80000 }, -- dwarven ring
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 3073, chance = 80000 }, -- wand of cosmic energy
	{ id = 3318, chance = 80000 }, -- knight axe
	{ id = 31324, chance = 80000 }, -- golden mask
	{ id = 7426, chance = 80000 }, -- amber staff
	{ id = 3071, chance = 80000 }, -- wand of inferno
	{ id = 8043, chance = 80000 }, -- focus cape
	{ id = 8082, chance = 80000 }, -- underworld rod
	{ id = 9302, chance = 80000 }, -- sacred tree amulet
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 31323, chance = 80000 }, -- sea horse figurine
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -150, maxDamage = -510 },
	{ name = "firering", interval = 2000, chance = 10, minDamage = -300, maxDamage = -600, target = false },
	{ name = "firex", interval = 2000, chance = 15, minDamage = -450, maxDamage = -750, target = false },
	{ name = "combat", interval = 2000, chance = 17, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -600, radius = 2, effect = CONST_ME_FIREATTACK, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -750, length = 3, spread = 0, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 82,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
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
