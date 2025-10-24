local mType = Game.createMonsterType("Spit Nettle")
local monster = {}

monster.description = "a spit nettle"
monster.experience = 20
monster.outfit = {
	lookType = 221,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 221
monster.Bestiary = {
	class = "Plant",
	race = BESTY_RACE_PLANT,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Tiquanda, Trapwood, the outskirts of Chor and Forbidden Lands, Alchemist Quarter in Yalahar, \z
		Tiquanda Laboratory.",
}

monster.health = 150
monster.maxHealth = 150
monster.race = "venom"
monster.corpse = 6062
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20,
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
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
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
	{ id = 3031, chance = 13372, maxCount = 5 }, -- Gold Coin
	{ id = 3740, chance = 11158 }, -- Shadow Herb
	{ id = 11476, chance = 9920 }, -- Nettle Spit
	{ id = 3738, chance = 5244, maxCount = 2 }, -- Sling Herb
	{ id = 3661, chance = 1074 }, -- Grave Flower
	{ id = 10314, chance = 1013 }, -- Nettle Blossom
	{ id = 647, chance = 340 }, -- Seeds
}

monster.attacks = {
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -15, maxDamage = -40, range = 7, shootEffect = CONST_ANI_POISON, target = true },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 15, minDamage = -40, maxDamage = -100, range = 7, shootEffect = CONST_ANI_POISON, target = true },
}

monster.defenses = {
	defense = 0,
	armor = 12,
	mitigation = 0.86,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 8, maxDamage = 16, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
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
