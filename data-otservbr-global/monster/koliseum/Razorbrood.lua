local mType = Game.createMonsterType("Razorbrood")
local monster = {}

monster.description = "Razorbrood"
monster.experience = 4500
monster.outfit = {
	lookType = 985,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 30000
monster.maxHealth = 30000
monster.race = "blood"
monster.corpse = 7893
monster.speed = 140
monster.manaCost = 0

monster.changeTarget = {
	interval = 3000,
	chance = 30,
}

monster.strategiesTarget = {
	nearest = 20,
	health = 10,
	damage = 10,
	random = 80,
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
	chance = 80,
	{ text = "Yooooouuuuu...", yell = false },
}

monster.loot = {
    { name = "koliseum token", chance = 9000000, minCount = 3, maxCount = 8},
}

monster.attacks = {
	{ name = "melee", interval = 1000, chance = 100, minDamage = -150, maxDamage = -180 },
	{ name = "combat", interval = 1800, chance = 70, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -600, range = 6, length = 18, spread = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 65, type = COMBAT_ENERGYDAMAGE, minDamage = -300, maxDamage = -650, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = true },
	--{ name = "combat", interval = 1600, chance = 60, type = COMBAT_ENERGYDAMAGE, minDamage = -250, maxDamage = -300, range = 7, radius = 16, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 1500, chance = 80, type = COMBAT_HOLYDAMAGE, minDamage = -300, maxDamage = -650, range = 5, radius = 16, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_HOLYAREA, target = true },





}

monster.defenses = {
	defense = 35,
	armor = 35,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 800, maxDamage = 1000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 80 },
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
