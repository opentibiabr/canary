local mType = Game.createMonsterType("Mad Technomancer")
local monster = {}

monster.description = "mad technomancer"
monster.experience = 55
monster.outfit = {
	lookType = 66,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 1800
monster.maxHealth = 1800
monster.race = "blood"
monster.corpse = 6015
monster.speed = 100
monster.manaCost = 0

monster.changeTarget = {
	interval = 500,
	chance = 25,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = true,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 150,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "I'm going to make them an offer they can't refuse.", yell = false },
	{ text = "My masterplan cannot fail!", yell = false },
	{ text = "Gentlemen, you can't fight here! This is the War Room!", yell = false },
	{ text = "I love the smell of firebombs in the morning.", yell = false },
}

monster.loot = {
	{ id = 396, chance = 1000000 }, -- technomancer beard
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 50, attack = 40 },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -50, maxDamage = -120, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 1000, chance = 34, type = COMBAT_PHYSICALDAMAGE, minDamage = -55, maxDamage = -105, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = false },
	{ name = "combat", interval = 1000, chance = 25, type = COMBAT_MANADRAIN, minDamage = -50, maxDamage = -80, range = 7, target = false },
}

monster.defenses = {
	defense = 15,
	armor = 15,
	--	mitigation = ???,
	{ name = "combat", interval = 1000, chance = 50, type = COMBAT_HEALING, minDamage = 75, maxDamage = 325, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -1 },
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
