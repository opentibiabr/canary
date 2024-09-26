local mType = Game.createMonsterType("Abortion")
local monster = {}

monster.description = "Abortion"
monster.experience = 1000
monster.outfit = {
	lookType = 1218,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 350000
monster.maxHealth = 350000
monster.race = "blood"
monster.corpse = 7893
monster.speed = 1000
monster.manaCost = 0


monster.changeTarget = {
	interval = 4000,
	chance = 50,
}

monster.strategiesTarget = {
	nearest = 30,
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
	chance = 100,
	{ text = "Dieeeeeeee", yell = false },
	{ text = "Give me your soul", yell = false },
	{ text = "Leave Now", yell = false },
}

monster.loot = {
	{ name = "koliseum token", chance = 9000000, minCount = 45, maxCount = 55},
}

monster.attacks = {
	{ name = "melee", interval = 1000, chance = 100, minDamage = 1500, maxDamage = -2500 },
	{ name = "outfit", interval = 2000, chance = 80, range = 5, shootEffect = CONST_ANI_EARTH, target = false, duration = 10000, outfitMonster = "Ugly Monster" },
	{ name = "drunk", interval = 2000, chance = 35, range = 5, shootEffect = CONST_ANI_EARTH, target = false, duration = 5000 },
  	{ name = "death chain", interval = 2000, chance = 100, minDamage = -700, maxDamage = -1200, target = false },
    { name = "combat", interval = 2500, chance = 53, type = COMBAT_DEATHDAMAGE, minDamage = -1700, maxDamage = -2000, length = 15, spread = 2, effect = CONST_ME_MORTAREA, target = true },
    { name = "combat", interval = 1500, chance = 80, type = COMBAT_HOLYDAMAGE, minDamage = -700, maxDamage = -900, range = 15, radius = 20, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_HOLYAREA, target = true },

}

monster.defenses = {
	defense = 48,
	armor = 0,
	--	mitigation = ???,
	{ name = "invisible", interval = 2000, chance = 8, effect = CONST_ME_HITAREA },
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
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
