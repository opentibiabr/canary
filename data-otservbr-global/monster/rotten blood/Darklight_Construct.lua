local mType = Game.createMonsterType("Darklight Construct")
local monster = {}

monster.description = "a Darklight Construct"
monster.experience = 21200
monster.outfit = {
	lookType = 1622,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 32200
monster.maxHealth = 32200
monster.race = "undead"
monster.corpse = 43563
monster.speed = 220
monster.manaCost = 0

monster.raceId = 2378
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 5000,
	FirstUnlock = 25,
	SecondUnlock = 3394,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Sanctuary."
	}
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
	{name = "ultimate health potion", chance = 32220, maxCount = 9},
	{name = "gold ingot", chance = 65560},
	{name = "terra legs", chance = 25560},
	{name = "violet gem", chance = 60000},
	{name = "green gem", chance = 70000},
	{id = 43850, chance = 15000},
	{id = 43851, chance = 13500},
	{name = "blue gem", chance = 55000},
	{name = "hammer of wrath", chance = 13500},
	{name = "ruthless axe", chance = 17500},
	{name = "nightmare blade", chance = 9500},
	{name = "twiceslicer", chance = 7500},
	{name = "crystal crossbow", chance = 6500},
	{name = "crystalline sword", chance = 7500},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HOLYDAMAGE, minDamage = -450, maxDamage = -900, range = 7, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_HOLYAREA, target = true},
	{name ="combat", interval = 2000, chance = 22, type = COMBAT_EARTHDAMAGE, minDamage = -450, maxDamage = -900, radius = 4, effect = CONST_ME_SMALLPLANTS, target = true},
	{name ="combat", interval = 2000, chance = 22, type = COMBAT_PHYSICALDAMAGE, minDamage = -450, maxDamage = -1000, radius = 4, effect = CONST_ME_EXPLOSIONHIT, target = false},
	{name ="combat", interval = 2000, chance = 22, type = COMBAT_HOLYDAMAGE, minDamage = -450, maxDamage = -1000, radius = 4, effect = CONST_ME_HOLYDAMAGE, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -400, maxDamage = -600, range = 7, shootEffect = CONST_ANI_PIERCINGBOLT, effect = CONST_ME_GREEN_RINGS, target = true},
}

monster.defenses = {
	defense = 100,
	armor = 117
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -15},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = 10},
	{type = COMBAT_FIREDAMAGE, percent = 55},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -5},
	{type = COMBAT_HOLYDAMAGE , percent = 40},
	{type = COMBAT_DEATHDAMAGE , percent = -20}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
