local mType = Game.createMonsterType("Zugurosh")
local monster = {}

monster.description = "Zugurosh"
monster.experience = 10000
monster.outfit = {
	lookType = 12,
	lookHead = 3,
	lookBody = 18,
	lookLegs = 19,
	lookFeet = 91,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 90500
monster.maxHealth = 90500
monster.race = "fire"
monster.corpse = 7893
monster.speed = 165
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 15
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
	staticAttackChance = 85,
	targetDistance = 1,
	runHealth = 4500,
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
	{text = "You will run out of resources soon enough!", yell = true},
	{text = "One little mistake and you're all are mine!", yell = false},
	{text = "I sense your strength fading!", yell = false},
	{text = "I know you will show a weakness!", yell = false},
	{text = "Your fear will make you prone to mistakes!", yell = false}
}

monster.loot = {
	{id = 6499, chance = 100000}, -- demonic essence
	{id = 3031, chance = 100000, maxCount = 194}, -- gold coin
	{id = 8899, chance = 54000}, -- slightly rusted legs
	{id = 8896, chance = 45000}, -- slightly rusted armor
	{id = 238, chance = 27000}, -- great mana potion
	{id = 7642, chance = 26000}, -- great spirit potion
	{id = 239, chance = 23000}, -- great health potion
	{id = 7643, chance = 22000}, -- ultimate health potion
	{id = 9058, chance = 21000}, -- gold ingot
	{id = 3035, chance = 21000, maxCount = 30}, -- platinum coin
	{id = 6104, chance = 21000}, -- jewel case
	{id = 5944, chance = 21000, maxCount = 10}, -- soul orb
	{id = 3034, chance = 18000, maxCount = 30}, -- talon
	{id = 5911, chance = 17000, maxCount = 10}, -- red piece of cloth
	{id = 3017, chance = 17000}, -- silver brooch
	{id = 5912, chance = 15000, maxCount = 10}, -- blue piece of cloth
	{id = 5909, chance = 15000, maxCount = 10}, -- white piece of cloth
	{id = 5910, chance = 14000, maxCount = 10}, -- green piece of cloth
	{id = 5914, chance = 14000, maxCount = 10}, -- yellow piece of cloth
	{id = 5913, chance = 12000, maxCount = 10}, -- brown piece of cloth
	{id = 5954, chance = 9700, maxCount = 2}, -- demon horn
	{id = 3079, chance = 8700}, -- boots of haste
	{id = 3057, chance = 6000}, -- amulet of loss
	{id = 3554, chance = 4500}, -- steel boots
	{id = 3555, chance = 1500} -- golden boots
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -800},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -500, range = 4, effect = CONST_ME_MAGIC_RED, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -500, length = 7, spread = 3, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -100, radius = 4, effect = CONST_ME_SMALLCLOUDS, target = false},
	-- fire
	{name ="condition", type = CONDITION_FIRE, interval = 3000, chance = 20, minDamage = -10, maxDamage = -10, radius = 4, effect = CONST_ME_EXPLOSIONHIT, target = true},
	{name ="combat", interval = 1000, chance = 13, type = COMBAT_MANADRAIN, minDamage = -60, maxDamage = -200, radius = 5, effect = CONST_ME_WATERSPLASH, target = false}
}

monster.defenses = {
	defense = 55,
	armor = 45,
	{name ="combat", interval = 2000, chance = 50, type = COMBAT_HEALING, minDamage = 40, maxDamage = 60, effect = CONST_ME_MAGIC_GREEN, target = false},
	{name ="combat", interval = 2000, chance = 50, type = COMBAT_HEALING, minDamage = 400, maxDamage = 600, effect = CONST_ME_MAGIC_GREEN, target = false},
	{name ="invisible", interval = 1000, chance = 5, effect = CONST_ME_MAGIC_BLUE}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 50},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = 40},
	{type = COMBAT_FIREDAMAGE, percent = 30},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 25},
	{type = COMBAT_HOLYDAMAGE , percent = 30},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
