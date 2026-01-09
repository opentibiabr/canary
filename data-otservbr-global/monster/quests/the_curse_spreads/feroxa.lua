local mType = Game.createMonsterType("Feroxa")
local monster = {}

monster.description = "Feroxa"
monster.experience = 0
monster.outfit = {
	lookType = 158,
	lookHead = 57,
	lookBody = 76,
	lookLegs = 77,
	lookFeet = 57,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 100000
monster.maxHealth = 100000
monster.race = "blood"
monster.corpse = 0
monster.speed = 175
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 2,
}

monster.bosstiary = {
	bossRaceId = 1149,
	bossRace = RARITY_NEMESIS,
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
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.events = {
	"FeroxaTransform",
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
	{ id = 3035, chance = 93548, maxCount = 20 }, -- Platinum Coin
	{ id = 239, chance = 55913 }, -- Great Health Potion
	{ id = 7643, chance = 64516, maxCount = 5 }, -- Ultimate Health Potion
	{ id = 238, chance = 73118, maxCount = 2 }, -- Great Mana Potion
	{ id = 16126, chance = 49462 }, -- Red Crystal Fragment
	{ id = 16124, chance = 22352 }, -- Blue Crystal Splinter
	{ id = 3028, chance = 65591, maxCount = 5 }, -- Small Diamond
	{ id = 16120, chance = 61290 }, -- Violet Crystal Shard
	{ id = 16119, chance = 23529, maxCount = 5 }, -- Blue Crystal Shard
	{ id = 7419, chance = 9677 }, -- Dreaded Cleaver
	{ id = 3039, chance = 50537 }, -- Red Gem
	{ id = 3041, chance = 50537 }, -- Blue Gem
	{ id = 22083, chance = 100000, maxCount = 6 }, -- Moonlight Crystals
	{ id = 22060, chance = 9411 }, -- Werewolf Amulet
	{ id = 22104, chance = 31182 }, -- Trophy of Feroxa
	{ id = 22084, chance = 7692 }, -- Wolf Backpack
	{ id = 22062, chance = 7526 }, -- Werewolf Helmet
	{ id = 22086, chance = 14285 }, -- Badger Boots
	{ id = 22085, chance = 10588 }, -- Fur Armor
	{ id = 7436, chance = 2857 }, -- Angelic Axe
	{ id = 8061, chance = 25000 }, -- Skullcracker Armor
	{ id = 3030, chance = 61290 }, -- Small Ruby
	{ id = 3079, chance = 5454 }, -- Boots of Haste
	{ id = 16123, chance = 11764 }, -- Brown Crystal Splinter
	{ id = 16121, chance = 11764 }, -- Green Crystal Shard
	{ id = 3070, chance = 10588 }, -- Moonlight Rod
	{ id = 22087, chance = 15294 }, -- Wereboar Loincloth
	{ id = 8082, chance = 7058 }, -- Underworld Rod
	{ id = 7642, chance = 14117 }, -- Great Spirit Potion
	{ id = 3029, chance = 14117 }, -- Small Sapphire
	{ id = 3326, chance = 2857 }, -- Epee
	{ id = 3031, chance = 23529 }, -- Gold Coin
	{ id = 16122, chance = 14117 }, -- Green Crystal Splinter
	{ id = 3033, chance = 7058 }, -- Small Amethyst
	{ id = 8094, chance = 8571 }, -- Wand of Voodoo
	{ id = 7428, chance = 5882 }, -- Bonebreaker
	{ id = 3081, chance = 4705 }, -- Stone Skin Amulet
	{ id = 9057, chance = 8571 }, -- Small Topaz
	{ id = 7454, chance = 3225 }, -- Glorious Axe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1400, maxDamage = -1800 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -700, maxDamage = -1250, radius = 6, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = -700, maxDamage = -1250, radius = 5, effect = CONST_ME_ICETORNADO, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -700, maxDamage = -1250, range = 6, shootEffect = CONST_ANI_ARROW, effect = CONST_ME_EXPLOSIONAREA, target = true },
}

monster.defenses = {
	defense = 55,
	armor = 50,
	{ name = "speed", interval = 2000, chance = 12, speedChange = 1250, effect = CONST_ME_THUNDER, target = false, duration = 10000 },
	{ name = "feroxa summon", interval = 2000, chance = 20, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
