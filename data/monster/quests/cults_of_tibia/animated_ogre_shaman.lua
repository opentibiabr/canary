local mType = Game.createMonsterType("Animated Ogre Shaman")
local monster = {}

monster.description = "an animated ogre shaman"
monster.experience = 625
monster.outfit = {
	lookType = 859,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 800
monster.maxHealth = 800
monster.race = "blood"
monster.corpse = 24795
monster.speed = 240
monster.manaCost = 0
monster.maxSummons = 2

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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.summons = {
	{name = "Dworc Fleshhunter", chance = 30, interval = 1000, max = 1},
	{name = "Terror Bird", chance = 30, interval = 1000, max = 1}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "The spirits hunger!", yell = false},
	{text = "A sacrifice for Great Hunger!", yell = false},
	{text = "Stay here, soul food!", yell = false},
	{text = "You more delicate than clomp!", yell = false}
}

monster.loot = {
	{id = 2148, chance = 92000, maxCount = 130},
	{id = 24850, chance = 1200, maxCount = 3},
	{id = 24841, chance = 6200, maxCount = 2},
	{id = 2147, chance = 2200, maxCount = 2},
	{id = 2144, chance = 1200, maxCount = 2},
	{id = 20111, chance = 3200},
	{id = 12408, chance = 1200},
	{id = 2687, chance = 2200, maxCount = 7},
	{id = 2185, chance = 800},
	{id = 24844, chance = 3200},
	{id = 24845, chance = 2200},
	{id = 24840, chance = 1200},
	{id = 2229, chance = 1200},
	{id = 24847, chance = 1200},
	{id = 7589, chance = 1000, maxCount = 3},
	{id = 2188, chance = 600},
	{id = 2031, chance = 500},
	{id = 24839, chance = 300},
	{id = 24848, chance = 300},
	{id = 3955, chance = 100},
	{id = 3952, chance = 100, maxCount = 2}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -269, condition = {type = CONDITION_FIRE, totalDamage = 6, interval = 9000}},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -70, maxDamage = -180, range = 7, shootEffect = CONST_ANI_POISON, target = false},
	{name ="outfit", interval = 2000, chance = 8, range = 7, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 4000, outfitMonster = "chicken"},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -15, maxDamage = -120, length = 8, spread = 3, effect = CONST_ME_CARNIPHILA, target = false}
}

monster.defenses = {
	defense = 20,
	armor = 20,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 80, maxDamage = 95, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
