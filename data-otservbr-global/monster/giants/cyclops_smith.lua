local mType = Game.createMonsterType("Cyclops Smith")
local monster = {}

monster.description = "a cyclops smith"
monster.experience = 255
monster.outfit = {
	lookType = 277,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 389
monster.Bestiary = {
	class = "Giant",
	race = BESTY_RACE_GIANT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Cyclopolis second floor and below, Mistrock, Mount Sternum, \z
		Cyclops Camp second floor and in the Cyclops version of the Forsaken Mine.",
}

monster.health = 435
monster.maxHealth = 435
monster.race = "blood"
monster.corpse = 656
monster.speed = 102
monster.manaCost = 695

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
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 95,
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
	{ text = "Outis emoi g' onoma.", yell = false },
	{ text = "Whack da humy!", yell = false },
	{ text = "Ai humy phary ty kaynon", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 70 }, -- gold coin
	{ id = 3577, chance = 80000 }, -- meat
	{ id = 3413, chance = 23000 }, -- battle shield
	{ id = 9657, chance = 23000 }, -- cyclops toe
	{ id = 3266, chance = 5000 }, -- battle axe
	{ id = 3305, chance = 5000 }, -- battle hammer
	{ id = 3330, chance = 5000 }, -- heavy machete
	{ id = 3410, chance = 5000 }, -- plate shield
	{ id = 3275, chance = 1000 }, -- double axe
	{ id = 236, chance = 1000 }, -- strong health potion
	{ id = 3384, chance = 260 }, -- dark helmet
	{ id = 7452, chance = 260 }, -- spiked squelcher
	{ id = 7398, chance = 260 }, -- cyclops trophy
	{ id = 3093, chance = 260 }, -- club ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -150 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -70, range = 7, shootEffect = CONST_ANI_WHIRLWINDCLUB, target = false },
	{ name = "drunk", interval = 2000, chance = 10, shootEffect = CONST_ANI_WHIRLWINDCLUB, effect = CONST_ME_STUN, target = false, duration = 4000 },
}

monster.defenses = {
	defense = 25,
	armor = 28,
	mitigation = 0.96,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
