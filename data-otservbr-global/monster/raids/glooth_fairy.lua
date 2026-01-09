local mType = Game.createMonsterType("Glooth Fairy")
local monster = {}

monster.description = "Glooth Fairy"
monster.experience = 19000
monster.outfit = {
	lookType = 600,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1058,
	bossRace = RARITY_BANE,
}

monster.health = 59000
monster.maxHealth = 59000
monster.race = "blood"
monster.corpse = 20972
monster.speed = 130
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 80,
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
	{ id = 3031, chance = 100000 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 5 }, -- Platinum Coin
	{ id = 239, chance = 30939, maxCount = 5 }, -- Great Health Potion
	{ id = 238, chance = 31489, maxCount = 5 }, -- Great Mana Potion
	{ id = 7642, chance = 37571, maxCount = 5 }, -- Great Spirit Potion
	{ id = 21103, chance = 100000, maxCount = 3 }, -- Glooth Injection Tube
	{ id = 21144, chance = 22099, maxCount = 5 }, -- Bowl of Glooth Soup
	{ id = 21143, chance = 27624, maxCount = 5 }, -- Glooth Sandwich
	{ id = 21146, chance = 23759, maxCount = 5 }, -- Glooth Steak
	{ id = 3033, chance = 9942, maxCount = 5 }, -- Small Amethyst
	{ id = 3028, chance = 13747, maxCount = 5 }, -- Small Diamond
	{ id = 3032, chance = 21546, maxCount = 5 }, -- Small Emerald
	{ id = 3030, chance = 17681, maxCount = 5 }, -- Small Ruby
	{ id = 9057, chance = 14366, maxCount = 5 }, -- Small Topaz
	{ id = 3029, chance = 13812, maxCount = 5 }, -- Small Sapphire
	{ id = 5880, chance = 16572 }, -- Iron Ore
	{ id = 3039, chance = 3865 }, -- Red Gem
	{ id = 3041, chance = 3752 }, -- Blue Gem
	{ id = 3037, chance = 3750 }, -- Yellow Gem
	{ id = 8775, chance = 16022 }, -- Gear Wheel
	{ id = 21180, chance = 19334 }, -- Glooth Axe
	{ id = 21178, chance = 18784 }, -- Glooth Club
	{ id = 21179, chance = 19891 }, -- Glooth Blade
	{ id = 21183, chance = 20992 }, -- Glooth Amulet
	{ id = 21158, chance = 20996 }, -- Glooth Spear
	{ id = 21164, chance = 8287 }, -- Glooth Cape
	{ id = 21165, chance = 7801 }, -- Rubber Cap
	{ id = 21167, chance = 7734 }, -- Heat Core
	{ id = 21292, chance = 2130 }, -- Feedbag
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1900 },
	{ name = "combat", interval = 1000, chance = 7, type = COMBAT_ENERGYDAMAGE, minDamage = -300, maxDamage = -4000, radius = 6, effect = CONST_ME_ENERGYHIT, target = false }, -- blue energy ultimate explosion
	{ name = "war golem skill reducer", interval = 2000, chance = 10, target = false }, -- reduces shield "yellow stars beam"
	{ name = "glooth fairy skill reducer", interval = 2000, chance = 5, target = false }, -- reduces magic level "great energy beam"
	{ name = "speed", interval = 2000, chance = 20, speedChange = -400, radius = 6, effect = CONST_ME_POISONAREA, target = true, duration = 60000 }, -- paralyze, poison ultimate explosion
}

monster.defenses = {
	defense = 150,
	armor = 165,
	mitigation = 2.37,
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 1000, chance = 1, type = COMBAT_HEALING, minDamage = 7500, maxDamage = 8000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
