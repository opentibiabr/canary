local mType = Game.createMonsterType("Horestis")
local monster = {}

monster.description = "Horestis"
monster.experience = 3500
monster.outfit = {
	lookType = 91,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 6000
monster.maxHealth = 6000
monster.race = "undead"
monster.corpse = 6031
monster.speed = 170
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

monster.summon = {
	maxSummons = 2,
	summons = {
		{name = "Sandstone Scorpion", chance = 12, interval = 1000, count = 2}
	}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "I might be dead but I'm not gone!", yell = false}
}

monster.loot = {
	{id = 12509, chance = 100000}, -- scorpion sceptre
	{id = 3031, chance = 95000, maxCount = 243}, -- gold coin
	{id = 3035, chance = 36000, maxCount = 5}, -- platinum coin
	{id = 12483, chance = 17000}, -- pharaoh banner
	{id = 3042, chance = 14000, maxCount = 5}, -- scarab coin
	{id = 12482, chance = 12000}, -- hieroglyph banner
	{id = 3017, chance = 12000}, -- silver brooch
	{id = 238, chance = 10000, maxCount = 3}, -- great mana potion
	{id = 239, chance = 5000, maxCount = 4}, -- great health potion
	{id = 3334, chance = 5000}, -- pharaoh sword
	{id = 10290, chance = 2500}, -- mini mummy
	{id = 8897, chance = 2500}, -- heavily rusted legs
	{id = 3335, chance = 2500} -- twin axe
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450},
	{name ="combat", interval = 1000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -750, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 3000, chance = 17, type = COMBAT_LIFEDRAIN, minDamage = -400, maxDamage = -500, length = 8, spread = 3, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="drunk", interval = 3000, chance = 11, radius = 6, effect = CONST_ME_POISONAREA, target = false, duration = 25000},
	{name ="speed", interval = 1000, chance = 25, speedChange = -350, length = 7, spread = 3, effect = CONST_ME_POISONAREA, target = false, duration = 30000},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 30, minDamage = -35, maxDamage = -35, radius = 5, target = false}
}

monster.defenses = {
	defense = 30,
	armor = 25,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 200, maxDamage = 400, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -5},
	{type = COMBAT_ENERGYDAMAGE, percent = 5},
	{type = COMBAT_EARTHDAMAGE, percent = 50},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
