local mType = Game.createMonsterType("Zanakeph")
local monster = {}

monster.description = "Zanakeph"
monster.experience = 9900
monster.outfit = {
	lookType = 231,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 13000
monster.maxHealth = 13000
monster.race = "undead"
monster.corpse = 6305
monster.speed = 165
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 6
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
	runHealth = 700,
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
	{text = "FEEEED MY ETERNAL HUNGER!", yell = true},
	{text = "I SENSE LIFE", yell = true}
}

monster.loot = {
	{id = 6299, chance = 100000}, -- death ring
	{id = 7430, chance = 100000}, -- dragonbone staff
	{id = 3031, chance = 100000, maxCount = 100}, -- gold coin
	{id = 2903, chance = 100000}, -- golden mug
	{id = 3035, chance = 100000, maxCount = 10}, -- platinum coin
	{id = 10316, chance = 100000, maxCount = 3}, -- unholy bone
	{id = 9058, chance = 78000}, -- gold ingot
	{id = 6499, chance = 56000}, -- demonic essence
	{id = 3370, chance = 47270}, -- knight armor
	{id = 3385, chance = 40000}, -- crown helmet
	{id = 7642, chance = 37000, maxCount = 3}, -- great spirit potion
	{id = 5925, chance = 37000, maxCount = 5}, -- hardened bone
	{id = 10451, chance = 37000}, -- jade hat
	{id = 239, chance = 35000, maxCount = 4}, -- great health potion
	{id = 8896, chance = 35000}, -- slightly rusted armor
	{id = 3032, chance = 33000, maxCount = 5}, -- small emerald
	{id = 3029, chance = 33000, maxCount = 5}, -- small sapphire
	{id = 238, chance = 25000, maxCount = 3}, -- great mana potion
	{id = 3360, chance = 13500}, -- golden armor
	{id = 12304, chance = 6780}, -- maxilla maximus
	{id = 5741, chance = 5000}, -- skull helmet
	{id = 8057, chance = 3390}, -- divine plate
	{id = 3392, chance = 1690} -- royal helmet
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 90, attack = 96},
	{name ="combat", interval = 2000, chance = 5, type = COMBAT_PHYSICALDAMAGE, minDamage = -300, maxDamage = -400, range = 7, radius = 4, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -125, maxDamage = -600, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = false},
	{name ="combat", interval = 2000, chance = 5, type = COMBAT_EARTHDAMAGE, minDamage = -100, maxDamage = -390, range = 7, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -180, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -150, maxDamage = -690, length = 8, spread = 3, effect = CONST_ME_POISONAREA, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -700, length = 8, spread = 3, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -200, radius = 3, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="undead dragon curse", interval = 2000, chance = 10, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 40,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = -25},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
