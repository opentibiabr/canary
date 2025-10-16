local mType = Game.createMonsterType("Naga Warrior")
local monster = {}

monster.description = "a naga warrior"
monster.experience = 5890
monster.outfit = {
	lookType = 1539,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2261
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_AMPHIBIC,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Temple of the Moon Goddess.",
}

monster.health = 5530
monster.maxHealth = 5530
monster.race = "blood"
monster.corpse = 39225
monster.speed = 180
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	{ text = "Fear the wrath of the wronged!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 12 }, -- platinum coin
	{ id = 3267, chance = 80000 }, -- dagger
	{ id = 236, chance = 23000, maxCount = 2 }, -- strong health potion
	{ id = 39412, chance = 23000, maxCount = 2 }, -- naga earring
	{ id = 39414, chance = 23000 }, -- naga warrior scales
	{ id = 3370, chance = 5000 }, -- knight armor
	{ id = 17859, chance = 5000 }, -- spiky club
	{ id = 3357, chance = 5000 }, -- plate armor
	{ id = 3307, chance = 5000 }, -- scimitar
	{ id = 3297, chance = 5000 }, -- serpent sword
	{ id = 3300, chance = 5000 }, -- katana
	{ id = 16120, chance = 5000 }, -- violet crystal shard
	{ id = 39411, chance = 5000 }, -- naga armring
	{ id = 7741, chance = 1000 }, -- ice cube
	{ id = 7383, chance = 260 }, -- relic sword
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_PHYSICALDAMAGE, minDamage = -120, maxDamage = -340, target = true }, -- basic_attack
	{ name = "combat", interval = 2500, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = -320, maxDamage = -430, effect = CONST_ME_YELLOWSMOKE, range = 3, target = true }, -- eruption_strike
	{ name = "nagadeathattack", interval = 3000, chance = 35, minDamage = -360, maxDamage = -415, target = true }, -- death_strike
	{ name = "combat", interval = 3500, chance = 35, type = COMBAT_LIFEDRAIN, minDamage = -360, maxDamage = -386, radius = 4, effect = CONST_ME_DRAWBLOOD, target = false }, -- great_blood_ball
}

monster.defenses = {
	defense = 110,
	armor = 78,
	mitigation = 2.19,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = -5 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
