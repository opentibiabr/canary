local mType = Game.createMonsterType("Ogre Ruffian")
local monster = {}

monster.description = "an ogre ruffian"
monster.experience = 5000
monster.outfit = {
	lookType = 1212,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1820
monster.Bestiary = {
	class = "Giant",
	race = BESTY_RACE_GIANT,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Kilmaresh Central Steppe, Kilmaresh Southern Steppe, Green Belt, Kilmaresh Mountains underground.",
}

monster.health = 5500
monster.maxHealth = 5500
monster.race = "blood"
monster.corpse = 31527
monster.speed = 215
monster.manaCost = 0

monster.faction = FACTION_ANUMA
monster.enemyFactions = { FACTION_PLAYER, FACTION_FAFNAR }

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
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
	staticAttackChance = 70,
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
}

monster.loot = {
	{ id = 3035, chance = 75000, maxCount = 4 }, -- Platinum Coin
	{ id = 3029, chance = 18400, maxCount = 2 }, -- Small Sapphire
	{ id = 22188, chance = 17900 }, -- Ogre Ear Stud
	{ id = 3577, chance = 15700, maxCount = 2 }, -- Meat
	{ id = 22189, chance = 14600 }, -- Ogre Nose Ring
	{ id = 16125, chance = 6900 }, -- Cyan Crystal Fragment
	{ id = 3032, chance = 5700 }, -- Small Emerald
	{ id = 7387, chance = 4800 }, -- Diamond Sceptre
	{ id = 22191, chance = 3300 }, -- Skull Fetish
	{ id = 3279, chance = 3200 }, -- War Hammer
	{ id = 22193, chance = 2700 }, -- Onyx Chip
	{ id = 3037, chance = 2700 }, -- Yellow Gem
	{ id = 3039, chance = 2300 }, -- Red Gem
	{ id = 21169, chance = 2000 }, -- Metal Spats
	{ id = 17828, chance = 1700 }, -- Pair of Iron Fists
	{ id = 16122, chance = 1200 }, -- Green Crystal Splinter
	{ id = 22171, chance = 1100 }, -- Ogre Klubba
	{ id = 3081, chance = 870 }, -- Stone Skin Amulet
	{ id = 677, chance = 870, maxCount = 2 }, -- Small Enchanted Emerald
	{ id = 3041, chance = 740 }, -- Blue Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -450, radius = 5, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -350, range = 4, radius = 5, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_POFF, target = true },
}

monster.defenses = {
	defense = 102,
	armor = 102,
	mitigation = 2.72,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
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
