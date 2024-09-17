local mType = Game.createMonsterType("Rogue Naga")
local monster = {}

monster.description = "a rogue naga"
monster.experience = 4510
monster.outfit = {
	lookType = 1543,
	lookHead = 75,
	lookBody = 13,
	lookLegs = 95,
	lookFeet = 109,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 6200
monster.maxHealth = 6200
monster.race = "blood"
monster.corpse = 39221
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
	{ name = "rogue naga scales", chance = 15450 },
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_PHYSICALDAMAGE, minDamage = -95, maxDamage = -390, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_PURPLEENERGY, range = 6, target = true }, -- basic_attack
	{ name = "nagadeathattack", interval = 2500, chance = 20, minDamage = -430, maxDamage = -505, range = 6, target = true }, -- death_strike
	{ name = "nagadeath", interval = 3000, chance = 20, minDamage = -380, maxDamage = -470, target = false }, -- short_death_wave
	{ name = "death chain", interval = 3500, chance = 20, minDamage = -460, maxDamage = -520, range = 6, target = true }, -- death_chain
	{ name = "combat", interval = 4000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -85, maxDamage = -190, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_PURPLEENERGY, range = 6, target = true }, -- explosion_strike
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
