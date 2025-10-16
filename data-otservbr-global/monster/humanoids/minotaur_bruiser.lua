local mType = Game.createMonsterType("Minotaur Bruiser")
local monster = {}

monster.description = "a minotaur bruiser"
monster.experience = 50
monster.outfit = {
	lookType = 25,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"MorrisMinotaurDeath",
}

monster.health = 100
monster.maxHealth = 100
monster.race = "blood"
monster.corpse = 5969
monster.speed = 84
monster.manaCost = 330

monster.changeTarget = {
	interval = 4000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
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
	{ id = 3031, chance = 80000, maxCount = 15 }, -- gold coin
	{ id = 3410, chance = 80000 }, -- plate shield
	{ id = 3378, chance = 80000 }, -- studded armor
	{ id = 3274, chance = 80000 }, -- axe
	{ id = 3286, chance = 80000 }, -- mace
	{ id = 3264, chance = 80000 }, -- sword
	{ id = 3354, chance = 80000 }, -- brass helmet
	{ id = 3358, chance = 80000 }, -- chain armor
	{ id = 3577, chance = 5000 }, -- meat
	{ id = 15689, chance = 1000 }, -- shovel
	{ id = 3056, chance = 1000 }, -- bronze amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -45 },
}

monster.defenses = {
	defense = 15,
	armor = 11,
	mitigation = 0.18,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
