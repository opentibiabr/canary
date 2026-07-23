local mType = Game.createMonsterType("Lisa")
local monster = {}

monster.description = "Lisa"
monster.experience = 18000
monster.outfit = {
	lookType = 604,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1059,
	bossRace = RARITY_BANE,
}

monster.health = 55000
monster.maxHealth = 55000
monster.race = "venom"
monster.corpse = 20988
monster.speed = 100
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 3,
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
	{ id = 21197, chance = 100000, maxCount = 5 }, -- Slimy Leaf Tentacle
	{ id = 238, chance = 38000, maxCount = 9 }, -- Great Mana Potion
	{ id = 239, chance = 34000, maxCount = 9 }, -- Great Health Potion
	{ id = 21143, chance = 30000, maxCount = 9 }, -- Glooth Sandwich
	{ id = 21146, chance = 30000, maxCount = 9 }, -- Glooth Steak
	{ id = 7642, chance = 28000, maxCount = 9 }, -- Great Spirit Potion
	{ id = 21180, chance = 28000 }, -- Glooth Axe
	{ id = 21144, chance = 23000, maxCount = 9 }, -- Bowl of Glooth Soup
	{ id = 3032, chance = 21000, maxCount = 9 }, -- Small Emerald
	{ id = 9057, chance = 18900, maxCount = 8 }, -- Small Topaz
	{ id = 21158, chance = 18900, maxCount = 8 }, -- Glooth Spear
	{ id = 3029, chance = 18900, maxCount = 9 }, -- Small Sapphire
	{ id = 21179, chance = 18900 }, -- Glooth Blade
	{ id = 21178, chance = 17000 }, -- Glooth Club
	{ id = 3033, chance = 11300, maxCount = 9 }, -- Small Amethyst
	{ id = 21172, chance = 11300 }, -- Glooth Whip
	{ id = 3028, chance = 11300, maxCount = 9 }, -- Small Diamond
	{ id = 21183, chance = 9400 }, -- Glooth Amulet
	{ id = 21164, chance = 7500 }, -- Glooth Cape
	{ id = 3037, chance = 5700 }, -- Yellow Gem
	{ id = 3030, chance = 5700, maxCount = 8 }, -- Small Ruby
	{ id = 3039, chance = 5700 }, -- Red Gem
	{ id = 3041, chance = 1900 }, -- Blue Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 150, attack = 100, condition = { type = CONDITION_POISON, totalDamage = 900, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -200, maxDamage = -400, range = 7, radius = 1, shootEffect = CONST_ANI_GREENSTAR, effect = CONST_ME_MORTAREA, target = true },
	{ name = "effect", interval = 2000, chance = 15, range = 7, radius = 6, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_BIGPLANTS, target = true },
	{ name = "effect", interval = 2000, chance = 15, range = 7, radius = 6, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_PLANTATTACK, target = true },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_MANADRAIN, minDamage = -100, maxDamage = -200, radius = 8, effect = CONST_ME_POISONAREA, target = false },
	{ name = "lisa paralyze", interval = 2000, chance = 12, target = false },
	{ name = "lisa skill reducer", interval = 2000, chance = 15, target = false },
	{ name = "lisa wave", interval = 2000, chance = 11, minDamage = -400, maxDamage = -900, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 15,
	--	mitigation = ???,
	{ name = "lisa summon", interval = 2000, chance = 5, target = false },
	{ name = "lisa heal", interval = 1000, chance = 100, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
