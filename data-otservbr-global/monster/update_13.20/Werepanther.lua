local mType = Game.createMonsterType("Werepanther")
local monster = {}

monster.description = "a Werepanther"
monster.experience = 3380
monster.outfit = {
	lookType = 1648,
	lookHead = 1,
	lookBody = 1,
	lookLegs = 1,
	lookFeet = 45,
	lookAddons = 3,
	lookMount = 0
}

monster.health = 4200
monster.maxHealth = 4200
monster.race = "undead"
monster.corpse = 43758
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.raceId = 2390
monster.Bestiary = {
	class = "Lycanthrope",
	race = BESTY_RACE_LYCANTHROPE,
	toKill = 2500,
	FirstUnlock = 25,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 3,
	Occurrence = 0,
	Locations = "Sanctuary."
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
	{name = "gold coin", chance = 100000, maxCount = 197},
	{name = "platinum coin", chance = 100000, maxCount = 5},
	{name = "plate armor", chance = 13000},
	{name = "halberd", chance = 21000},
	{id = 43917, chance = 1500},
	{id = 43731, chance = 5000, maxCount = 2}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250, effect = CONST_ME_DRAWBLOOD},
	{name ="singledeathchain", interval = 6000, chance = 7, minDamage = -250, maxDamage = -530, range = 5, effect = CONST_ME_MORTAREA, target = true},
	{name ="singleicechain", interval = 6000, chance = 8, minDamage = -150, maxDamage = -450, range = 5, effect = CONST_ME_ICEATTACK, target = true},
	{name ="combat", interval = 4000, chance = 11, type = COMBAT_ICEDAMAGE, minDamage = -200, maxDamage = -450, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEATTACK, target = true} -- avalanche
}

monster.defenses = {
	defense = 72,
	armor = 72
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 10},
	{type = COMBAT_FIREDAMAGE, percent = 20},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -15},
	{type = COMBAT_HOLYDAMAGE , percent = -25},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
