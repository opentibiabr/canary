local mType = Game.createMonsterType("Orc Shield")
local monster = {}

monster.name = "Orc Warlord"
monster.description = "an orc warlord"
monster.experience = 670
monster.outfit = {
	lookType = 2,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 950
monster.maxHealth = 950
monster.race = "blood"
monster.corpse = 6008
monster.speed = 117
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	{text = "Ranat Ulderek!", yell = false},
	{text = "Orc buta bana!", yell = false},
	{text = "Ikem rambo zambo!", yell = false},
	{text = "Fetchi Maruk Buta", yell = false}
}

monster.loot = {
	{id = 11453, chance = 25000}, -- broken helmet
	{id = 11479, chance = 20000}, -- orc leather
	{id = 3031, chance = 18000, maxCount = 45}, -- gold coin
	{id = 3287, chance = 14000, maxCount = 18}, -- throwing star
	{id = 3578, chance = 10800, maxCount = 2}, -- fish
	{id = 10196, chance = 9500}, -- orc tooth
	{id = 3316, chance = 5200}, -- orcish axe
	{id = 3347, chance = 5200}, -- hunting spear
	{id = 3357, chance = 5110}, -- plate armor
	{id = 11480, chance = 4610}, -- skull belt
	{id = 3557, chance = 4180}, -- plate legs
	{id = 3307, chance = 3550}, -- scimitar
	{id = 3084, chance = 2190}, -- protection amulet
	{id = 3265, chance = 1800}, -- two handed sword
	{id = 3384, chance = 1400}, -- dark helmet
	{id = 3359, chance = 670}, -- brass armor
	{id = 266, chance = 420}, -- health potion
	{id = 3391, chance = 340}, -- crusader helmet
	{id = 3322, chance = 290}, -- dragon hammer
	{id = 818, chance = 250}, -- magma boots
	{id = 7395, chance = 80}, -- orc trophy
	{id = 3049, chance = 80}, -- stealth ring
	{id = 3437, chance = 5000} -- amazon shield
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -200, range = 7, shootEffect = CONST_ANI_THROWINGSTAR, target = false}
}

monster.defenses = {
	defense = 35,
	armor = 35,
	{name ="invisible", interval = 2000, chance = 5, effect = CONST_ME_MAGIC_BLUE}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 80},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 10},
	{type = COMBAT_DEATHDAMAGE , percent = -5}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
