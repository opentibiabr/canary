local mType = Game.createMonsterType("Wailing Widow")
local monster = {}

monster.description = "a wailing widow"
monster.experience = 450
monster.outfit = {
	lookType = 347,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 632
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Zao Wailing Widow Cave, Northern Zao Plantations, Northern Brimstone Bug Cave, \z
		Razzachai, Chyllfroest, Krailos Spider Lair.",
}

monster.health = 850
monster.maxHealth = 850
monster.race = "venom"
monster.corpse = 10393
monster.speed = 127
monster.manaCost = 0

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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
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
	{ id = 3031, chance = 80000, maxCount = 140 }, -- gold coin
	{ id = 10411, chance = 23000 }, -- widows mandibles
	{ id = 268, chance = 5000 }, -- mana potion
	{ id = 266, chance = 5000 }, -- health potion
	{ id = 3269, chance = 5000 }, -- halberd
	{ id = 3732, chance = 5000 }, -- green mushroom
	{ id = 3410, chance = 5000 }, -- plate shield
	{ id = 10406, chance = 5000 }, -- zaoan halberd
	{ id = 10412, chance = 1000 }, -- wailing widows necklace
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -120, condition = { type = CONDITION_POISON, totalDamage = 160, interval = 4000 } },
	{ name = "drunk", interval = 2000, chance = 20, range = 7, radius = 4, effect = CONST_ME_SOUND_RED, target = false, duration = 4000 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -40, maxDamage = -70, radius = 3, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -60, maxDamage = -110, range = 7, shootEffect = CONST_ANI_POISON, target = false },
}

monster.defenses = {
	defense = 0,
	armor = 0,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 70, maxDamage = 100, effect = CONST_ME_SOUND_WHITE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 820, effect = CONST_ME_SOUND_YELLOW, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
