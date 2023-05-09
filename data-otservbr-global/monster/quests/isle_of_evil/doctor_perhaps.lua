local mType = Game.createMonsterType("Doctor Perhaps")
local monster = {}

monster.description = "doctor perhaps"
monster.experience = 325
monster.outfit = {
	lookType = 133,
	lookHead = 95,
	lookBody = 0,
	lookLegs = 93,
	lookFeet = 114,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 475
monster.maxHealth = 475
monster.race = "blood"
monster.corpse = 18158
monster.speed = 100
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.bosstiary = {
	bossRaceId = 564,
	bossRace = RARITY_BANE
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
		{name = "Zombie", chance = 10, interval = 2000, count = 2}
	}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "I might use some parts of you in my next creation!", yell = false},
	{text = "You're only a testsubject to me!", yell = false},
	{text = "My creations will kill you!", yell = false},
	{text = "You can't beat what you can't comprehend!", yell = false}
}

monster.loot = {
	{id = 3031, chance = 2000, maxCount = 95}, -- gold coin
	{id = 3035, chance = 30000, maxCount = 9}, -- platinum coin
	{id = 9399, chance = 1000}, -- mighty helm of green sparks
	{id = 9372, chance = 1000}, -- meat shield
	{id = 9373, chance = 1000}, -- glutton's mace
	{id = 9383, chance = 1000} -- trousers of the ancients
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -43},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_DROWNDAMAGE, minDamage = -17, maxDamage = -55, range = 5, radius = 3, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_LOSEENERGY, target = true},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 15, minDamage = -20, maxDamage = -40, range = 7, shootEffect = CONST_ANI_POISON, target = false}
}

monster.defenses = {
	defense = 15,
	armor = 15,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 10, maxDamage = 30, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -5},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = 20},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 20},
	{type = COMBAT_HOLYDAMAGE , percent = 20},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
