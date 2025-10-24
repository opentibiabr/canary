local mType = Game.createMonsterType("Avalanche")
local monster = {}

monster.description = "Avalanche"
monster.experience = 305
monster.outfit = {
	lookType = 261,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 550
monster.maxHealth = 550
monster.race = "undead"
monster.corpse = 7349
monster.speed = 104
monster.manaCost = 0

monster.changeTarget = {
	interval = 0,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Puny warmblood.", yell = false },
	{ text = "You will pay for imprisoning me here.", yell = false },
	{ text = "You're not cool.", yell = false },
}

monster.loot = {

}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -180 },
	{ name = "combat", interval = 1000, chance = 100, type = COMBAT_DROWNDAMAGE, minDamage = -10, maxDamage = -50, length = 5, spread = 6, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "speed", interval = 4000, chance = 100, speedChange = -400, radius = 3, effect = CONST_ME_POFF, target = false, duration = 10000 },
	{ name = "combat", interval = 6000, chance = 100, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -40, range = 5, radius = 1, shootEffect = CONST_ANI_LARGEROCK, target = true },
}

monster.defenses = {
	defense = 27,
	armor = 26,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
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
