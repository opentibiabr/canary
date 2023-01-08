local mType = Game.createMonsterType("The Fire Empowered Duke")
local monster = {}

monster.description = "The Fire Empowered Duke"
monster.experience = 40000
monster.outfit = {
	lookType = 1047,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 50000
monster.maxHealth = 50000
monster.race = "blood"
monster.corpse = 27641
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 50
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Chhhhhhh!", yell = false},
	{text = "SzzzzSzzz! SzzzzSzzz!", yell = false}
}

monster.loot = {
	{id = 3031, chance = 100000, maxCount = 198}, -- gold coin
	{id = 3035, chance = 67610, maxCount = 3}, -- platinum coin
	{id = 9058, chance = 390}, -- gold ingot
	{id = 5911, chance = 3230}, -- red piece of cloth
	{id = 5878, chance = 14710}, -- minotaur leather
	{id = 11472, chance = 6580, maxCount = 2}, -- minotaur horn
	{id = 21201, chance = 13160}, -- execowtioner mask
	{id = 239, chance = 11480}, -- great health potion
	{id = 238, chance = 10060}, -- great mana potion
	{id = 3577, chance = 7230}, -- meat
	{id = 9057, chance = 5810, maxCount = 2}, -- small topaz
	{id = 3030, chance = 4520, maxCount = 2}, -- small ruby
	{id = 7412, chance = 900}, -- butcher's axe
	{id = 3381, chance = 770}, -- crown armor
	{id = 21176, chance = 1420}, -- execowtioner axe
	{id = 3318, chance = 770}, -- knight axe
	{id = 7413, chance = 390}, -- titan axe
	{id = 7401, chance = 520} -- minotaur trophy
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1300},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -1500, range = 3, length = 6, spread = 8, effect = CONST_ME_FIREAREA, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -1500, range = 3, length = 9, spread = 4, effect = CONST_ME_HITBYFIRE, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -135, maxDamage = -1500, radius = 2, effect = CONST_ME_EXPLOSIONAREA, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1500, radius = 8, effect = CONST_ME_HITAREA, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 40
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 100},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 100},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 100},
	{type = COMBAT_HOLYDAMAGE , percent = 100},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

monster.heals = {
	{type = COMBAT_FIREDAMAGE, percent = 100}
}

mType:register(monster)
