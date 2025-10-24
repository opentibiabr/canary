local mType = Game.createMonsterType("Ashmunrah")
local monster = {}

monster.description = "Ashmunrah"
monster.experience = 3100
monster.outfit = {
	lookType = 91,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 91,
	bossRace = RARITY_BANE,
}

monster.health = 5000
monster.maxHealth = 5000
monster.race = "undead"
monster.corpse = 6031
monster.speed = 215
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
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
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 4,
	summons = {
		{ name = "Ancient Scarab", chance = 100, interval = 1000, count = 2 },
		{ name = "Green Djinn", chance = 100, interval = 1000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "No mortal or undead will steal my secrets!", yell = false },
	{ text = "Ahhhh all those long years.", yell = false },
	{ text = "My traitorous son has thee.", yell = false },
	{ text = "Come to me, my allys and underlings.", yell = false },
	{ text = "I might be trapped but not without power", yell = false },
	{ text = "Ages come, ages go. Ashmunrah remains.", yell = false },
	{ text = "You will be history soon.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 93870, maxCount = 319 }, -- Gold Coin
	{ id = 238, chance = 11970 }, -- Great Mana Potion
	{ id = 3017, chance = 4330 }, -- Silver Brooch
	{ id = 3048, chance = 4670 }, -- Might Ring
	{ id = 3381, chance = 450 }, -- Crown Armor
	{ id = 10290, chance = 170 }, -- Mini Mummy
	{ id = 3023, chance = 110 }, -- Holy Scarab
	{ id = 3332, chance = 110 }, -- Hammer of Wrath
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1000, condition = { type = CONDITION_POISON, totalDamage = 55, interval = 4000 } },
	{ name = "combat", interval = 3000, chance = 7, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -700, range = 1, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_EARTHDAMAGE, minDamage = -100, maxDamage = -500, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false },
	{ name = "combat", interval = 3000, chance = 12, type = COMBAT_PHYSICALDAMAGE, minDamage = -120, maxDamage = -750, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_MORTAREA, target = false },
	{ name = "speed", interval = 3000, chance = 25, speedChange = -650, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 50000 },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_LIFEDRAIN, minDamage = -50, maxDamage = -550, length = 8, spread = 3, effect = CONST_ME_YELLOW_RINGS, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 25,
	--	mitigation = ???,
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 400, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 1000, chance = 7, effect = CONST_ME_MAGIC_BLUE },
	{ name = "outfit", interval = 1000, chance = 3, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 6000, outfitMonster = "ancient scarab" },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 25 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
