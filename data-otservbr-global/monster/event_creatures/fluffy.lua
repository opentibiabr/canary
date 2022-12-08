local mType = Game.createMonsterType("Fluffy")
local monster = {}

monster.description = "Fluffy"
monster.experience = 3550
monster.outfit = {
	lookType = 240,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 4500
monster.maxHealth = 4500
monster.race = "blood"
monster.corpse = 6331
monster.speed = 155
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
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
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Wooof!", yell = false}
}

monster.loot = {
	{id = 3031, chance = 100000, maxCount = 100}, -- gold coin
	{id = 3031, chance = 100000, maxCount = 20}, -- gold coin
	{id = 5944, chance = 5555}, -- soul orb
	{id = 6570, chance = 5538, maxCount = 4}, -- surprise bag
	{id = 6571, chance = 1538}, -- surprise bag
	{id = 3582, chance = 50000, maxCount = 8}, -- ham
	{id = 3115, chance = 25000}, -- bone
	{id = 6499, chance = 7200}, -- demonic essence
	{id = 3318, chance = 2857}, -- knight axe
	{id = 3271, chance = 2500}, -- spike sword
	{id = 6558, chance = 8888} -- flask of demonic blood
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 98, attack = 120},
	{name ="combat", interval = 1500, chance = 300, type = COMBAT_ENERGYDAMAGE, minDamage = -100, maxDamage = -200, length = 8, spread = 3, effect = CONST_ME_LOSEENERGY, target = false},
	{name ="combat", interval = 1000, chance = 150, type = COMBAT_EARTHDAMAGE, minDamage = -120, maxDamage = -300, length = 8, spread = 3, effect = CONST_ME_POISONAREA, target = false},
	{name ="combat", interval = 1000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = -105, maxDamage = -235, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, target = false},
	{name ="combat", interval = 1000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -135, maxDamage = -255, range = 7, radius = 6, effect = CONST_ME_LOSEENERGY, target = false}
}

monster.defenses = {
	defense = 35,
	armor = 25
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
