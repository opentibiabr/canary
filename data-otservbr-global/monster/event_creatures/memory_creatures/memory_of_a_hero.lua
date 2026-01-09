local mType = Game.createMonsterType("Memory of a Hero")
local monster = {}

monster.description = "a memory of a hero"
monster.experience = 1750
monster.outfit = {
	lookType = 73,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3850
monster.maxHealth = 3850
monster.race = "blood"
monster.corpse = 18134
monster.speed = 140
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
	{ id = 2995, chance = 470 }, -- Piggy Bank
	{ id = 2949, chance = 470 }, -- Lyre
	{ id = 3572, chance = 930 }, -- Scarf
	{ id = 2815, chance = 49300 }, -- Scroll
	{ id = 3265, chance = 1860 }, -- Two Handed Sword
	{ id = 3004, chance = 3720 }, -- Wedding Ring
	{ id = 3279, chance = 2790 }, -- War Hammer
	{ id = 3350, chance = 13020 }, -- Bow
	{ id = 3577, chance = 9770 }, -- Meat
	{ id = 239, chance = 7910 }, -- Great Health Potion
	{ id = 37530, chance = 2790 }, -- Bottle of Champagne
	{ id = 3031, chance = 87910 }, -- Gold Coin
	{ id = 3592, chance = 20000 }, -- Grapes
	{ id = 3003, chance = 2330 }, -- Rope
	{ id = 3280, chance = 2330 }, -- Fire Sword
	{ id = 3658, chance = 22330 }, -- Red Rose
	{ id = 3048, chance = 470 }, -- Might Ring
	{ id = 3563, chance = 6510 }, -- Green Tunic
	{ id = 37531, chance = 1860 }, -- Candy Floss (Large)
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -170 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -120, range = 7, shootEffect = CONST_ANI_ARROW, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	mitigation = 1.50,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
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
