local mType = Game.createMonsterType("Mahrdis")
local monster = {}

monster.description = "Mahrdis"
monster.experience = 3050
monster.outfit = {
	lookType = 90,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 3900
monster.maxHealth = 3900
monster.race = "undead"
monster.corpse = 6025
monster.speed = 340
monster.manaCost = 0
monster.maxSummons = 4

monster.changeTarget = {
	interval = 5000,
	chance = 8
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	canWalkOnPoison = false,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.summons = {
	{name = "Fire Elemental", chance = 30, interval = 2000}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Ashes to ashes!", yell = false},
	{text = "Fire, Fire!", yell = false},
	{text = "The eternal flame demands its due!", yell = false},
	{text = "This is why I'm hot.", yell = false},
	{text = "May my flames engulf you!", yell = false},
	{text = "Burnnnnnnnnn!", yell = false}
}

monster.loot = {
	{name = "holy falcon", chance = 500},
	{name = "small ruby", chance = 7000, maxCount = 3},
	{name = "gold coin", chance = 50000, maxCount = 80},
	{name = "gold coin", chance = 50000, maxCount = 70},
	{name = "gold coin", chance = 50000, maxCount = 64},
	{name = "red gem", chance = 1500},
	{name = "life ring", chance = 1500},
	{name = "burning heart", chance = 100000},
	{name = "fire axe", chance = 750},
	{name = "phoenix shield", chance = 300},
	{name = "great health potion", chance = 1500}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400, condition = {type = CONDITION_POISON, totalDamage = 65, interval = 4000}},
	{name ="combat", interval = 1600, chance = 7, type = COMBAT_PHYSICALDAMAGE, minDamage = -60, maxDamage = -600, range = 1, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="combat", interval = 1000, chance = 7, type = COMBAT_FIREDAMAGE, minDamage = -60, maxDamage = -600, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false},
	{name ="speed", interval = 2000, chance = 13, speedChange = -850, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 50000},
	{name ="combat", interval = 2000, chance = 34, type = COMBAT_FIREDAMAGE, minDamage = -80, maxDamage = -800, radius = 3, effect = CONST_ME_EXPLOSIONAREA, target = false},
	{name ="firefield", interval = 1000, chance = 12, radius = 4, effect = CONST_ME_BLOCKHIT, target = false},
	-- fire
	{name ="condition", type = CONDITION_FIRE, interval = 2000, chance = 13, minDamage = -50, maxDamage = -500, length = 8, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false}
}

monster.defenses = {
	defense = 30,
	armor = 20,
	{name ="combat", interval = 1000, chance = 20, type = COMBAT_HEALING, minDamage = 20, maxDamage = 800, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 45},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -25},
	{type = COMBAT_HOLYDAMAGE , percent = -22},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
