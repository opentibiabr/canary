local mType = Game.createMonsterType("Moohtant")
local monster = {}

monster.description = "a moohtant"
monster.experience = 2600
monster.outfit = {
	lookType = 607,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1044
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Oramond Mountain Hideout, Oramond Minotaur Camp (northern camp), \z
		Underground Glooth Factory, Oramond Dungeon.",
}

monster.health = 3200
monster.maxHealth = 3200
monster.race = "blood"
monster.corpse = 20996
monster.speed = 130
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 3,
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
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 195 }, -- Gold Coin
	{ id = 3035, chance = 55060, maxCount = 2 }, -- Platinum Coin
	{ id = 21200, chance = 15360, maxCount = 2 }, -- Moohtant Horn
	{ id = 21199, chance = 11090 }, -- Giant Pacifier
	{ id = 239, chance = 9060, maxCount = 3 }, -- Great Health Potion
	{ id = 238, chance = 8870, maxCount = 3 }, -- Great Mana Potion
	{ id = 3577, chance = 7220 }, -- Meat
	{ id = 3030, chance = 5070, maxCount = 2 }, -- Small Ruby
	{ id = 3028, chance = 4960, maxCount = 2 }, -- Small Diamond
	{ id = 5878, chance = 4850 }, -- Minotaur Leather
	{ id = 3098, chance = 2559 }, -- Ring of Healing
	{ id = 5911, chance = 2410 }, -- Red Piece of Cloth
	{ id = 21173, chance = 960 }, -- Moohtant Cudgel
	{ id = 3039, chance = 880 }, -- Red Gem
	{ id = 7452, chance = 780 }, -- Spiked Squelcher
	{ id = 3037, chance = 820 }, -- Yellow Gem
	{ id = 9058, chance = 460 }, -- Gold Ingot
	{ id = 7427, chance = 420 }, -- Chaos Mace
	{ id = 7401, chance = 340 }, -- Minotaur Trophy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 110, attack = 50 },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -230, length = 3, spread = 0, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -200, radius = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 2000, chance = 19, type = COMBAT_LIFEDRAIN, minDamage = -50, maxDamage = -225, radius = 5, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -150, maxDamage = -235, range = 7, radius = 4, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_EXPLOSIONAREA, target = true },
}

monster.defenses = {
	defense = 45,
	armor = 40,
	{ name = "combat", interval = 2000, chance = 9, type = COMBAT_HEALING, minDamage = 50, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
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
