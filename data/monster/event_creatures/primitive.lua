local mType = Game.createMonsterType("Primitive")
local monster = {}

monster.description = "Primitive"
monster.experience = 45
monster.outfit = {
	lookType = 143,
	lookHead = 1,
	lookBody = 1,
	lookLegs = 1,
	lookFeet = 1,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 200
monster.maxHealth = 200
monster.race = "blood"
monster.corpse = 6080
monster.speed = 300
monster.manaCost = 0
monster.maxSummons = 0

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
	runHealth = 5,
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

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "We don't need a future!", yell = false},
	{text = "I'll rook you all!", yell = false},
	{text = "They thought they'd beaten us!", yell = false},
	{text = "You are history!", yell = false},
	{text = "There can only be one world!", yell = false},
	{text = "Valor who?", yell = false},
	{text = "Die noob!", yell = false},
	{text = "There are no dragons!", yell = false},
	{text = "I'll quit forever! Again ...", yell = false},
	{text = "You all are noobs!", yell = false},
	{text = "Beware of the cyclops!", yell = false},
	{text = "Just had a disconnect.", yell = false},
	{text = "Magic is only good for girls!", yell = false},
	{text = "We'll be back!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 12500, maxCount = 10},
	{name = "sabre", chance = 10250},
	{name = "axe", chance = 12250},
	{name = "studded helmet", chance = 9500},
	{name = "studded armor", chance = 7000},
	{name = "studded shield", chance = 1200},
	{id = 6570, chance = 500},
	{id = 6571, chance = 500}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -32},
	{name ="drunk", interval = 1000, chance = 20, range = 7, shootEffect = CONST_ANI_ENERGY, target = false},
	{name ="combat", interval = 1000, chance = 34, type = COMBAT_FIREDAMAGE, minDamage = -20, maxDamage = -20, range = 7, radius = 3, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	{name ="outfit", interval = 1000, chance = 2, radius = 4, effect = CONST_ME_LOSEENERGY, target = false, duration = 10000, outfitMonster = "primitive"}
}

monster.defenses = {
	defense = 25,
	armor = 20
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 100},
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
