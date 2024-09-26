local mType = Game.createMonsterType("Trancescreamer")
local monster = {}

monster.description = "Trancescreamer"
monster.experience = 51500
monster.outfit = {
	lookType = 677,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 50000
monster.maxHealth = 50000
monster.race = "venom"
monster.corpse = 7893
monster.speed = 180
monster.manaCost = 0

monster.changeTarget = {
	interval = 3000,
	chance = 50,
}

monster.strategiesTarget = {
	nearest = 20,
	health = 60,
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
	chance = 70,
	{ text = "Im gonna eat you piece of shit...", yell = false },
}

monster.loot = {
    { name = "koliseum token", chance = 9000000, minCount = 8, maxCount = 15},

}

monster.attacks = {
	{ name = "melee", interval = 1000, chance = 100, minDamage = 700, maxDamage = -800 },
	{ name = "speed", interval = 2300, chance = 55, speedChange = -1100, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_GREEN_RINGS, target = false, duration = 30000 },	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 70, minDamage = -600, maxDamage = -700, radius = 14, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "combat", interval = 1500, chance = 80, type = COMBAT_HOLYDAMAGE, minDamage = -400, maxDamage = -550, range = 5, radius = 16, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_HOLYAREA, target = true },
 	{ name = "combat", interval = 2000, chance = 70, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -400, length = 8, spread = 3, effect = CONST_ME_POISONAREA, target = false },

}

monster.defenses = {
	defense = 25,
	armor = 15,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 500, maxDamage = 1200, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 80 },
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
