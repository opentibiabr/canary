local mType = Game.createMonsterType("Ron The Ripper")
local monster = {}

monster.description = "Ron The Ripper"
monster.experience = 500
monster.outfit = {
	lookType = 151,
	lookHead = 95,
	lookBody = 94,
	lookLegs = 117,
	lookFeet = 59,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "blood"
monster.corpse = 18221
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 60000,
	chance = 0
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
	staticAttackChance = 50,
	targetDistance = 1,
	runHealth = 250,
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
	{text = "Muahaha!", yell = false}
}

monster.loot = {
	{id = 6101, chance = 100000}, -- ron the ripper's sabre
	{id = 3031, chance = 100000, maxCount = 128}, -- gold coin
	{id = 3114, chance = 81000, maxCount = 2}, -- skull
	{id = 3357, chance = 63000}, -- plate armor
	{id = 3267, chance = 45000}, -- dagger
	{id = 239, chance = 18000}, -- great health potion
	{id = 3370, chance = 18000}, -- knight armor
	{id = 3577, chance = 18000}, -- meat
	{id = 5926, chance = 18000}, -- pirate backpack
	{id = 3028, chance = 9000} -- small diamond
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250},
	{name ="combat", interval = 4000, chance = 60, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -160, shootEffect = CONST_ANI_THROWINGKNIFE, target = false}
}

monster.defenses = {
	defense = 50,
	armor = 35,
	{name ="combat", interval = 4000, chance = 25, type = COMBAT_HEALING, minDamage = 50, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false}
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
