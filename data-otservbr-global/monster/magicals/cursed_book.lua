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
	{ id = 28569, chance = 80000, maxCount = 4 }, -- book page
	{ id = 3035, chance = 80000, maxCount = 15 }, -- platinum coin
	{ id = 28566, chance = 80000 }, -- silken bookmark
	{ id = 3028, chance = 80000, maxCount = 6 }, -- small diamond
	{ id = 9057, chance = 80000, maxCount = 5 }, -- small topaz
	{ id = 1781, chance = 23000, maxCount = 10 }, -- small stone
	{ id = 3084, chance = 23000 }, -- protection amulet
	{ id = 813, chance = 23000 }, -- terra boots
	{ id = 7387, chance = 23000 }, -- diamond sceptre
	{ id = 830, chance = 5000 }, -- terra hood
	{ id = 812, chance = 5000 }, -- terra legs
	{ id = 814, chance = 5000 }, -- terra amulet
	{ id = 3081, chance = 5000 }, -- stone skin amulet
	{ id = 9302, chance = 5000 }, -- sacred tree amulet
	{ id = 8084, chance = 1000 }, -- springsprout rod
	{ id = 811, chance = 1000 }, -- terra mantle
	{ id = 8052, chance = 260 }, -- swamplair armor
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
