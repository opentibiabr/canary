local mType = Game.createMonsterType("Elder Bloodjaw")
local monster = {}

monster.description = "a Elder Bloodjaw"
monster.experience = 0
monster.outfit = {
	lookType = 1628,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}


monster.health = 35000
monster.maxHealth = 35000
monster.race = "undead"
monster.corpse = 43669
monster.speed = 210
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	runHealth = 800,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {

}

monster.loot = {
	{name = "crystal coin", chance = 70540},
	{name = "platinum coin", chance = 81920, maxCount = 33},
	{name = "great mana potion", chance = 71920, maxCount = 5},
	{name = "green gem", chance = 64560},
	{name = "steel boots", chance = 5050},
	{name = "stone skin amulet", chance = 31920},
	{name = "small diamond", chance = 10000, maxCount = 5},
	{name = "small sapphire", chance = 10000, maxCount = 5},
	{name = "small ruby", chance = 12000, maxCount = 5},
	{name = "platinum amulet", chance = 13920},
	{name = "jewelled backpack", chance = 2100},
	{name = "springsprout rod", chance = 14920},
	{name = "vile axe", chance = 7000}, 
	{id = 43857, chance = 18000},
	{id = 43739, chance = 16500},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 400, maxDamage = -790},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -520, maxDamage = -805, range = 7, radius = 1, shootEffect = CONST_ANI_POISON, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -400, radius = 4, effect = CONST_ME_MAGIC_GREEN, target = false},
	{name ="drunk", interval = 2000, chance = 10, radius = 3, effect = CONST_ME_HITBYPOISON, target = false, duration = 5000},
	{name ="blightwalker curse", interval = 2000, chance = 15, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = -300, range = 7, shootEffect = CONST_ANI_POISON, target = true, duration = 30000}
}

monster.defenses = {
	defense = 100,
	armor = 100
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -15},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 5},
	{type = COMBAT_FIREDAMAGE, percent = 40},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 25},
	{type = COMBAT_DEATHDAMAGE , percent = -20}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
