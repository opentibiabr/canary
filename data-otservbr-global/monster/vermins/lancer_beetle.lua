local mType = Game.createMonsterType("Lancer Beetle")
local monster = {}

monster.description = "a lancer beetle"
monster.experience = 275
monster.outfit = {
	lookType = 348,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 633
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Zao Wailing Widow Cave, Muggy Plains (during raid), Razzachai, \z
		Northern Zao Plantations, Northern Brimstone Bug Cave, Chyllfroest.",
}

monster.health = 400
monster.maxHealth = 400
monster.race = "venom"
monster.corpse = 10458
monster.speed = 133
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 30,
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
	{ text = "Crump!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 130 }, -- gold coin
	{ id = 10455, chance = 23000 }, -- lancer beetle shell
	{ id = 9640, chance = 23000 }, -- poisonous slime
	{ id = 9692, chance = 5000 }, -- lump of dirt
	{ id = 10457, chance = 1000 }, -- beetle necklace
	{ id = 3033, chance = 260 }, -- small amethyst
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -115 },
	{ name = "poisonfield", interval = 2000, chance = 10, radius = 4, effect = CONST_ME_POISONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -90, length = 7, spread = 3, effect = CONST_ME_HITBYPOISON, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -40, maxDamage = -80, range = 7, shootEffect = CONST_ANI_POISON, target = false },
	{ name = "lancer beetle curse", interval = 2000, chance = 5, range = 5, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 35,
	mitigation = 0.70,
	{ name = "invisible", interval = 2000, chance = 10, effect = CONST_ME_GROUNDSHAKER },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
