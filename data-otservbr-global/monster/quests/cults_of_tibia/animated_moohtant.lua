local mType = Game.createMonsterType("Animated Moohtant")
local monster = {}

monster.description = "an animated moohtant"
monster.experience = 2600
monster.outfit = {
	lookType = 607,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 3200
monster.maxHealth = 3200
monster.race = "blood"
monster.corpse = 20996
monster.speed = 130
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 3
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
	{text = "MOOOOH!", yell = true},
	{text = "Grrrr.", yell = false},
	{text = "Raaaargh!", yell = false}
}

monster.loot = {
	{id = 3031, chance = 100000, maxCount = 195}, -- gold coin
	{id = 3035, chance = 58160, maxCount = 2}, -- platinum coin
	{id = 21200, chance = 2740, maxCount = 2}, -- moohtant horn
	{id = 21199, chance = 1770}, -- giant pacifier
	{id = 239, chance = 7380, maxCount = 3}, -- great health potion
	{id = 238, chance = 7230, maxCount = 3}, -- great mana potion
	{id = 3577, chance = 6520}, -- meat
	{id = 3030, chance = 4680, maxCount = 2}, -- small ruby
	{id = 5878, chance = 4110}, -- minotaur leather
	{id = 3028, chance = 4400, maxCount = 2}, -- small diamond
	{id = 3098, chance = 2410}, -- ring of healing
	{id = 5911, chance = 900}, -- red piece of cloth
	{id = 21173, chance = 860}, -- moohtant cudgel
	{id = 3037, chance = 710}, -- yellow gem
	{id = 7452, chance = 430}, -- spiked squelcher
	{id = 7427, chance = 280}, -- chaos mace
	{id = 9058, chance = 280}, -- gold ingot
	{id = 7401, chance = 280} -- minotaur trophy
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 110, attack = 50},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -230, length = 3, spread = 0, effect = CONST_ME_GROUNDSHAKER, target = false},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -200, radius = 3, effect = CONST_ME_GROUNDSHAKER, target = false},
	{name ="combat", interval = 2000, chance = 19, type = COMBAT_LIFEDRAIN, minDamage = -50, maxDamage = -225, radius = 5, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -150, maxDamage = -235, range = 7, radius = 4, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_EXPLOSIONAREA, target = true}
}

monster.defenses = {
	defense = 45,
	armor = 40,
	{name ="combat", interval = 2000, chance = 9, type = COMBAT_HEALING, minDamage = 50, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 1},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 1},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 15},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 1}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
