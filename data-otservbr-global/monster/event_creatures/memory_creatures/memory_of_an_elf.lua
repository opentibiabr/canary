local mType = Game.createMonsterType("Memory Of An Elf")
local monster = {}

monster.description = "a memory of an elf"
monster.experience = 1440
monster.outfit = {
	lookType = 63,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 3440
monster.maxHealth = 3440
monster.race = "blood"
monster.corpse = 6011
monster.speed = 110
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
	canPushCreatures = false,
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

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Feel my wrath!", yell = false},
	{text = "For the Daughter of the Stars!", yell = false},
	{text = "I'll bring balance upon you!", yell = false},
	{text = "Tha'shi Cenath", yell = false},
	{text = "Vihil Ealuel", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 37000, maxCount = 70},
	{name = "candlestick", chance = 2100},
	{name = "bread", chance = 14000},
	{id = 3509, chance = 1000}, -- inkwell
	{name = "green tunic", chance = 7000},
	{name = "blank rune", chance = 18000},
	{name = "wand of cosmic energy", chance = 1160},
	{name = "strong mana potion", chance = 3000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -35},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -70, range = 7, shootEffect = CONST_ANI_ARROW, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -30, maxDamage = -50, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -70, maxDamage = -85, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false}
}

monster.defenses = {
	defense = 15,
	armor = 15,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 40, maxDamage = 60, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 50},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
