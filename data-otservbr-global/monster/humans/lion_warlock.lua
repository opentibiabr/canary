local mType = Game.createMonsterType("Lion Warlock")
local monster = {}

monster.description = "a lion warlock"
monster.experience = 0
monster.outfit = {
	lookType = 1316,
	lookHead = 0,
	lookBody = 78,
	lookLegs = 96,
	lookFeet = 76,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 7500
monster.maxHealth = 7500
monster.race = "blood"
monster.corpse = 33965
monster.speed = 165
monster.manaCost = 0

monster.faction = FACTION_LION
monster.enemyFactions = { FACTION_LIONUSURPERS }

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
	staticAttackChance = 70,
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
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", interval = 6000, chance = 22, type = COMBAT_HOLYDAMAGE, minDamage = -200, maxDamage = -500, range = 7, radius = 4, effect = CONST_ME_HOLYAREA, target = true },
	{ name = "combat", interval = 6000, chance = 12, type = COMBAT_HOLYDAMAGE, minDamage = -400, maxDamage = -500, range = 7, effect = CONST_ME_HOLYDAMAGE, target = true },
	{ name = "combat", interval = 4000, chance = 12, type = COMBAT_ICEDAMAGE, minDamage = -200, maxDamage = -450, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEATTACK, target = true }, -- avalanche
}

monster.defenses = {
	defense = 50,
	armor = 0,
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
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

monster.loot = {

}
