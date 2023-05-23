local mType = Game.createMonsterType("Fernfang")
local monster = {}

monster.description = "Fernfang"
monster.experience = 600
monster.outfit = {
	lookType = 206,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 400
monster.maxHealth = 400
monster.race = "blood"
monster.corpse = 18285
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 50,
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
	targetDistance = 4,
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
	maxSummons = 3,
	summons = {
		{name = "War Wolf", chance = 13, interval = 1000, count = 3}
	}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "You desacrated this place!", yell = false},
	{text = "I will cleanse this isle!", yell = false},
	{text = "Grrrrrrr", yell = false},
	{text = "Yoooohuuuu!", yell = true}
}

monster.loot = {
	{id = 9646, chance = 100000}, -- book of prayers
	{id = 3031, chance = 100000, maxCount = 95}, -- gold coin
	{id = 3035, chance = 93000, maxCount = 3}, -- platinum coin
	{id = 3736, chance = 86000}, -- star herb
	{id = 11492, chance = 53000}, -- rope belt
	{id = 3050, chance = 40000}, -- power ring
	{id = 11493, chance = 40000}, -- safety pin
	{id = 3037, chance = 33000}, -- yellow gem
	{id = 2885, chance = 20000}, -- brown flask
	{id = 237, chance = 20000}, -- strong mana potion
	{id = 2914, chance = 13000}, -- lamp
	{id = 3289, chance = 13000}, -- staff
	{id = 5786, chance = 13000}, -- wooden whistle
	{id = 3147, chance = 7000}, -- blank rune
	{id = 3600, chance = 7000}, -- bread
	{id = 3563, chance = 7000}, -- green tunic
	{id = 3061, chance = 7000}, -- life crystal
	{id = 3738, chance = 7000}, -- sling herb
	{id = 3012, chance = 7000} -- wolf tooth chain
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -50},
	{name ="combat", interval = 1000, chance = 13, type = COMBAT_HOLYDAMAGE, minDamage = -65, maxDamage = -180, range = 7, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_HOLYDAMAGE, target = false},
	{name ="combat", interval = 1000, chance = 25, type = COMBAT_MANADRAIN, minDamage = -20, maxDamage = -45, range = 7, effect = CONST_ME_MAGIC_RED, target = false}
}

monster.defenses = {
	defense = 10,
	armor = 15,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 10, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 1000, chance = 7, speedChange = 280, effect = CONST_ME_MAGIC_RED, target = false, duration = 10000},
	{name ="outfit", interval = 1000, chance = 5, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 14000, outfitMonster = "War Wolf"}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 40},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 70},
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
