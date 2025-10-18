local mType = Game.createMonsterType("Vicious Manbat")
local monster = {}

monster.description = "a vicious manbat"
monster.experience = 1200
monster.outfit = {
	lookType = 554,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 959
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 5,
	FirstUnlock = 2,
	SecondUnlock = 3,
	CharmsPoints = 50,
	Stars = 3,
	Occurrence = 3,
	Locations = "Deep under Drefia.",
}

monster.health = 1700
monster.maxHealth = 1700
monster.race = "blood"
monster.corpse = 18949
monster.speed = 105
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	isPreyExclusive = true,
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
	{ id = 3031, chance = 100000, maxCount = 163 }, -- Gold Coin
	{ id = 236, chance = 8780 }, -- Strong Health Potion
	{ id = 237, chance = 9920 }, -- Strong Mana Potion
	{ id = 9685, chance = 7630 }, -- Vampire Teeth
	{ id = 3030, chance = 9160, maxCount = 2 }, -- Small Ruby
	{ id = 11449, chance = 5340 }, -- Blood Preservation
	{ id = 18924, chance = 10310 }, -- Tooth File
	{ id = 5894, chance = 4200 }, -- Bat Wing
	{ id = 3010, chance = 1150 }, -- Emerald Bangle
	{ id = 3081, chance = 1000 }, -- Stone Skin Amulet
	{ id = 3039, chance = 760 }, -- Red Gem
	{ id = 3434, chance = 760 }, -- Vampire Shield
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -215 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -250, radius = 3, effect = CONST_ME_HITAREA, target = false },
	{ name = "speed", interval = 2000, chance = 15, radius = 1, effect = CONST_ME_BATS, target = true },
	-- bleed
	{ name = "condition", type = CONDITION_BLEEDING, interval = 2000, chance = 20, minDamage = -400, maxDamage = -600, radius = 2, effect = CONST_ME_DRAWBLOOD, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 44,
	mitigation = 1.21,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
