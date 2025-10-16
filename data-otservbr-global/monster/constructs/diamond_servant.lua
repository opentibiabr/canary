local mType = Game.createMonsterType("Diamond Servant")
local monster = {}

monster.description = "a diamond servant"
monster.experience = 700
monster.outfit = {
	lookType = 397,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 702
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 5,
	FirstUnlock = 2,
	SecondUnlock = 3,
	CharmsPoints = 50,
	Stars = 3,
	Occurrence = 3,
	Locations = "Edron.",
}

monster.health = 1000
monster.maxHealth = 1000
monster.race = "venom"
monster.corpse = 12496
monster.speed = 86
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 100,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
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
	{ text = "Error. LOAD 'PROGRAM',8,1", yell = false },
	{ text = "Remain. Obedient.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 179 }, -- gold coin
	{ id = 5944, chance = 80000 }, -- soul orb
	{ id = 3061, chance = 23000 }, -- life crystal
	{ id = 237, chance = 23000 }, -- strong mana potion
	{ id = 236, chance = 23000 }, -- strong health potion
	{ id = 9655, chance = 5000 }, -- gear crystal
	{ id = 8775, chance = 5000 }, -- gear wheel
	{ id = 9066, chance = 5000 }, -- crystal pedestal
	{ id = 816, chance = 1000 }, -- lightning pendant
	{ id = 3048, chance = 1000 }, -- might ring
	{ id = 3073, chance = 1000 }, -- wand of cosmic energy
	{ id = 3037, chance = 1000 }, -- yellow gem
	{ id = 7440, chance = 1000 }, -- mastermind potion
	{ id = 12601, chance = 1000 }, -- slime mould
	{ id = 9304, chance = 260 }, -- shockwave amulet
	{ id = 7428, chance = 260 }, -- bonebreaker
	{ id = 8050, chance = 260 }, -- crystalline armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -80, maxDamage = -120, radius = 3, effect = CONST_ME_YELLOWENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -125, maxDamage = -170, length = 5, spread = 2, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "drunk", interval = 2000, chance = 10, range = 7, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_STUN, target = true, duration = 3000 },
}

monster.defenses = {
	defense = 25,
	armor = 25,
	mitigation = 0.83,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 75 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
