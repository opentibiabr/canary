local mType = Game.createMonsterType("Irgix The Flimsy")
local monster = {}

monster.description = "Irgix The Flimsy"
monster.experience = 18000
monster.outfit = {
	lookType = 1268,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 94,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 24000
monster.maxHealth = 24000
monster.race = "undead"
monster.corpse = 32610
monster.speed = 142
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 1890,
	bossRace = RARITY_ARCHFOE,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = true,
	illusionable = true,
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
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ name = "platinum coin", chance = 10000, maxCount = 8 },
	{ name = "skull coin", chance = 66670 },
	{ name = "diamond", chance = 400 },
	{ name = "silver hand mirror", chance = 1000, maxCount = 2 },
	{ name = "white gem", chance = 33333 },
	{ name = "terra rod", chance = 16670 },
	{ name = "yellow gem", chance = 16670 },
	{ id = 3039, chance = 16670 }, -- red gem
	{ name = "necklace of the deep", chance = 1000 },
	{ name = "wand of starstorm", chance = 1000 },
	{ name = "wand of cosmic energy", chance = 1000 },
	{ name = "death toll", chance = 1000 },
	{ name = "pair of nightmare boots", chance = 230 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -500 },
	{ name = "combat", interval = 1500, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -500, radius = 3, shootEffect = CONST_ANI_ENVENOMEDARROW, effect = CONST_ME_HITBYPOISON, target = true },
	{ name = "combat", interval = 1500, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -300, maxDamage = -650, length = 4, spread = 0, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 1500, chance = 35, type = COMBAT_DEATHDAMAGE, minDamage = -300, maxDamage = -650, radius = 4, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 1500, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -300, maxDamage = -650, radius = 4, effect = CONST_ME_ENERGYAREA, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 82,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 80 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
