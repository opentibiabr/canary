local mType = Game.createMonsterType("Depowered Minotaur")
local monster = {}

monster.description = "a depowered minotaur"
monster.experience = 1100
monster.outfit = {
	lookType = 25,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "blood"
monster.corpse = 5969
monster.speed = 106
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	{ text = "I want my power back!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 3029, chance = 80000 }, -- small sapphire
	{ id = 237, chance = 80000, maxCount = 3 }, -- strong mana potion
	{ id = 236, chance = 80000, maxCount = 3 }, -- strong health potion
	{ id = 5878, chance = 80000 }, -- minotaur leather
	{ id = 3028, chance = 80000 }, -- small diamond
	{ id = 3577, chance = 80000 }, -- meat
	{ id = 11472, chance = 80000 }, -- minotaur horn
	{ id = 3030, chance = 80000 }, -- small ruby
	{ id = 3029, chance = 80000 }, -- small sapphire
	{ id = 3032, chance = 80000 }, -- small emerald
	{ id = 21166, chance = 80000 }, -- moohtah plate
	{ id = 3093, chance = 80000 }, -- club ring
	{ id = 5911, chance = 80000 }, -- red piece of cloth
	{ id = 7401, chance = 80000 }, -- minotaur trophy
	{ id = 7452, chance = 80000 }, -- spiked squelcher
	{ id = 21177, chance = 80000 }, -- cowtana
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 80, attack = 45 },
	{ name = "melee", interval = 2000, chance = 100, minDamage = -0, maxDamage = -200 },
}

monster.defenses = {
	defense = 15,
	armor = 15,
	mitigation = 1.09,
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
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
