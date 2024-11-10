local mType = Game.createMonsterType("Ancient Lion Knight")
local monster = {}

monster.description = "an ancient lion knight"
monster.experience = 8100
monster.outfit = {
	lookType = 1071,
	lookHead = 57,
	lookBody = 78,
	lookLegs = 76,
	lookFeet = 76,
	lookAddons = 1,
	lookMount = 0,
}

monster.health = 9100
monster.maxHealth = 9100
monster.race = "blood"
monster.corpse = 28621
monster.speed = 130
monster.manaCost = 0

monster.faction = FACTION_LIONUSURPERS
monster.enemyFactions = { FACTION_PLAYER, FACTION_LION }

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
	rewardBoss = true,
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

monster.loot = {
	{ name = "platinum coin", chance = 100000, maxCount = 5 },
	{ name = "dirty fur", chance = 53750 },
	{ id = 3130, chance = 8300 }, -- twigs
	{ name = "fishbone", chance = 9500 },
	{ name = "dark shield", chance = 2000 },
	{ name = "ham", chance = 53750 },
	{ name = "dirty cape", chance = 47500 },
	{ id = 3114, chance = 28750 }, -- skull
	{ name = "knife", chance = 25000 },
	{ name = "broken helmet", chance = 23750 },
	{ name = "dark armor", chance = 18750 },
	{ name = "bug meat", chance = 12500 },
	{ name = "combat knife", chance = 8750 },
	{ name = "plate armor", chance = 7500 },
	{ name = "studded shield", chance = 7500 },
	{ name = "big bone", chance = 5000 },
	{ name = "cape", chance = 5000 },
	{ name = "life preserver", chance = 3750 },
	{ name = "dwarven shield", chance = 1250 },
	{ name = "lion spangenhelm", chance = 35 },
	{ name = "lion plate", chance = 35 },
	{ name = "lion shield", chance = 35 },
	{ name = "lion longsword", chance = 35 },
	{ name = "lion hammer", chance = 35 },
	{ name = "lion axe", chance = 35 },
	{ name = "lion longbow", chance = 35 },
	{ name = "lion spellbook", chance = 35 },
	{ name = "lion wand", chance = 35 },
	{ name = "lion amulet", chance = 35 },
	{ name = "lion rod", chance = 35 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -750, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", interval = 6000, chance = 30, type = COMBAT_HOLYDAMAGE, minDamage = -450, maxDamage = -750, length = 8, spread = 0, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "combat", interval = 2750, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -800, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2500, chance = 22, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -500, radius = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 3300, chance = 24, type = COMBAT_ICEDAMAGE, minDamage = -250, maxDamage = -350, length = 4, spread = 0, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -500, radius = 4, effect = CONST_ME_BIGCLOUDS, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 0,
	--	mitigation = ???,
	{ name = "speed", interval = 1000, chance = 10, speedChange = 160, effect = CONST_ME_POFF, target = false, duration = 4000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
