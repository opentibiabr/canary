local mType = Game.createMonsterType("Lovely Yielothax")
local monster = {}

monster.description = "a lovely yielothax"
monster.experience = 1250
monster.outfit = {
	lookType = 408,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "venom"
monster.corpse = 12595
monster.speed = 150
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
	{text = "IIEEH!! Iiih iih ih iiih!!!", yell = true},
	{text = "Iiiieeeh iiiieh iiieeh!", yell = true},
	{text = "Bsssmm bssmm bsssmmm", yell = true}
}

monster.loot = {
	{id = 7440, chance = 490}, -- mastermind potion
	{id = 12742, chance = 300}, -- yielowax
	{id = 12805, chance = 320}, -- yielocks
	{id = 3031, chance = 99800, maxCount = 227}, -- gold coin
	{id = 3725, chance = 9930, maxCount = 3}, -- brown mushroom
	{id = 236, chance = 19910}, -- strong health potion
	{id = 237, chance = 19920}, -- strong mana potion
	{id = 3028, chance = 4860, maxCount = 5}, -- small diamond
	{id = 3034, chance = 950}, -- talon
	{id = 3048, chance = 4020}, -- might ring
	{id = 12737, chance = 270}, -- broken ring of ending
	{id = 3073, chance = 510}, -- wand of cosmic energy
	{id = 3326, chance = 520}, -- epee
	{id = 9304, chance = 570}, -- shockwave amulet
	{id = 816, chance = 830}, -- lightning pendant
	{id = 822, chance = 480} -- lightning legs
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 70, attack = 50},
	{name ="combat", interval = 2000, chance = 18, type = COMBAT_LIFEDRAIN, minDamage = -70, maxDamage = -130, length = 4, spread = 3, effect = CONST_ME_ENERGYAREA, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -50, maxDamage = -150, length = 5, spread = 3, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -75, maxDamage = -120, radius = 3, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_HITBYPOISON, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -120, maxDamage = -215, radius = 3, effect = CONST_ME_HITBYPOISON, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 13, minDamage = -50, maxDamage = -50, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_HITBYPOISON, target = true}
}

monster.defenses = {
	defense = 45,
	armor = 30,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 100},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 100},
	{type = COMBAT_HOLYDAMAGE , percent = 100},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
