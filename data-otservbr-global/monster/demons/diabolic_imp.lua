local mType = Game.createMonsterType("Diabolic Imp")
local monster = {}

monster.description = "a diabolic imp"
monster.experience = 2900
monster.outfit = {
	lookType = 237,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 288
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Inquisition, Pits of Inferno, Fenrock, Fury Dungeon and inside the Hellgore volcano \z
	on Goroma during the Fire from the Earth Mini World Change.",
}

monster.health = 1950
monster.maxHealth = 1950
monster.race = "fire"
monster.corpse = 6363
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
	runHealth = 400,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "Muahaha!", yell = false },
	{ text = "He he he.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 99380, maxCount = 200 }, -- Gold Coin
	{ id = 3451, chance = 51133 }, -- Pitchfork
	{ id = 6558, chance = 30192, maxCount = 2 }, -- Flask of Demonic Blood
	{ id = 3147, chance = 18603, maxCount = 2 }, -- Blank Rune
	{ id = 3471, chance = 8341 }, -- Cleaver
	{ id = 3415, chance = 8794 }, -- Guardian Shield
	{ id = 6499, chance = 7977 }, -- Demonic Essence
	{ id = 5944, chance = 6905 }, -- Soul Orb
	{ id = 3307, chance = 6111 }, -- Scimitar
	{ id = 3035, chance = 6253, maxCount = 7 }, -- Platinum Coin
	{ id = 3049, chance = 2374 }, -- Stealth Ring
	{ id = 3033, chance = 3725, maxCount = 3 }, -- Small Amethyst
	{ id = 3275, chance = 1322 }, -- Double Axe
	{ id = 3069, chance = 575 }, -- Necrotic Rod
	{ id = 827, chance = 516 }, -- Magma Monocle
	{ id = 826, chance = 345 }, -- Magma Coat
	{ id = 6299, chance = 191 }, -- Death Ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -240, condition = { type = CONDITION_POISON, totalDamage = 160, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -240, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -430, range = 7, radius = 2, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREATTACK, target = true },
	{ name = "diabolic imp skill reducer", interval = 2000, chance = 5, range = 5, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 29,
	mitigation = 1.46,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 650, maxDamage = 800, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 800, effect = CONST_ME_MAGIC_RED, target = false, duration = 2000 },
	{ name = "invisible", interval = 2000, chance = 10, effect = CONST_ME_TELEPORT },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
