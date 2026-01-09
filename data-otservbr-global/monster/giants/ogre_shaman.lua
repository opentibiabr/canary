local mType = Game.createMonsterType("Ogre Shaman")
local monster = {}

monster.description = "an ogre shaman"
monster.experience = 625
monster.outfit = {
	lookType = 859,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1163
monster.Bestiary = {
	class = "Giant",
	race = BESTY_RACE_GIANT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Krailos Steppe.",
}

monster.health = 800
monster.maxHealth = 800
monster.race = "blood"
monster.corpse = 22139
monster.speed = 105
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
	targetDistance = 4,
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

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "Dworc Fleshhunter", chance = 30, interval = 1000, count = 1 },
		{ name = "Terror Bird", chance = 30, interval = 1000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Stay here, soul food!", yell = false },
	{ text = "You more delicate than clomp!", yell = false },
	{ text = "The spirits hunger!", yell = false },
	{ text = "A sacrifice for Great Hunger!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 90 }, -- Gold Coin
	{ id = 11452, chance = 7380 }, -- Broken Shamanic Staff
	{ id = 22189, chance = 10040 }, -- Ogre Nose Ring
	{ id = 22185, chance = 8820, maxCount = 2 }, -- Prickly Pear
	{ id = 237, chance = 15100 }, -- Strong Mana Potion
	{ id = 3114, chance = 9520 }, -- Skull (Item)
	{ id = 22191, chance = 10949 }, -- Skull Fetish
	{ id = 22188, chance = 14150 }, -- Ogre Ear Stud
	{ id = 22184, chance = 10430 }, -- Shamanic Talisman
	{ id = 3027, chance = 2430 }, -- Black Pearl
	{ id = 3030, chance = 3270, maxCount = 3 }, -- Small Ruby
	{ id = 22194, chance = 1820, maxCount = 2 }, -- Opal
	{ id = 22193, chance = 1340 }, -- Onyx Chip
	{ id = 2901, chance = 2080 }, -- Waterskin
	{ id = 3069, chance = 2330 }, -- Necrotic Rod
	{ id = 17831, chance = 5070 }, -- Bone Fetish
	{ id = 3072, chance = 1899 }, -- Wand of Decay
	{ id = 22192, chance = 860 }, -- Shamanic Mask
	{ id = 2965, chance = 460 }, -- Didgeridoo
	{ id = 22183, chance = 540 }, -- Ogre Scepta
	{ id = 3002, chance = 140 }, -- Voodoo Doll
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -269, condition = { type = CONDITION_FIRE, totalDamage = 6, interval = 9000 } },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -70, maxDamage = -180, range = 7, shootEffect = CONST_ANI_POISON, target = false },
	{ name = "outfit", interval = 2000, chance = 8, range = 7, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 4000, outfitMonster = "chicken" },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -15, maxDamage = -120, length = 8, spread = 0, effect = CONST_ME_CARNIPHILA, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 30,
	mitigation = 1.04,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 80, maxDamage = 95, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
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
