local mType = Game.createMonsterType("Hellhunter Inferniarch")
local monster = {}

monster.description = "a hellhunter inferniarch"
monster.experience = 8100
monster.outfit = {
	lookType = 1793,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2600
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Azzilon Castle Catacombs.",
}

monster.health = 11300
monster.maxHealth = 11300
monster.race = "fire"
monster.corpse = 49994
monster.speed = 175
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Ardash... El...!", yell = true },
	{ text = "Urrrglll!", yell = true },
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 35 }, -- Platinum Coin
	{ id = 3033, chance = 7000, maxCount = 4 }, -- Small Amethyst
	{ id = 7365, chance = 10400, maxCount = 5 }, -- Onyx Arrow
	{ id = 7368, chance = 8530, maxCount = 10 }, -- Assassin Star
	{ id = 3384, chance = 2009 }, -- Dark Helmet
	{ id = 6299, chance = 1050 }, -- Death Ring
	{ id = 7364, chance = 2740, maxCount = 5 }, -- Sniper Arrow
	{ id = 16125, chance = 4220 }, -- Cyan Crystal Fragment
	{ id = 49909, chance = 2869 }, -- Demonic Core Essence
	{ id = 49894, chance = 680 }, -- Demonic Matter
	{ id = 49908, chance = 1050 }, -- Mummified Demon Finger
	{ id = 50055, chance = 500 }, -- Hellhunter Eye
	{ id = 8027, chance = 70 }, -- Composite Hornbow
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -219, maxDamage = -261, range = 4, shootEffect = CONST_ANI_BOLT, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = {
	defense = 15,
	armor = 73,
	mitigation = 2.19,
}

monster.elements = {
	{ type = COMBAT_DEATHDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
