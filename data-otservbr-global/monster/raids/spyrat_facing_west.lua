local mType = Game.createMonsterType("Spyrat West")
local monster = {}

monster.name = "Spyrat"
monster.description = "You see a spyrat"
monster.experience = 3750
monster.outfit = {
	lookTypeEx = 30378,
}

monster.health = 3000
monster.maxHealth = 3000
monster.race = "blood"
monster.corpse = 0
monster.speed = 0
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
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Catch me if you can!!", yell = false },
	{ text = "Never cross the rat line!", yell = false },
	{ text = "Smoke on the water!", yell = false },
}

monster.loot = {

}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -20, maxDamage = -500 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -90, maxDamage = -150, range = 7, shootEffect = CONST_ANI_WHIRLWINDSWORD, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DROWNDAMAGE, minDamage = -250, maxDamage = -500, range = 7, shootEffect = CONST_ANI_SPEAR, effect = CONST_ME_LOSEENERGY, target = true },
}

monster.defenses = {
	defense = 10,
	armor = 10,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = -30 },
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
	{ type = "bleed", condition = false },
}

mType:register(monster)
