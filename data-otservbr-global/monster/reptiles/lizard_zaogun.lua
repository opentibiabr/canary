local mType = Game.createMonsterType("Lizard Zaogun")
local monster = {}

monster.description = "a lizard zaogun"
monster.experience = 1700
monster.outfit = {
	lookType = 343,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 616
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Zzaion, Zao Palace, Muggy Plains, Zao Orc Land (in fort), Razzachai, Temple of Equilibrium.",
}

monster.health = 2955
monster.maxHealth = 2955
monster.race = "blood"
monster.corpse = 10367
monster.speed = 138
monster.manaCost = 0

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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
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
	{ text = "Hissss!", yell = false },
	{ text = "Cowardzz!", yell = false },
	{ text = "Softzzkinzz from zze zzouzz!", yell = false },
	{ text = "Zztand and fight!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 94000, maxCount = 268 }, -- Gold Coin
	{ id = 3035, chance = 50000, maxCount = 2 }, -- Platinum Coin
	{ id = 10414, chance = 15000 }, -- Zaogun Shoulderplates
	{ id = 5876, chance = 14700 }, -- Lizard Leather
	{ id = 5881, chance = 12000 }, -- Lizard Scale
	{ id = 10413, chance = 8400 }, -- Zaogun Flag
	{ id = 239, chance = 7100, maxCount = 3 }, -- Great Health Potion
	{ id = 3032, chance = 5000, maxCount = 5 }, -- Small Emerald
	{ id = 10289, chance = 2100 }, -- Red Lantern
	{ id = 236, chance = 2000 }, -- Strong Health Potion
	{ id = 10386, chance = 1100 }, -- Zaoan Shoes
	{ id = 3428, chance = 1000 }, -- Tower Shield
	{ id = 10387, chance = 910 }, -- Zaoan Legs
	{ id = 10384, chance = 540 }, -- Zaoan Armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -349 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -220, maxDamage = -375, range = 7, radius = 1, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },
}

monster.defenses = {
	defense = 40,
	armor = 42,
	mitigation = 1.37,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 175, maxDamage = 275, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 45 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
