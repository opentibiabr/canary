local mType = Game.createMonsterType("Bonelord")
local monster = {}

monster.description = "a bonelord"
monster.experience = 170
monster.outfit = {
	lookType = 17,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 17
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Ancient Temple, Alatar Lake, Mount Sternum Undead Cave, Desert Dungeon, Hellgate, \z
		Helheim, Fibula Dungeon, Villa Scapula, Hero Cave before Dragons, Eastern Drefia, Folda hidden cave, \z
		Maze of Lost Souls, way to Mintwallin, before Kazordoon city entrance, abandoned building east of Venore, \z
		Green Claw Swamp, north of the Venore Amazon Camp, Below Point of No Return in Outlaw Camp, Vandura Bonelord Cave, \z
		Triangle Tower, Hidden cave north of Port Hope, Deeper Banuta, Dark Cathedral, Shadow Tomb, Ancient Ruins Tomb, \z
		Tarpit Tomb, Mountain Tomb, Peninsula Tomb, Oasis Tomb and beneath Fenrock.",
}

monster.health = 260
monster.maxHealth = 260
monster.race = "venom"
monster.corpse = 5992
monster.speed = 75
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
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
	maxSummons = 6,
	summons = {
		{ name = "Skeleton", chance = 20, interval = 2000, count = 6 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You've got the look!", yell = false },
	{ text = "Let me take a look at you.", yell = false },
	{ text = "Eye for eye!", yell = false },
	{ text = "I've got to look!", yell = false },
	{ text = "Here's looking at you!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 99400, maxCount = 48 }, -- Gold Coin
	{ id = 3285, chance = 8574 }, -- Longsword
	{ id = 3282, chance = 6793 }, -- Morning Star
	{ id = 11512, chance = 5050 }, -- Small Flask of Eyedrops
	{ id = 3059, chance = 5154 }, -- Spellbook
	{ id = 3409, chance = 3799 }, -- Steel Shield
	{ id = 3265, chance = 3758 }, -- Two Handed Sword
	{ id = 5898, chance = 1000 }, -- Bonelord Eye
	{ id = 3065, chance = 590 }, -- Terra Rod
	{ id = 268, chance = 378 }, -- Mana Potion
	{ id = 3418, chance = 110 }, -- Bonelord Shield
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -5 },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_ENERGYDAMAGE, minDamage = -15, maxDamage = -45, range = 7, shootEffect = CONST_ANI_ENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_FIREDAMAGE, minDamage = -25, maxDamage = -45, range = 7, shootEffect = CONST_ANI_FIRE, target = false },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_DEATHDAMAGE, minDamage = -30, maxDamage = -50, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_EARTHDAMAGE, minDamage = -5, maxDamage = -45, range = 7, shootEffect = CONST_ANI_POISON, target = false },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_DEATHDAMAGE, minDamage = -5, maxDamage = -50, range = 7, shootEffect = CONST_ANI_DEATH, target = false },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -45, range = 7, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_MANADRAIN, minDamage = -5, maxDamage = -35, range = 7, target = false },
}

monster.defenses = {
	defense = 5,
	armor = 5,
	mitigation = 0.51,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
