local mType = Game.createMonsterType("Burning Book")
local monster = {}

monster.description = "a burning book"
monster.experience = 13200
monster.outfit = {
	lookType = 1061,
	lookHead = 79,
	lookBody = 113,
	lookLegs = 78,
	lookFeet = 112,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1663
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Secret Library (fire section).",
}

monster.health = 18000
monster.maxHealth = 18000
monster.race = "ink"
monster.corpse = 28754
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
	{ id = 3035, chance = 62000, maxCount = 35 }, -- Platinum Coin
	{ id = 28569, chance = 49000, maxCount = 4 }, -- Book Page
	{ id = 6558, chance = 42000 }, -- Flask of Demonic Blood
	{ id = 28566, chance = 19700 }, -- Silken Bookmark
	{ id = 6499, chance = 18900 }, -- Demonic Essence
	{ id = 826, chance = 11900 }, -- Magma Coat
	{ id = 3415, chance = 9400 }, -- Guardian Shield
	{ id = 3033, chance = 5400, maxCount = 7 }, -- Small Amethyst
	{ id = 5944, chance = 5100 }, -- Soul Orb
	{ id = 3307, chance = 4400 }, -- Scimitar
	{ id = 3069, chance = 3600 }, -- Necrotic Rod
	{ id = 6299, chance = 2300 }, -- Death Ring
	{ id = 827, chance = 1400 }, -- Magma Monocle
	{ id = 3049, chance = 770 }, -- Stealth Ring
	{ id = 7451, chance = 410 }, -- Shadow Sceptre
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -700 },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -780, range = 7, shootEffect = CONST_ANI_FLAMMINGARROW, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 1500, chance = 12, type = COMBAT_PHYSICALDAMAGE, minDamage = -500, maxDamage = -900, radius = 3, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -400, maxDamage = -850, length = 5, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_FIREDAMAGE, minDamage = -400, maxDamage = -775, radius = 3, effect = CONST_ME_HITBYFIRE, target = false },
}

monster.defenses = {
	defense = 33,
	armor = 82,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
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
