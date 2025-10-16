local mType = Game.createMonsterType("Memory of an Insectoid")
local monster = {}

monster.description = "a memory of an insectoid"
monster.experience = 1610
monster.outfit = {
	lookType = 403,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3630
monster.maxHealth = 3630
monster.race = "venom"
monster.corpse = 12525
monster.speed = 120
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
	canPushCreatures = false,
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
}

monster.loot = {
	{ id = 3326, chance = 80000 }, -- epee
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 37530, chance = 80000 }, -- bottle of champagne
	{ id = 37468, chance = 80000 }, -- special fx box
	{ id = 3032, chance = 80000 }, -- small emerald
	{ id = 3031, chance = 80000 }, -- gold coin
	{ id = 266, chance = 80000 }, -- health potion
	{ id = 3038, chance = 80000 }, -- green gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -163, condition = { type = CONDITION_POISON, totalDamage = 160, interval = 4000 } },
}

monster.defenses = {
	defense = 15,
	armor = 15,
	mitigation = 1.30,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
