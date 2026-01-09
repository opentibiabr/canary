local mType = Game.createMonsterType("Mooh'Tah Warrior")
local monster = {}

monster.description = "a mooh'tah warrior"
monster.experience = 900
monster.outfit = {
	lookType = 611,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1051
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Oramond/Southern Plains, Minotaur Hills, \z
		Oramond Dungeon (depending on Magistrate votes), Underground Glooth Factory.",
}

monster.health = 1200
monster.maxHealth = 1200
monster.race = "blood"
monster.corpse = 21091
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 4,
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
	{ text = "Feel the power of the Mooh'Tah!", yell = false },
	{ text = "Ommm!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 120 }, -- Gold Coin
	{ id = 3035, chance = 40120, maxCount = 3 }, -- Platinum Coin
	{ id = 21202, chance = 15067 }, -- Mooh'tah Shell
	{ id = 237, chance = 7211 }, -- Strong Mana Potion
	{ id = 236, chance = 7151 }, -- Strong Health Potion
	{ id = 5878, chance = 5038 }, -- Minotaur Leather
	{ id = 3030, chance = 4969 }, -- Small Ruby
	{ id = 3032, chance = 5004 }, -- Small Emerald
	{ id = 3033, chance = 5116 }, -- Small Amethyst
	{ id = 9057, chance = 4972 }, -- Small Topaz
	{ id = 11472, chance = 4994, maxCount = 2 }, -- Minotaur Horn
	{ id = 21177, chance = 1463 }, -- Cowtana
	{ id = 3091, chance = 1030 }, -- Sword Ring
	{ id = 21166, chance = 994 }, -- Mooh'tah Plate
	{ id = 3415, chance = 898 }, -- Guardian Shield
	{ id = 3371, chance = 764 }, -- Knight Legs
	{ id = 5911, chance = 771 }, -- Red Piece of Cloth
	{ id = 3370, chance = 536 }, -- Knight Armor
	{ id = 7401, chance = 133 }, -- Minotaur Trophy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 45, attack = 80 },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_ENERGYDAMAGE, minDamage = -150, maxDamage = -200, length = 4, spread = 0, effect = CONST_ME_YELLOWENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 11, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -135, range = 7, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -50, maxDamage = -150, radius = 3, effect = CONST_ME_HITAREA, target = false },
	{ name = "mooh'tah master skill reducer", interval = 2000, chance = 19, range = 7, target = false },
}

monster.defenses = {
	defense = 37,
	armor = 37,
	mitigation = 1.35,
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_HEALING, minDamage = 110, maxDamage = 160, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "haste", interval = 2000, chance = 8, speedChange = 220, effect = CONST_ME_MAGIC_RED, target = false, duration = 1000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
