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
	{ id = 21103, chance = 100000, maxCount = 5 }, -- Glooth Injection Tube
	{ id = 3031, chance = 100000, maxCount = 198 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 9 }, -- Platinum Coin
	{ id = 238, chance = 43000, maxCount = 9 }, -- Great Mana Potion
	{ id = 21158, chance = 33000, maxCount = 9 }, -- Glooth Spear
	{ id = 7642, chance = 33000, maxCount = 9 }, -- Great Spirit Potion
	{ id = 21146, chance = 30000, maxCount = 9 }, -- Glooth Steak
	{ id = 21143, chance = 30000, maxCount = 8 }, -- Glooth Sandwich
	{ id = 21180, chance = 28000 }, -- Glooth Axe
	{ id = 239, chance = 25000, maxCount = 9 }, -- Great Health Potion
	{ id = 3029, chance = 23000, maxCount = 6 }, -- Small Sapphire
	{ id = 21144, chance = 23000, maxCount = 8 }, -- Bowl of Glooth Soup
	{ id = 3030, chance = 17500, maxCount = 9 }, -- Small Ruby
	{ id = 3032, chance = 17500, maxCount = 9 }, -- Small Emerald
	{ id = 21167, chance = 17500 }, -- Heat Core
	{ id = 21178, chance = 17500 }, -- Glooth Club
	{ id = 21183, chance = 15000 }, -- Glooth Amulet
	{ id = 9057, chance = 15000, maxCount = 9 }, -- Small Topaz
	{ id = 8775, chance = 15000 }, -- Gear Wheel
	{ id = 5880, chance = 10000 }, -- Iron Ore
	{ id = 3037, chance = 7500 }, -- Yellow Gem
	{ id = 3028, chance = 7500, maxCount = 7 }, -- Small Diamond
	{ id = 21179, chance = 7500 }, -- Glooth Blade
	{ id = 21164, chance = 7500 }, -- Glooth Cape
	{ id = 3033, chance = 5000, maxCount = 2 }, -- Small Amethyst
	{ id = 3039, chance = 5000 }, -- Red Gem
	{ id = 3041, chance = 2500 }, -- Blue Gem
	{ id = 21165, chance = 7500 }, -- Rubber Cap
	{ id = 21292, chance = 1670 }, -- Feedbag
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
