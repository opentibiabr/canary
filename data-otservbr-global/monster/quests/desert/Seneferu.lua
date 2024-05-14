local mType = Game.createMonsterType("Seneferu")
local monster = {}

monster.description = "Seneferu"
monster.experience = 6000
monster.outfit = {
	lookType = 89,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "undead"
monster.corpse = 6025
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 50000,
	chance = 1,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 75,
	damage = 10,
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
	targetDistance = 1,
	runHealth = 333,
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

monster.summon = {
	maxSummons = 1,
	summons = {
		{ name = "Slime", chance = 25, interval = 5000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You will pay for waking me up", yell = false },
	{ text = "Years and years of perturbed sleep", yell = false },
	{ text = "My treasure was never enough, idiots!", yell = false },
}

monster.loot = {
	{ name = "gold coin", chance = 50000, maxCount = 300 },
	{ name = "small diamond", chance = 400, maxCount = 18 },
	{ name = "plate legs", chance = 2029 },
	{ name = "Crown Helmet", chance = 190 },
	{ name = "Crown Armor", chance = 190 },
	{ name = "Focus Cape", chance = 190 },
	{ name = "life crystal", chance = 190 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -80 },
	{ name = "combat", interval = 2900, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -45, maxDamage = -70, range = 8, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false },
	{ name = "condition", type = CONDITION_POISON, interval = 4000, chance = 22, minDamage = -2000, maxDamage = -2000, radius = 30, effect = CONST_ME_POISONAREA, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 20,
	mitigation = 0.99,
	{ name = "combat", interval = 2000, chance = 16, type = COMBAT_HEALING, minDamage = 45, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
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
	{ type = "bleed", condition = true },
}

mType:register(monster)
