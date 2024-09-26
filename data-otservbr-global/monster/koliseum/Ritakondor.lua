local mType = Game.createMonsterType("Ritakondor")
local monster = {}

monster.description = "Ritakondor"
monster.experience = 100000
monster.outfit = {
	lookType = 1393,
}


monster.health = 220000
monster.maxHealth = 220000
monster.race = "blood"
monster.corpse = 7893
monster.speed = 600
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 60,
}

monster.strategiesTarget = {
	nearest = 30,
	damage = 40,
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
	chance = 10,
	{ text = "What are you doing here? Mijo", yell = false },
}

monster.loot = {
    { name = "koliseum token", chance = 9000000, minCount = 37, maxCount = 45},

}

monster.attacks = {
	{ name = "melee", interval = 1600, chance = 100, minDamage = -1270, maxDamage = -1500 },
	{ name = "combat", interval = 2000, chance = 60, type = COMBAT_DEATHDAMAGE, minDamage = -1200, maxDamage = -1800, range = 5, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "mana leechMY", interval = 1500, chance = 60, minDamage = -300, maxDamage = -400, target = false },
	{ name = "combat", interval = 1500, chance = 80, type = COMBAT_HOLYDAMAGE, minDamage = -1000, maxDamage = -1350, range = 5, radius = 16, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_HOLYAREA, target = false },

}

monster.defenses = {
	defense = 60,
	armor = 82,
	--	mitigation = ???,
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
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}


mType:register(monster)
