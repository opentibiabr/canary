local mType = Game.createMonsterType("Animated Ogre Savage")
local monster = {}

monster.description = "an animated ogre savage"
monster.experience = 950
monster.outfit = {
	lookType = 858,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 1400
monster.maxHealth = 1400
monster.race = "blood"
monster.corpse = 22147
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
	{text = "Must! Chop! Food! Raahh!", yell = false},
	{text = "You tasty!", yell = false}
}

monster.loot = {
	{id = 3031, chance = 92000, maxCount = 130}, -- gold coin
	{id = 3577, chance = 6200}, -- meat
	{id = 22193, chance = 3200, maxCount = 2}, -- onyx chip
	{id = 22194, chance = 3200, maxCount = 3}, -- opal
	{id = 3598, chance = 2200, maxCount = 7}, -- cookie
	{id = 8016, chance = 1200, maxCount = 2}, -- jalapeno pepper
	{id = 9057, chance = 1200, maxCount = 2}, -- small topaz
	{id = 3030, chance = 1200, maxCount = 2}, -- small ruby
	{id = 7439, chance = 1200}, -- berserk potion
	{id = 3078, chance = 2200}, -- mysterious fetish
	{id = 22188, chance = 1200}, -- ogre ear stud
	{id = 22189, chance = 1200}, -- ogre nose ring
	{id = 22191, chance = 1200}, -- skull fetish
	{id = 236, chance = 2200, maxCount = 3}, -- strong health potion
	{id = 3279, chance = 600}, -- war hammer
	{id = 22192, chance = 300} -- shamanic mask
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -269, condition = {type = CONDITION_FIRE, totalDamage = 6, interval = 9000}},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -70, maxDamage = -180, range = 7, shootEffect = CONST_ANI_POISON, target = false}
}

monster.defenses = {
	defense = 20,
	armor = 20,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 80, maxDamage = 95, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
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
