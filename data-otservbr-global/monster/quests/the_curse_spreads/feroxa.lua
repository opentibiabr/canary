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
	{ id = 22083, chance = 100000, maxCount = 9 }, -- Moonlight Crystals
	{ id = 3035, chance = 100000, maxCount = 32 }, -- Platinum Coin
	{ id = 238, chance = 68000, maxCount = 10 }, -- Great Mana Potion
	{ id = 3028, chance = 64000, maxCount = 5 }, -- Small Diamond
	{ id = 7643, chance = 64000, maxCount = 9 }, -- Ultimate Health Potion
	{ id = 16120, chance = 63000, maxCount = 3 }, -- Violet Crystal Shard
	{ id = 3030, chance = 58000, maxCount = 8 }, -- Small Ruby
	{ id = 16126, chance = 53000 }, -- Red Crystal Fragment
	{ id = 239, chance = 53000, maxCount = 9 }, -- Great Health Potion
	{ id = 3039, chance = 46000 }, -- Red Gem
	{ id = 3041, chance = 46000 }, -- Blue Gem
	{ id = 22104, chance = 31000 }, -- Trophy of Feroxa
	{ id = 3031, chance = 25000, maxCount = 381 }, -- Gold Coin
	{ id = 16119, chance = 24000, maxCount = 9 }, -- Blue Crystal Shard
	{ id = 16124, chance = 22000, maxCount = 9 }, -- Blue Crystal Splinter
	{ id = 22087, chance = 13600 }, -- Wereboar Loincloth
	{ id = 7642, chance = 13600, maxCount = 8 }, -- Great Spirit Potion
	{ id = 16123, chance = 13600, maxCount = 8 }, -- Brown Crystal Splinter
	{ id = 3029, chance = 11900, maxCount = 9 }, -- Small Sapphire
	{ id = 16122, chance = 11900, maxCount = 9 }, -- Green Crystal Splinter
	{ id = 22085, chance = 11900 }, -- Fur Armor
	{ id = 22086, chance = 11900 }, -- Badger Boots
	{ id = 8094, chance = 10200 }, -- Wand of Voodoo
	{ id = 9057, chance = 10200, maxCount = 8 }, -- Small Topaz
	{ id = 16121, chance = 10200, maxCount = 9 }, -- Green Crystal Shard
	{ id = 3070, chance = 8500 }, -- Moonlight Rod
	{ id = 22060, chance = 8500 }, -- Werewolf Amulet
	{ id = 7419, chance = 6800 }, -- Dreaded Cleaver
	{ id = 3033, chance = 6800, maxCount = 8 }, -- Small Amethyst
	{ id = 8082, chance = 6800 }, -- Underworld Rod
	{ id = 22084, chance = 5100 }, -- Wolf Backpack
	{ id = 22062, chance = 5100 }, -- Werewolf Helmet
	{ id = 7428, chance = 5100 }, -- Bonebreaker
	{ id = 7436, chance = 3400 }, -- Angelic Axe
	{ id = 7454, chance = 3400 }, -- Glorious Axe
	{ id = 3079, chance = 3400 }, -- Boots of Haste
	{ id = 7383, chance = 1700 }, -- Relic Sword
	{ id = 3326, chance = 1700 }, -- Epee
	{ id = 3032, chance = 1700, maxCount = 3 }, -- Small Emerald
	{ id = 3081, chance = 1700 }, -- Stone Skin Amulet
	{ id = 8061, chance = 25000 }, -- Skullcracker Armor
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
