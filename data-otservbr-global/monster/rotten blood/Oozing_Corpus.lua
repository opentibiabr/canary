local mType = Game.createMonsterType("Oozing Corpus")
local monster = {}

monster.description = "a Oozing Corpus"
monster.experience = 19800
monster.outfit = {
	lookType = 1625,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 28700
monster.maxHealth = 28700
monster.race = "undead"
monster.corpse = 43575
monster.speed = 220
monster.manaCost = 0

monster.raceId = 2381
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
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
	{name = "great spirit potion", chance = 32220, maxCount = 7},
	{name = "steel boots", chance = 2000},
	{name = "dragonbone staff", chance = 15500},
	{name = "giant sword", chance = 13500},
	{name = "mercenary sword", chance = 11500},
	{name = "fur armor", chance = 9500},
	{name = "terra mantle", chance = 3500},
	{name = "wood cape", chance = 2500},
	{name = "rubber cap", chance = 1500},
	{name = "stone skin amulet", chance = 2000},
	{id = 43846, chance = 13000},
	{id = 43736, chance = 4000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1050},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -750, maxDamage = -1000, radius = 4, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -550, maxDamage = -900, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -800, maxDamage = -1250, length = 8, effect = CONST_ME_EXPLOSIONHIT, target = false}
}

monster.defenses = {
	defense = 100,
	armor = 117
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 30},
	{type = COMBAT_ENERGYDAMAGE, percent = -25},
	{type = COMBAT_EARTHDAMAGE, percent = 40},
	{type = COMBAT_FIREDAMAGE, percent = 25},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
