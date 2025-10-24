local mType = Game.createMonsterType("Nightmare Scion")
local monster = {}

monster.description = "a nightmare scion"
monster.experience = 1350
monster.outfit = {
	lookType = 321,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 518
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Cemetery Quarter, Alchemist Quarter and in the Arena and Zoo Quarter (unreachable), \z
		Vengoth Castle, Formorgar Mines, Lower Spike, Robson Isle (single respawn), Krailos Ruins.",
}

monster.health = 1400
monster.maxHealth = 1400
monster.race = "blood"
monster.corpse = 9005
monster.speed = 220
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 300,
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
	{ text = "Weeeheeheee!", yell = false },
	{ text = "Pffffrrrrrrrrrrrr.", yell = false },
	{ text = "Peak a boo, I killed you!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 97000, maxCount = 155 }, -- Gold Coin
	{ id = 3577, chance = 64161, maxCount = 4 }, -- Meat
	{ id = 10306, chance = 7374 }, -- Essence of a Bad Dream
	{ id = 10312, chance = 5552 }, -- Scythe Leg
	{ id = 3035, chance = 2216, maxCount = 3 }, -- Platinum Coin
	{ id = 3385, chance = 711 }, -- Crown Helmet
	{ id = 6574, chance = 196 }, -- Bar of Chocolate
	{ id = 9027, chance = 134 }, -- Crystal of Focus
	{ id = 6299, chance = 330 }, -- Death Ring
	{ id = 7387, chance = 486 }, -- Diamond Sceptre
	{ id = 8043, chance = 211 }, -- Focus Cape
	{ id = 7451, chance = 222 }, -- Shadow Sceptre
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -140 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -115, maxDamage = -180, range = 7, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -70, maxDamage = -130, range = 7, radius = 1, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = true },
}

monster.defenses = {
	defense = 20,
	armor = 25,
	mitigation = 0.70,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 60, maxDamage = 95, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
