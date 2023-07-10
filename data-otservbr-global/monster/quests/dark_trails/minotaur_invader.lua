local mType = Game.createMonsterType("Minotaur Invader")
local monster = {}

monster.description = "a minotaur invader"
monster.experience = 1600
monster.outfit = {
	lookType = 29,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 1850
monster.maxHealth = 1850
monster.race = "blood"
monster.corpse = 5983
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	{text = "For the victory!", yell = false},
	{text = "We will crush the enemy!", yell = false}
}

monster.loot = {
	{id = 3031, chance = 100000, maxCount = 175}, -- gold coin
	{id = 3035, chance = 100000, maxCount = 4}, -- platinum coin
	{id = 11472, chance = 14285, maxCount = 2}, -- minotaur horn
	{id = 9057, chance = 10000}, -- small topaz
	{id = 11482, chance = 9090}, -- piece of warrior armor
	{id = 3033, chance = 7692}, -- small amethyst
	{id = 5878, chance = 5000}, -- minotaur leather
	{id = 3030, chance = 3703}, -- small ruby
	{id = 3318, chance = 1250}, -- knight axe
	{id = 3415, chance = 1250}, -- guardian shield
	{id = 3039, chance = 1250}, -- red gem
	{id = 5911, chance = 1250} -- red piece of cloth
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 85, attack = 75}
}

monster.defenses = {
	defense = 20,
	armor = 20
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 20},
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
