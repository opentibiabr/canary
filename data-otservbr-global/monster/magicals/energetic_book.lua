local mType = Game.createMonsterType("Energetic Book")
local monster = {}

monster.description = "an energetic book"
monster.experience = 12034
monster.outfit = {
	lookType = 1061,
	lookHead = 15,
	lookBody = 91,
	lookLegs = 85,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1665
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Secret Library (energy section).",
}

monster.health = 18500
monster.maxHealth = 18500
monster.race = "ink"
monster.corpse = 28778
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Flood the room with curious energy!", yell = false },
	{ text = "zup zup zup zuuuuup!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 77282, maxCount = 35 }, -- Platinum Coin
	{ id = 28569, chance = 51243, maxCount = 8 }, -- Book Page
	{ id = 28570, chance = 67031, maxCount = 6 }, -- Glowing Rune
	{ id = 7643, chance = 10558 }, -- Ultimate Health Potion
	{ id = 23373, chance = 19937 }, -- Ultimate Mana Potion
	{ id = 23523, chance = 12680 }, -- Energy Ball
	{ id = 28566, chance = 11142 }, -- Silken Bookmark
	{ id = 816, chance = 3603 }, -- Lightning Pendant
	{ id = 820, chance = 3389 }, -- Lightning Boots
	{ id = 822, chance = 811 }, -- Lightning Legs
	{ id = 828, chance = 2532 }, -- Lightning Headband
	{ id = 16096, chance = 3373 }, -- Wand of Defiance
	{ id = 10438, chance = 1359 }, -- Spellweaver's Robe
	{ id = 7407, chance = 702 }, -- Haunted Blade
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200 },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -680, range = 7, shootEffect = CONST_ANI_ENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -505, radius = 3, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 1500, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -700, length = 8, spread = 0, effect = CONST_ME_STUN, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 82,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
