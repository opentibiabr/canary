local mType = Game.createMonsterType("Stampor")
local monster = {}

monster.description = "a stampor"
monster.experience = 780
monster.outfit = {
	lookType = 381,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 694
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Stampor Cave on the Muggy Plains, Chyllfroest.",
}

monster.health = 1200
monster.maxHealth = 1200
monster.race = "blood"
monster.corpse = 12325
monster.speed = 220
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "KRRRRRNG", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 94500, maxCount = 242 }, -- Gold Coin
	{ id = 3035, chance = 9930, maxCount = 2 }, -- Platinum Coin
	{ id = 9057, chance = 7829, maxCount = 2 }, -- Small Topaz
	{ id = 12313, chance = 9840, maxCount = 2 }, -- Stampor Talons
	{ id = 236, chance = 4840, maxCount = 2 }, -- Strong Health Potion
	{ id = 237, chance = 4990, maxCount = 2 }, -- Strong Mana Potion
	{ id = 12312, chance = 4960 }, -- Stampor Horn
	{ id = 12314, chance = 3080 }, -- Hollow Stampor Hoof
	{ id = 3279, chance = 980 }, -- War Hammer
	{ id = 3370, chance = 820 }, -- Knight Armor
	{ id = 7452, chance = 189 }, -- Spiked Squelcher
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -130 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -150, maxDamage = -280, radius = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -75, maxDamage = -100, shootEffect = CONST_ANI_SMALLSTONE, target = true },
	{ name = "stampor skill reducer", interval = 2000, chance = 10, range = 5, target = false },
}

monster.defenses = {
	defense = 0,
	armor = 60,
	mitigation = 0.91,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 90, maxDamage = 120, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
