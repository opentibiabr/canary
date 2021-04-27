local mType = Game.createMonsterType("Thalas")
local monster = {}

monster.description = "Thalas"
monster.experience = 2950
monster.outfit = {
	lookType = 90,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 4100
monster.maxHealth = 4100
monster.race = "undead"
monster.corpse = 6025
monster.speed = 320
monster.manaCost = 0
monster.maxSummons = 8

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
	{name = "Slime", chance = 100, interval = 2000, max = 8}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "You will become a feast for my maggots!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 50000, maxCount = 80},
	{name = "gold coin", chance = 50000, maxCount = 80},
	{name = "small emerald", chance = 7000, maxCount = 3},
	{name = "green gem", chance = 500},
	{name = "stealth ring", chance = 1500},
	{id = 2169, chance = 7000},
	{name = "cobrafang dagger", chance = 100000},
	{name = "serpent sword", chance = 500},
	{name = "poison dagger", chance = 7000},
	{name = "djinn blade", chance = 200},
	{name = "great health potion", chance = 1500}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900},
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_EARTHDAMAGE, minDamage = -150, maxDamage = -650, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false},
	{name ="melee", interval = 3000, chance = 20, minDamage = -150, maxDamage = -650},
	{name ="speed", interval = 1000, chance = 6, speedChange = -800, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 1000, chance = 15, minDamage = -34, maxDamage = -35, radius = 5, effect = CONST_ME_POISONAREA, target = false},
	{name ="combat", interval = 3000, chance = 17, type = COMBAT_EARTHDAMAGE, minDamage = -55, maxDamage = -550, length = 8, spread = 3, effect = CONST_ME_POISONAREA, target = false}
}

monster.defenses = {
	defense = 30,
	armor = 20,
	{name ="combat", interval = 1000, chance = 20, type = COMBAT_HEALING, minDamage = 150, maxDamage = 450, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -23},
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
