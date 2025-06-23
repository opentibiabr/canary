local mType = Game.createMonsterType("Golden Servant Replica")
local monster = {}

monster.description = "a golden servant replica"
monster.experience = 1250
monster.outfit = {
	lookType = 396,
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

monster.raceId = 1327
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
monster.corpse = 12495
monster.speed = 105
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
	runHealth = 80,
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
	{ id = 3732, chance = 1450 }, -- green mushroom
	{ id = 8775, chance = 940 }, -- gear wheel
	{ id = 3031, chance = 85180, maxCount = 270 }, -- gold coin
	{ id = 266, chance = 4930 }, -- health potion
	{ id = 268, chance = 4950 }, -- mana potion
	{ id = 3269, chance = 3030 }, -- halberd
	{ id = 8072, chance = 520 }, -- spellbook of enlightenment
	{ id = 3049, chance = 450 }, -- stealth ring
	{ id = 12601, chance = 340 }, -- slime mould
	{ id = 12801, chance = 36 }, -- golden can of oil
	{ id = 3360, chance = 13 }, -- golden armor
	{ id = 3063, chance = 8 }, -- gold ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 40, attack = 40 },
	{ name = "combat", interval = 2000, chance = 11, type = COMBAT_FIREDAMAGE, minDamage = -80, maxDamage = -110, length = 5, spread = 0, effect = CONST_ME_YELLOWENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -70, maxDamage = -110, range = 7, radius = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_PURPLEENERGY, target = true },
}

monster.defenses = {
	defense = 45,
	armor = 29,
	mitigation = 0.88,
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_HEALING, minDamage = 40, maxDamage = 70, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = 80 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
