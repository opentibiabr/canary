local mType = Game.createMonsterType("Foxmouse")
local monster = {}

monster.description = "a foxmouse"
monster.experience = 900
monster.outfit = {
	lookType = 1632,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}


monster.health = 1200
monster.maxHealth = 1200
monster.race = "blood"
monster.corpse = 0
monster.speed = 290
monster.manaCost = 0

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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 100,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
}

monster.loot = {
	{ name = "great mana potion", chance = 44810 },
	{ name = "wand of inferno", chance = 6500 },
	{ id = 43733, chance = 3000 },
	{ id = 43894,  chance = 6000 },
	{ name = "crusader helmet", chance = 1550 },
	{ name = "yellow piece of cloth", chance = 3230 },
	{ name = "green piece of cloth", chance = 2880 },
	{ name = "red piece of cloth", chance = 1500 },
	{ id = 5909, chance = 1100 },
	{ id = 3577, chance = 41450, maxCount = 3}
}

monster.attacks = {
	{ name ="melee", interval = 1500, chance = 100, minDamage = 0, maxDamage = -90 },
	{ name ="combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -75, maxDamage = -215, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = false }
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{ name ="speed", interval = 2000, chance = 15, speedChange = 370, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
	{ name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 125, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name ="invisible", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_BLUE }
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE , percent = 0 },
	{ type = COMBAT_DEATHDAMAGE , percent = -5 }
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false }
}

mType:register(monster)
