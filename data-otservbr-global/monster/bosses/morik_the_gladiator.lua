local mType = Game.createMonsterType("Morik the Gladiator")
local monster = {}

monster.description = "Morik the Gladiator"
monster.experience = 160
monster.outfit = {
	lookType = 131,
	lookHead = 38,
	lookBody = 19,
	lookLegs = 19,
	lookFeet = 95,
	lookAddons = 1,
	lookMount = 0,
}

monster.health = 1235
monster.maxHealth = 1235
monster.race = "blood"
monster.corpse = 18173
monster.speed = 100
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0,
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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 10,
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
	maxSummons = 2,
	summons = {
		{ name = "Gladiator", chance = 10, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "To be the one you'll have to beat the one!", yell = false },
	{ text = "Where did I put my ultimate health potion again?", yell = false },
	{ text = "I am the best!", yell = false },
	{ text = "I'll take your ears as a trophy!", yell = false },
}

monster.loot = {
	{ id = 8820, chance = 100000 }, -- morik's helmet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -110, radius = 3, effect = CONST_ME_HITAREA, target = false },
	{ name = "drunk", interval = 3000, chance = 34, range = 7, shootEffect = CONST_ANI_WHIRLWINDSWORD, target = false, duration = 5000 },
}

monster.defenses = {
	defense = 22,
	armor = 20,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -1 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
