local mType = Game.createMonsterType("Sopping Carcass")
local monster = {}

monster.description = "a Sopping Carcass"
monster.experience = 21100
monster.outfit = {
	lookType = 1658,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 32700
monster.maxHealth = 32700
monster.race = "undead"
monster.corpse = 43832
monster.speed = 210
monster.manaCost = 0

monster.raceId = 2396
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
	{name = "ultimate spirit potion", chance = 31627, maxCount = 6},
	{name = "royal star", chance = 31325, maxCount = 6},
	{name = "bullseye potion", chance = 22590, maxCount = 10},
	{name = "berserk potion", chance = 21988, maxCount = 10},
	{name = "blue gem", chance = 21687, maxCount = 2},
	{name = "mastermind potion", chance = 17771, maxCount = 10},
	{name = "green gem", chance = 17470, maxCount = 2},
	{name = "gold ingot", chance = 13253},
	{name = "crystal coin", chance = 10241},
	{name = "stone skin amulet", chance = 10241},
	{name = "demon shield", chance = 2000},
	{name = "assassin dagger", chance = 3000},
	{id = 43732, chance = 3000},
	{id = 43858, chance = 11500},
	{name = "scarab ocarina", chance = 4000},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -800},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_ICEDAMAGE, minDamage = -750, maxDamage = -900, range = 7, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_BIGCLOUDS, target = true},
	{name ="combat", interval = 2000, chance = 17, type = COMBAT_HOLYDAMAGE, minDamage = -750, maxDamage = -900, radius = 4, effect = CONST_ME_HOLYAREA, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HOLYDAMAGE, minDamage = -750, maxDamage = -1100, range = 7, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYDAMAGE, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -750, maxDamage = -1100, range = 7, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEATTACK, target = true},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_ICEDAMAGE, minDamage = -750, maxDamage = -900, radius = 3, effect = CONST_ME_ICEATTACK, target = false}
}

monster.defenses = {
	defense = 109,
	armor = 109
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 35},
	{type = COMBAT_EARTHDAMAGE, percent = -15},
	{type = COMBAT_FIREDAMAGE, percent = -5},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = -20},
	{type = COMBAT_DEATHDAMAGE , percent = 60}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
