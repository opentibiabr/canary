local mType = Game.createMonsterType("Hardened Usurper warlock")
local monster = {}

monster.description = "a hardened usurper warlock"
monster.experience = 0
monster.outfit = {
	lookType = 1316,
	lookHead = 57,
	lookBody = 38,
	lookLegs = 21,
	lookFeet = 21,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 7500
monster.maxHealth = 7500
monster.race = "blood"
monster.corpse = 0
monster.speed = 165

monster.faction = FACTION_LIONUSURPERS
monster.enemyFactions = {FACTION_LION, FACTION_PLAYER}

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 0
}

monster.loot = {
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250, effect = CONST_ME_DRAWBLOOD},
	{name ="singledeathchain", interval = 6000, chance = 7, minDamage = -250, maxDamage = -530, range = 5, effect = CONST_ME_MORTAREA, target = true},
	{name ="singleicechain", interval = 6000, chance = 8, minDamage = -150, maxDamage = -450, range = 5, effect = CONST_ME_ICEATTACK, target = true},
	{name ="combat", interval = 4000, chance = 11, type = COMBAT_ICEDAMAGE, minDamage = -200, maxDamage = -450, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEATTACK, target = true} -- avalanche
}

monster.defenses = {
	defense = 50,
	armor = 82
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 5},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 30},
	{type = COMBAT_HOLYDAMAGE , percent = 32},
	{type = COMBAT_DEATHDAMAGE , percent = -10}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
