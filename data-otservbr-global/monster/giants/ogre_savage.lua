local mType = Game.createMonsterType("Ogre Savage")
local monster = {}

monster.description = "an ogre savage"
monster.experience = 950
monster.outfit = {
	lookType = 858,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1162
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

monster.health = 1400
monster.maxHealth = 1400
monster.race = "blood"
monster.corpse = 22147
monster.speed = 110
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
	{ text = "You tasty!", yell = false },
	{ text = "Must! Chop! Food! Raahh!", yell = false },
	{ text = "UGGA UGGA!!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 99520, maxCount = 154 }, -- Gold Coin
	{ id = 3598, chance = 8230, maxCount = 5 }, -- Cookie
	{ id = 22188, chance = 19520 }, -- Ogre Ear Stud
	{ id = 22191, chance = 9520 }, -- Skull Fetish
	{ id = 3078, chance = 6370 }, -- Mysterious Fetish
	{ id = 236, chance = 15210 }, -- Strong Health Potion
	{ id = 22189, chance = 17550 }, -- Ogre Nose Ring
	{ id = 22193, chance = 2970, maxCount = 2 }, -- Onyx Chip
	{ id = 3030, chance = 2830, maxCount = 3 }, -- Small Ruby
	{ id = 3279, chance = 1250 }, -- War Hammer
	{ id = 8016, chance = 3600, maxCount = 2 }, -- Jalapeno Pepper
	{ id = 22194, chance = 2090 }, -- Opal
	{ id = 9057, chance = 2970, maxCount = 2 }, -- Small Topaz
	{ id = 22172, chance = 1110 }, -- Ogre Choppa
	{ id = 7439, chance = 450 }, -- Berserk Potion
	{ id = 22192, chance = 430 }, -- Shamanic Mask
	{ id = 7419, chance = 20 }, -- Dreaded Cleaver
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -269, condition = { type = CONDITION_FIRE, totalDamage = 6, interval = 9000 } },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -70, maxDamage = -180, range = 7, shootEffect = CONST_ANI_POISON, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 32,
	mitigation = 1.18,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 80, maxDamage = 95, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
