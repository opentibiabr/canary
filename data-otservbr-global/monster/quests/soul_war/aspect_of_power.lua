local mType = Game.createMonsterType("Aspect of Power")
local monster = {}

monster.description = "an aspect of power"
monster.experience = 0
monster.outfit = {
	lookType = 1306,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 25000
monster.maxHealth = 25000
monster.race = "undead"
monster.corpse = 33949
monster.speed = 175
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.events = {
	"SoulWarAspectOfPowerDeath",
}

monster.strategiesTarget = {
	nearest = 100,
	health = 20,
	damage = 30,
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
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -800 },
	{ name = "combat", interval = 1700, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -400, maxDamage = -950, radius = 3, shootEffect = CONST_ANI_ENVENOMEDARROW, effect = CONST_ME_HITBYPOISON, target = true },
	{ name = "combat", interval = 1700, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -300, maxDamage = -850, length = 4, spread = 0, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 1700, chance = 35, type = COMBAT_DEATHDAMAGE, minDamage = -700, maxDamage = -1550, radius = 3, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	{ name = "outfit", interval = 4000, chance = 30, target = false, duration = 4000, outfitMonster = "Goshnar's Malice" },
	{ name = "outfit", interval = 4000, chance = 30, target = false, duration = 4000, outfitMonster = "Goshnar's Cruelty" },
	{ name = "outfit", interval = 4000, chance = 30, target = false, duration = 4000, outfitMonster = "Goshnar's Hatred" },
	{ name = "outfit", interval = 4000, chance = 30, target = false, duration = 4000, outfitMonster = "Goshnar's Spite" },
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
