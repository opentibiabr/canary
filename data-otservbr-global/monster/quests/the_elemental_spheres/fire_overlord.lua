local mType = Game.createMonsterType("Fire Overlord")
local monster = {}

monster.description = "Fire Overlord"
monster.experience = 2800
monster.outfit = {
	lookType = 243,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"ElementalOverlordDeath",
}

monster.health = 4000
monster.maxHealth = 4000
monster.race = "fire"
monster.corpse = 8136
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 5,
	color = 212,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 946, chance = 100000 }, -- Eternal Flames
	{ id = 9636, chance = 100000 }, -- Fiery Heart
	{ id = 3031, chance = 70709, maxCount = 75 }, -- Gold Coin
	{ id = 3035, chance = 51878, maxCount = 3 }, -- Platinum Coin
	{ id = 12600, chance = 1000 }, -- Coal
	{ id = 8049, chance = 1000 }, -- Lavos Armor
	{ id = 826, chance = 450 }, -- Magma Coat
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450, condition = { type = CONDITION_FIRE, totalDamage = 650, interval = 9000 } },
	{ name = "firefield", interval = 2000, chance = 15, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, target = true },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -900, length = 1, spread = 0, effect = CONST_ME_FIREATTACK, target = false },
	{ name = "combat", interval = 1000, chance = 13, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -350, radius = 4, effect = CONST_ME_FIREAREA, target = true },
}

monster.defenses = {
	defense = 25,
	armor = 25,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 1 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 80 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -25 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
