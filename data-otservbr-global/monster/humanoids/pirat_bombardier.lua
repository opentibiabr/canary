local mType = Game.createMonsterType("Pirat Bombardier")
local monster = {}

monster.description = "a pirat bombardier"
monster.experience = 1700
monster.outfit = {
	lookType = 1346,
	lookHead = 57,
	lookBody = 125,
	lookLegs = 86,
	lookFeet = 67,
	lookAddons = 2,
	lookMount = 0,
}

monster.raceId = 2038
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Pirat Mine, The Wreckoning",
}

monster.health = 2300
monster.maxHealth = 2300
monster.race = "blood"
monster.corpse = 35384
monster.speed = 185
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 50,
	healthHidden = false,
	isBlockable = true,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
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
	{ id = 238, chance = 34530, maxCount = 2 }, -- Great Mana Potion
	{ id = 813, chance = 6000 }, -- Terra Boots
	{ id = 35572, chance = 7250, maxCount = 10 }, -- Pirate Coin
	{ id = 35596, chance = 4240 }, -- Mouldy Powder
	{ id = 35573, chance = 5050 }, -- Pirat's Tail
	{ id = 818, chance = 3760 }, -- Magma Boots
	{ id = 820, chance = 1580 }, -- Lightning Boots
	{ id = 23529, chance = 2410 }, -- Ring of Blue Plasma
	{ id = 3575, chance = 1689 }, -- Wood Cape
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -0, maxDamage = -350 },
	{ name = "energy beam", interval = 2000, chance = 10, minDamage = -80, maxDamage = -160, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "energy wave", interval = 2000, chance = 10, minDamage = -35, maxDamage = -75, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 65,
	mitigation = 1.82,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 30, maxDamage = 60, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
