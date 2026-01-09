local mType = Game.createMonsterType("Cursed Book")
local monster = {}

monster.description = "a cursed book"
monster.experience = 13345
monster.outfit = {
	lookType = 1061,
	lookHead = 79,
	lookBody = 81,
	lookLegs = 93,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1655
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Secret Library (earth section).",
}

monster.health = 20000
monster.maxHealth = 20000
monster.race = "ink"
monster.corpse = 28590
monster.speed = 220
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
}

monster.loot = {
	{ id = 28569, chance = 64545, maxCount = 4 }, -- Book Page
	{ id = 3035, chance = 75692, maxCount = 15 }, -- Platinum Coin
	{ id = 28566, chance = 37476 }, -- Silken Bookmark
	{ id = 3028, chance = 49450, maxCount = 6 }, -- Small Diamond
	{ id = 9057, chance = 27017, maxCount = 5 }, -- Small Topaz
	{ id = 1781, chance = 19000, maxCount = 10 }, -- Small Stone
	{ id = 3084, chance = 9180 }, -- Protection Amulet
	{ id = 813, chance = 5190 }, -- Terra Boots
	{ id = 7387, chance = 6667 }, -- Diamond Sceptre
	{ id = 830, chance = 3940 }, -- Terra Hood
	{ id = 812, chance = 1010 }, -- Terra Legs
	{ id = 814, chance = 4040 }, -- Terra Amulet
	{ id = 3081, chance = 2120 }, -- Stone Skin Amulet
	{ id = 9302, chance = 1959 }, -- Sacred Tree Amulet
	{ id = 8084, chance = 740 }, -- Springsprout Rod
	{ id = 811, chance = 670 }, -- Terra Mantle
	{ id = 8052, chance = 180 }, -- Swamplair Armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200 },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -680, range = 7, shootEffect = CONST_ANI_EARTHARROW, target = false },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -400, maxDamage = -575, length = 5, spread = 0, effect = CONST_ME_POISONAREA, target = false },
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_PHYSICALDAMAGE, minDamage = -230, maxDamage = -880, range = 7, radius = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 82,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
