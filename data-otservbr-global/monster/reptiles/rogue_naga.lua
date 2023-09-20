local mType = Game.createMonsterType("Rogue Naga")
local monster = {}

monster.description = "a rogue naga"
monster.experience = 4510
monster.outfit = {
	lookType = 1543,
	lookHead = 55,
	lookBody = 6,
	lookLegs = 0,
	lookFeet = 78,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 6200
monster.maxHealth = 6200
monster.race = "blood"
monster.corpse = 0
monster.speed = 182
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 4,
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
	{ text = "The Moon Goddess has forsaken us!", yell = false },
	{ text = "You underestimated us!", yell = false },
	{ text = "Death is too good for them.", yell = false },
	{ text = "Die, you fools!", yell = false },
}

monster.loot = {
	{ name = "Platinum Coin", chance = 85600, minCount = 1, maxCount = 12 },
	{ name = "Rogue Naga Scales", chance = 15450 },
	{ name = "Green Crystal Shard", chance = 14400, minCount = 1, maxCount = 2 },
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 100, minDamage = -300, maxDamage = -600, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_PURPLEENERGY, target = true },
	{ name = "combat", interval = 2000, chance = 47, type = COMBAT_PHYSICALDAMAGE, minDamage = -350, maxDamage = -400, effect = CONST_ME_BIG_SCRATCH, target = true },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -380, maxDamage = -470, length = 5, spread = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
}

monster.defenses = {
	defense = 110,
	armor = 0,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
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
