local mType = Game.createMonsterType("Diamond Servant Replica")
local monster = {}

monster.description = "a diamond servant replica"
monster.experience = 1400
monster.outfit = {
	lookType = 397,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"ReplicaServantDeath",
}

monster.raceId = 1326
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 2,
	Locations = "Replica Dungeon",
}

monster.health = 2000
monster.maxHealth = 2000
monster.race = "venom"
monster.corpse = 12496
monster.speed = 86
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
}

monster.loot = {
	{ id = 9655, chance = 5040 }, -- gear crystal
	{ id = 8775, chance = 5070 }, -- gear wheel
	{ id = 3031, chance = 94130, maxCount = 358 }, -- gold coin
	{ id = 5944, chance = 44990 }, -- soul orb
	{ id = 3061, chance = 9150 }, -- life crystal
	{ id = 237, chance = 5980 }, -- strong mana potion
	{ id = 236, chance = 5790 }, -- strong health potion
	{ id = 9063, chance = 5320 }, -- crystal pedestal
	{ id = 3048, chance = 940 }, -- might ring
	{ id = 816, chance = 710 }, -- lightning pendant
	{ id = 3037, chance = 550 }, -- yellow gem
	{ id = 3073, chance = 530 }, -- wand of cosmic energy
	{ id = 12601, chance = 480 }, -- slime mould
	{ id = 7440, chance = 400 }, -- mastermind potion
	{ id = 9304, chance = 110 }, -- shockwave amulet
	{ id = 8050, chance = 20 }, -- crystalline armor
	{ id = 7428, chance = 13 }, -- bonebreaker
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 40, attack = 40 },
	{ name = "combat", interval = 2000, chance = 11, type = COMBAT_ENERGYDAMAGE, minDamage = -100, maxDamage = -210, radius = 3, effect = CONST_ME_YELLOWENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -75, maxDamage = -125, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "wyrm wave", interval = 2000, chance = 9, minDamage = -70, maxDamage = -120, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 25,
	mitigation = 0.83,
	{ name = "combat", interval = 2000, chance = 11, type = COMBAT_HEALING, minDamage = 50, maxDamage = 130, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, effect = CONST_ME_YELLOWENERGY, target = false },
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
