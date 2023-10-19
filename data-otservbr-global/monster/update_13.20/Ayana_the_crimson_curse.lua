local mType = Game.createMonsterType("Ayana the crimson curse")
local monster = {}

monster.description = "Ayana the crimson curse"
monster.experience = 12400
monster.outfit = {
	lookType = 1647,
	lookHead = 57,
	lookBody = 132,
	lookLegs = 2,
	lookFeet = 95,
	lookAddons = 2,
	lookMount = 0
}

monster.health = 17000
monster.maxHealth = 17000
monster.race = "undead"
monster.corpse = 44039
monster.speed = 180
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.bosstiary = {
	bossRaceId = 2404,
	bossRace = RARITY_NEMESIS
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
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {

}

monster.loot = {
	{ name = "platinum coin", chance = 5681, maxCount = 17 },
	{ name = "small ruby", chance = 8283, maxCount = 4 },
	{ name = "magma amulet", chance = 2333, maxCount = 1 },
	{ id = 3039, chance = 1695, maxCount = 1 }, -- red gem
	{ name = "moonlight crystals", chance = 12444, maxCount = 2 },
	{ name = "werecrocodile tongue", chance = 3098, maxCount = 1 },
	{ name = "sun brooch", chance = 3102, maxCount = 1 },
	{ name = "demonrage sword", chance = 2091, maxCount = 1 },
	{ name = "golden sun coin", chance = 3157, maxCount = 1 },
	{ name = "closed pocket sundial", chance = 1575, maxCount = 1 },
	{ name = "ornate crossbow", chance = 1514, maxCount = 1 },
	{ name = "violet gem", chance = 3586, maxCount = 1 },
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 75, attack = 100},
	{name ="combat", interval = 1000, chance = 8, type = COMBAT_DEATHDAMAGE, minDamage = -300, maxDamage = -500, radius = 9, effect = CONST_ME_MORTAREA, target = false},
	{name ="speed", interval = 1000, chance = 12, speedChange = -250, radius = 6, effect = CONST_ME_POISONAREA, target = false, duration = 60000},
	{name ="strength", interval = 1000, chance = 10, minDamage = -300, maxDamage = -750, radius = 5, effect = CONST_ME_HITAREA, target = false},
	{name ="combat", interval = 3000, chance = 13, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -500, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = 244, target = true},
	{name ="combat", interval = 3000, chance = 8, type = COMBAT_HOLYDAMAGE, minDamage = -300, maxDamage = -450, radius = 10, effect = 246, target = false}
}

monster.defenses = {
	defense = 110,
	armor = 110
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 25},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = 20},
	{type = COMBAT_FIREDAMAGE, percent = 35},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -15},
	{type = COMBAT_HOLYDAMAGE , percent = -20},
	{type = COMBAT_DEATHDAMAGE , percent = 60}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
