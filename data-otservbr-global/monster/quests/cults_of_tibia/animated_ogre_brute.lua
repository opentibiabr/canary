local mType = Game.createMonsterType("Animated Ogre Brute")
local monster = {}

monster.description = "an animated ogre brute"
monster.experience = 800
monster.outfit = {
	lookType = 857,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 1000
monster.maxHealth = 1000
monster.race = "blood"
monster.corpse = 22143
monster.speed = 105
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
	{text = "You so juicy!", yell = false},
	{text = "You stop! You lunch!", yell = false},
	{text = "Smash you face in!!!", yell = false}
}

monster.loot = {
	{id = 3031, chance = 92000, maxCount = 130}, -- gold coin
	{id = 3577, chance = 6200}, -- meat
	{id = 3030, chance = 4200}, -- small ruby
	{id = 3026, chance = 6200, maxCount = 3}, -- white pearl
	{id = 11447, chance = 6200}, -- battle stone
	{id = 3598, chance = 6200, maxCount = 7}, -- cookie
	{id = 22188, chance = 5200}, -- ogre ear stud
	{id = 22189, chance = 1200}, -- ogre nose ring
	{id = 22193, chance = 3200, maxCount = 2}, -- onyx chip
	{id = 22194, chance = 3200, maxCount = 3}, -- opal
	{id = 3050, chance = 2200}, -- power ring
	{id = 22191, chance = 1200}, -- skull fetish
	{id = 236, chance = 6200, maxCount = 3}, -- strong health potion
	{id = 7428, chance = 500}, -- bonebreaker
	{id = 22172, chance = 600}, -- ogre choppa
	{id = 22171, chance = 800}, -- ogre klubba
	{id = 3465, chance = 500}, -- pot
	{id = 8906, chance = 200}, -- heavily rusted helmet
	{id = 22192, chance = 300} -- shamanic mask
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -269, condition = {type = CONDITION_FIRE, totalDamage = 6, interval = 9000}},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -70, maxDamage = -180, range = 7, shootEffect = CONST_ANI_POISON, target = false},
	{name ="drunk", interval = 2000, chance = 10, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_TELEPORT, target = false}
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
