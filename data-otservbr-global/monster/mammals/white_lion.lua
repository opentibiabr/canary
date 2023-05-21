local mType = Game.createMonsterType("White Lion")
local monster = {}

monster.description = "a white lion"
monster.experience = 2300
monster.outfit = {
	lookType = 1290,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 2700
monster.maxHealth = 2700
monster.race = "blood"
monster.corpse = 34245
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 15
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
	targetDistance = 1,
	runHealth = 5,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 1,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{name = "platinum coin", chance = 100000, maxCount = 5},
	{name = "great spirit potion", chance = 5000, maxCount = 2},
	{name = "lion's mane", chance = 5000},
	{name = "green crystal shard", chance = 5000, maxCount = 2},
	{name = "cyan crystal fragment", chance = 1500},
	{name = "green crystal fragment", chance = 1500},
	{name = "terra boots", chance = 5000},
	{name = "axe", chance = 5000},
	{name = "leather boots", chance = 5000},
	{name = "twin hooks", chance = 5000},
	{name = "war hammer", chance = 1500},
	{name = "combat knife", chance = 1500}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 0, minDamage = 0, maxDamage = -300},
	{name ="combat", interval = 2000, chance = 0, type = COMBAT_HOLYDAMAGE, minDamage = -300, maxDamage = -400, range = 1, effect = CONST_ME_HOLYAREA, target = false},
	{name ="combat", interval = 2000, chance = 0, type = COMBAT_HOLYDAMAGE, minDamage = -250, maxDamage = -350, range = 1, radius = 2, effect = CONST_ME_HOLYAREA, target = false},
	{name ="combat", interval = 2000, chance = 100, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -350, range = 1, radius = 2, effect = CONST_ME_EXPLOSIONAREA, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 40,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 30},
	{type = COMBAT_FIREDAMAGE, percent = 25},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -20},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 40}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
