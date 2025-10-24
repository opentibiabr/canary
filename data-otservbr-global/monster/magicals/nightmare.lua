local mType = Game.createMonsterType("Nightmare")
local monster = {}

monster.description = "a nightmare"
monster.experience = 1800
monster.outfit = {
	lookType = 245,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 299
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Pits of Inferno, Formorgar Mines, Cemetery Quarter, Edron \z
		(In multiple places during The Inquisition Quest), Alchemist Quarter, Vengoth Castle, Deeper Banuta, Krailos Ruins, Grounds of Deceit.",
}

monster.health = 2700
monster.maxHealth = 2700
monster.race = "blood"
monster.corpse = 6339
monster.speed = 232
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
	{ text = "Close your eyes... I want to show you something.", yell = false },
	{ text = "I will haunt you forever!", yell = false },
	{ text = "Pffffrrrrrrrrrrrr.", yell = false },
	{ text = "I will make you scream.", yell = false },
	{ text = "Take a ride with me.", yell = false },
	{ text = "Weeeheeheeeheee!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 97233, maxCount = 155 }, -- Gold Coin
	{ id = 3582, chance = 30882 }, -- Ham
	{ id = 5944, chance = 21300 }, -- Soul Orb
	{ id = 6558, chance = 28366, maxCount = 2 }, -- Flask of Demonic Blood
	{ id = 10306, chance = 14291 }, -- Essence of a Bad Dream
	{ id = 6499, chance = 9865 }, -- Demonic Essence
	{ id = 10312, chance = 9967 }, -- Scythe Leg
	{ id = 3035, chance = 4080, maxCount = 3 }, -- Platinum Coin
	{ id = 6299, chance = 1451 }, -- Death Ring
	{ id = 3450, chance = 23250, maxCount = 4 }, -- Power Bolt
	{ id = 3432, chance = 1063 }, -- Ancient Shield
	{ id = 3371, chance = 967 }, -- Knight Legs
	{ id = 6525, chance = 404 }, -- Skeleton Decoration
	{ id = 3079, chance = 398 }, -- Boots of Haste
	{ id = 3342, chance = 220 }, -- War Axe
	{ id = 5668, chance = 68 }, -- Mysterious Voodoo Skull
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -150 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -120, maxDamage = -170, range = 7, radius = 1, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -150, maxDamage = -350, range = 7, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },
}

monster.defenses = {
	defense = 25,
	armor = 25,
	mitigation = 0.70,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 60, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 420, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
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
