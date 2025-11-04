local mType = Game.createMonsterType("Glooth Brigand")
local monster = {}

monster.description = "a glooth brigand"
monster.experience = 1900
monster.outfit = {
	lookType = 137,
	lookHead = 114,
	lookBody = 114,
	lookLegs = 110,
	lookFeet = 114,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1120
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

monster.health = 2400
monster.maxHealth = 2400
monster.race = "blood"
monster.corpse = 21888
monster.speed = 160
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
	{ id = 3035, chance = 79900, maxCount = 3 }, -- Platinum Coin
	{ id = 238, chance = 3480 }, -- Great Mana Potion
	{ id = 7643, chance = 3450 }, -- Ultimate Health Potion
	{ id = 7642, chance = 3550 }, -- Great Spirit Potion
	{ id = 21146, chance = 2500 }, -- Glooth Steak
	{ id = 21816, chance = 8029 }, -- Tainted Glooth Capsule
	{ id = 21814, chance = 3110 }, -- Glooth Capsule
	{ id = 21203, chance = 9810, maxCount = 2 }, -- Glooth Bag
	{ id = 21179, chance = 1000 }, -- Glooth Blade
	{ id = 21165, chance = 640 }, -- Rubber Cap
	{ id = 813, chance = 480 }, -- Terra Boots
	{ id = 21143, chance = 2480 }, -- Glooth Sandwich
	{ id = 281, chance = 1490 }, -- Giant Shimmering Pearl (Green)
	{ id = 3038, chance = 200 }, -- Green Gem
	{ id = 830, chance = 700 }, -- Terra Hood
	{ id = 811, chance = 600 }, -- Terra Mantle
	{ id = 814, chance = 390 }, -- Terra Amulet
	{ id = 7386, chance = 150 }, -- Mercenary Sword
	{ id = 812, chance = 500 }, -- Terra Legs
	{ id = 21183, chance = 980 }, -- Glooth Amulet
	{ id = 21180, chance = 980 }, -- Glooth Axe
	{ id = 21178, chance = 1000 }, -- Glooth Club
	{ id = 21158, chance = 990 }, -- Glooth Spear
	{ id = 21167, chance = 160 }, -- Heat Core
	{ id = 7412, chance = 50 }, -- Butcher's Axe
	{ id = 7419, chance = 100 }, -- Dreaded Cleaver
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 80, attack = 68 },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_PHYSICALDAMAGE, minDamage = -40, maxDamage = -200, range = 8, shootEffect = CONST_ANI_ARROW, target = false },
}

monster.defenses = {
	defense = 26,
	armor = 51,
	mitigation = 1.74,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 200, maxDamage = 245, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
