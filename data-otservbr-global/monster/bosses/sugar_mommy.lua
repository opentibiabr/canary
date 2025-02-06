local mType = Game.createMonsterType("Sugar Mommy")
local monster = {}

monster.description = "Sugar Mommy"
monster.experience = 6800
monster.outfit = {
	lookType = 1764,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 1,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 2580,
	bossRace = RARITY_BANE,
}

monster.health = 6000
monster.maxHealth = 6000
monster.race = "blood"
monster.corpse = 48414
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 20,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 98,
	targetDistance = 3,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "SUGAR!!!", yell = false },
}

monster.loot = {
	{ name = "platinum coin", chance = 100000, maxCount = 11 },
	{ name = "cherry", chance = 100000, maxCount = 2 },
	{ id = 3039, chance = 11465, maxCount = 1 }, -- red gem
	{ id = 3037, chance = 9500 }, -- yellow gem
	{ id = 3038, chance = 4760 }, -- green gem
	{ id = 48250, chance = 28555, maxCount = 11 }, -- dark chocolate coin
	{ id = 48249, chance = 26465, maxCount = 12 }, -- milk chocolate coin
	{ id = 48273, chance = 16465, maxCount = 1 }, -- taiyaki ice cream
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 20, minDamage = 0, maxDamage = -350 },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_ENERGYDAMAGE, minDamage = -70, maxDamage = -180, range = 6, shootEffect = CONST_ANI_CHERRYBOMB, target = true },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -170, maxDamage = -280, radius = 6, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -250, maxDamage = -310, radius = 4, effect = CONST_ME_POWERFUL_HEARTS, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 55,
	--	mitigation = ???,
	{ name = "combat", interval = 3000, chance = 25, type = COMBAT_HEALING, minDamage = 400, maxDamage = 600, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -5 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
