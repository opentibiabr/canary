local mType = Game.createMonsterType("Minotaur Guard")
local monster = {}

monster.description = "a minotaur guard"
monster.experience = 160
monster.outfit = {
	lookType = 29,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 29
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Ancient Temple, Mintwallin, Minotaur Pyramid, Maze of Lost Souls, Folda, Cyclopolis, \z
		Deeper Fibula Dungeon (level 50+ to open the door), Hero Cave, underground of Elvenbane, \z
		Plains of Havoc, Kazordoon Minotaur Cave, Foreigner Quarter.",
}

monster.health = 185
monster.maxHealth = 185
monster.race = "blood"
monster.corpse = 5983
monster.speed = 95
monster.manaCost = 550

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 20,
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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Kirrl Karrrl!", yell = false },
	{ text = "Kaplar", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 59730, maxCount = 20 }, -- Gold Coin
	{ id = 11472, chance = 8170, maxCount = 2 }, -- Minotaur Horn
	{ id = 3413, chance = 1889 }, -- Battle Shield
	{ id = 11482, chance = 4980 }, -- Piece of Warrior Armor
	{ id = 3359, chance = 4156 }, -- Brass Armor
	{ id = 3358, chance = 3091 }, -- Chain Armor
	{ id = 3483, chance = 4400 }, -- Fishing Rod
	{ id = 5878, chance = 875 }, -- Minotaur Leather
	{ id = 3275, chance = 336 }, -- Double Axe
	{ id = 266, chance = 323 }, -- Health Potion
	{ id = 7401, chance = 91 }, -- Minotaur Trophy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100 },
}

monster.defenses = {
	defense = 20,
	armor = 15,
	mitigation = 0.83,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
