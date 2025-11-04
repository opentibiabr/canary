local mType = Game.createMonsterType("Blood Crab")
local monster = {}

monster.description = "a blood crab"
monster.experience = 160
monster.outfit = {
	lookType = 200,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 261
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Goroma (beyond electric barrier), Laguna Islands, Shattered Isles, Underground Port Hope, \z
		Mistrock, Treasure Island. There is also one underwater next to The Tibianic, however it is unreachable.",
}

monster.health = 290
monster.maxHealth = 290
monster.race = "blood"
monster.corpse = 6075
monster.speed = 80
monster.manaCost = 505

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
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
	{ id = 3031, chance = 85770, maxCount = 20 }, -- Gold Coin
	{ id = 3578, chance = 17658 }, -- Fish
	{ id = 3358, chance = 5510 }, -- Chain Armor
	{ id = 3372, chance = 1858 }, -- Brass Legs
	{ id = 9633, chance = 6005 }, -- Bloody Pincers
	{ id = 3026, chance = 514 }, -- White Pearl
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -110, effect = CONST_ME_DRAWBLOOD },
}

monster.defenses = {
	defense = 28,
	armor = 28,
	mitigation = 0.46,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
