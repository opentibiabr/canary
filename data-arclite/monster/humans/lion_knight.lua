local mType = Game.createMonsterType("Lion Knight")
local monster = {}

monster.description = "a lion knight"
monster.experience = 0
monster.outfit = {
	lookType = 1317,
	lookHead = 0,
	lookBody = 78,
	lookLegs = 57,
	lookFeet = 57,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 9000
monster.maxHealth = 9000
monster.race = "blood"
monster.corpse = 33957
monster.speed = 130

monster.faction = FACTION_LION
monster.enemyFactions = {FACTION_LIONUSURPERS}

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
	staticAttackChance = 90,
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

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400, effect = CONST_ME_DRAWBLOOD},
	{name ="combat", interval = 6000, chance = 12, type = COMBAT_HOLYDAMAGE, minDamage = -400, maxDamage = -500, radius = 3, effect = CONST_ME_HOLYAREA, target = false},
	{name ="combat", interval = 4000, chance = 10, type = COMBAT_HOLYDAMAGE, minDamage = -200, maxDamage = -500, range = 5, radius = 3, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_HOLYAREA, target = true}
}

monster.defenses = {
	defense = 86,
	armor = 86
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
