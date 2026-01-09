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
	{ id = 3031, chance = 1000 }, -- Gold Coin
	{ id = 3030, chance = 6451, maxCount = 5 }, -- Small Ruby
	{ id = 3033, chance = 11320, maxCount = 5 }, -- Small Amethyst
	{ id = 9057, chance = 17741, maxCount = 5 }, -- Small Topaz
	{ id = 21197, chance = 100000, maxCount = 3 }, -- Slimy Leaf Tentacle
	{ id = 21143, chance = 30645, maxCount = 5 }, -- Glooth Sandwich
	{ id = 21146, chance = 29032, maxCount = 5 }, -- Glooth Steak
	{ id = 21144, chance = 22580, maxCount = 3 }, -- Bowl of Glooth Soup
	{ id = 238, chance = 37096, maxCount = 5 }, -- Great Mana Potion
	{ id = 239, chance = 33870, maxCount = 5 }, -- Great Health Potion
	{ id = 7642, chance = 29032, maxCount = 5 }, -- Great Spirit Potion
	{ id = 21178, chance = 20967 }, -- Glooth Club
	{ id = 21180, chance = 28301 }, -- Glooth Axe
	{ id = 21179, chance = 17741 }, -- Glooth Blade
	{ id = 21218, chance = 1000 }, -- Lisa's Doll
	{ id = 21172, chance = 11290 }, -- Glooth Whip
	{ id = 3032, chance = 24193 }, -- Small Emerald
	{ id = 3029, chance = 17741 }, -- Small Sapphire
	{ id = 3028, chance = 11290 }, -- Small Diamond
	{ id = 21164, chance = 8064 }, -- Glooth Cape
	{ id = 3039, chance = 6451 }, -- Red Gem
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
