local mType = Game.createMonsterType("Elder Forest Fury")
local monster = {}

monster.description = "a elder forest fury"
monster.experience = 330
monster.outfit = {
	lookType = 569,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 980
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Dryad Gardens"
	}

monster.health = 670
monster.maxHealth = 670
monster.race = "blood"
monster.corpse = 19042
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 80,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "To arms, sisters!", yell = false},
	{text = "Feel the wrath of mother forest!", yell = false},
	{text = "By the power of Greenskull!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 90310, maxCount = 68},
	{name = "crossbow", chance = 3400},
	{name = "bolt", chance = 45410, maxCount = 15},
	{name = "meat", chance = 22110},
	{name = "piercing bolt", chance = 16500, maxCount = 5},
	{name = "raspberry", chance = 850, maxCount = 3},
	{name = "hunting spear", chance = 8160, maxCount = 2},
	{name = "elvish bow", chance = 90},
	{name = "small emerald", chance = 2720},
	{name = "elven hoof", chance = 12590},
	{name = "terra rod", chance = 510},
	{name = "bullseye potion", chance = 510},
	{name = "venison", chance = 18540}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100},
	{name ="combat", interval = 1500, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -136, range = 7, radius = 4, shootEffect = CONST_ANI_HUNTINGSPEAR, effect = CONST_ME_MAGIC_GREEN, target = true},
	{name ="forest fury skill reducer", interval = 2000, chance = 20, range = 5, target = false}
}

monster.defenses = {
	defense = 20,
	armor = 25
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = -5},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 10},
	{type = COMBAT_DEATHDAMAGE , percent = 40}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
