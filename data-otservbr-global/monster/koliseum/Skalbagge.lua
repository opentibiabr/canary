local mType = Game.createMonsterType("Skalbagge")
local monster = {}

monster.description = "Skalbagge"
monster.experience = 0
monster.outfit = {
	lookType = 987,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 100000
monster.maxHealth = 100000
monster.race = "blood"
monster.corpse = 7893
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 60,
}

monster.strategiesTarget = {
	nearest = 30,
	health = 10,
	damage = 30,
	random = 70,
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
	staticAttackChance = 95,
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
	chance = 70,
		{ text = "I see you dying", yell = false },
}

monster.loot = {
    { name = "koliseum token", chance = 9000000, minCount = 15, maxCount = 17},

}

monster.attacks = {
	{ name = "melee", interval = 1000, chance = 100, minDamage = 200, maxDamage = -300 },
	--{ name = "combat", interval = 1800, chance = 70, type = COMBAT_ICEDAMAGE, minDamage = -600, maxDamage = -700, range = 6, length = 18, spread = 7, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = false },
	{ name = "combat", interval = 2000, chance = 65, type = COMBAT_ICEDAMAGE, minDamage = -500, maxDamage = -650, range = 7, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEHIT, target = true },
	{ name = "combat", interval = 1500, chance = 80, type = COMBAT_HOLYDAMAGE, minDamage = -500, maxDamage = -650, range = 5, radius = 16, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_HOLYAREA, target = true },
	{ name = "combat", interval = 1500, chance = 80, type = COMBAT_ICEDAMAGE, minDamage = -500, maxDamage = -650, range = 5, radius = 16, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEAREA, target = true },
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_MANADRAIN, minDamage = -250, maxDamage = -350, range = 7, target = false },

}

monster.defenses = {
	defense = 55,
	armor = 55,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 80 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
