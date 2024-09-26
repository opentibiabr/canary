local mType = Game.createMonsterType("Thundrax")
local monster = {}

monster.description = "Thundrax"
monster.experience = 185
monster.outfit = {
	lookType = 1211,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 2,
	lookMount = 1682,
}

monster.raceId = 371
monster.health = 500000
monster.maxHealth = 500000
monster.race = "blood"
monster.corpse = 7893
monster.speed = 1300
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 60,
}

monster.strategiesTarget = {
	nearest = 20,
	health = 10,
	damage = 30,
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
	chance = 10,
	{ text = "Feel this power", yell = false },
	{ text = "Killing you is easy.", yell = false },
	{ text = "Thinking on leave?", yell = false },
	{ text = "Hahahaha!", yell = false },
}

monster.loot = {
    { name = "koliseum token", chance = 9000000, minCount = 75, maxCount = 90},

}

monster.attacks = {
	{ name = "melee", interval = 1000, chance = 100, minDamage = 2000, maxDamage = -4000 },
	{ name = "combat", interval = 2200, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -800, range = 7, shootEffect = CONST_ANI_FIRE, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -900, range = 7, shootEffect = CONST_ANI_ENERGY, target = false },
    { name = "combat", interval = 1600, chance = 80, type = COMBAT_HOLYDAMAGE, minDamage = -1300, maxDamage = -1800, range = 15, radius = 20, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_HOLYAREA, target = true },
   -- { name = "combat", interval = 1500, chance = 80, type = COMBAT_FIREDAMAGE, minDamage = -700, maxDamage = -1200, range = 15, radius = 20, shootEffect = CONST_ANI_SMALLFIRE, effect = CONST_ME_FIREAREA, target = true },
   -- { name = "combat", interval = 1700, chance = 80, type = COMBAT_ICEDAMAGE, minDamage = -700, maxDamage = -1400, range = 15, radius = 20, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEAREA, target = true },
    { name = "combat", interval = 1800, chance = 80, type = COMBAT_ENERGYDAMAGE, minDamage = -700, maxDamage = -1200, range = 15, radius = 20, shootEffect = CONST_ANI_SMALLENERGY, effect = CONST_ME_ENERGYAREA, target = true },
   { name = "combat", interval = 2500, chance = 80, type = COMBAT_ENERGYDAMAGE, minDamage = -700, maxDamage = -1300, range = 15, radius = 20, shootEffect = CONST_ANI_SMALLENERGY, effect = CONST_ME_ENERGYAREA, target = true },


}

monster.defenses = {
	defense = 15,
	armor = 15,
	mitigation = 0.64,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 60, maxDamage = 80, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
