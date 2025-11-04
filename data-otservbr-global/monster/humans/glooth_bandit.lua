local mType = Game.createMonsterType("Glooth Bandit")
local monster = {}

monster.description = "a glooth bandit"
monster.experience = 2000
monster.outfit = {
	lookType = 129,
	lookHead = 115,
	lookBody = 80,
	lookLegs = 114,
	lookFeet = 114,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1119
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Underground Glooth Factory.",
}

monster.health = 2600
monster.maxHealth = 2600
monster.race = "blood"
monster.corpse = 21882
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 5,
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
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
	{ id = 3031, chance = 100000, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 60050, maxCount = 3 }, -- Platinum Coin
	{ id = 7643, chance = 3439 }, -- Ultimate Health Potion
	{ id = 238, chance = 7430, maxCount = 2 }, -- Great Mana Potion
	{ id = 7642, chance = 3460 }, -- Great Spirit Potion
	{ id = 239, chance = 8090 }, -- Great Health Potion
	{ id = 3032, chance = 2040, maxCount = 2 }, -- Small Emerald
	{ id = 9057, chance = 2530, maxCount = 2 }, -- Small Topaz
	{ id = 21203, chance = 5090 }, -- Glooth Bag
	{ id = 21165, chance = 730 }, -- Rubber Cap
	{ id = 21146, chance = 2600 }, -- Glooth Steak
	{ id = 21143, chance = 2460 }, -- Glooth Sandwich
	{ id = 21183, chance = 1000 }, -- Glooth Amulet
	{ id = 21179, chance = 1000 }, -- Glooth Blade
	{ id = 21814, chance = 3040 }, -- Glooth Capsule
	{ id = 21816, chance = 8020 }, -- Tainted Glooth Capsule
	{ id = 21178, chance = 1010 }, -- Glooth Club
	{ id = 830, chance = 610 }, -- Terra Hood
	{ id = 811, chance = 600 }, -- Terra Mantle
	{ id = 812, chance = 490 }, -- Terra Legs
	{ id = 813, chance = 490 }, -- Terra Boots
	{ id = 21164, chance = 580 }, -- Glooth Cape
	{ id = 3324, chance = 419 }, -- Skull Staff
	{ id = 3344, chance = 800 }, -- Beastslayer Axe
	{ id = 21180, chance = 1020 }, -- Glooth Axe
	{ id = 3342, chance = 100 }, -- War Axe
	{ id = 21158, chance = 1010 }, -- Glooth Spear
	{ id = 3038, chance = 160 }, -- Green Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 80, attack = 68 },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_PHYSICALDAMAGE, minDamage = -60, maxDamage = -200, range = 8, shootEffect = CONST_ANI_ARROW, target = false },
}

monster.defenses = {
	defense = 32,
	armor = 46,
	mitigation = 1.65,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
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
