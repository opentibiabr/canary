local mType = Game.createMonsterType("Soul of Dragonking Zyrtarch")
local monster = {}

monster.description = "soul of Dragonking Zyrtarch"
monster.experience = 70000
monster.outfit = {
	lookType = 938,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"ForgottenKnowledgeBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1289,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 150000
monster.maxHealth = 150000
monster.race = "fire"
monster.corpse = 25065
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "What have you done!?", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 389 }, -- Gold Coin
	{ id = 5948, chance = 100000 }, -- Red Dragon Leather
	{ id = 3035, chance = 100000, maxCount = 42 }, -- Platinum Coin
	{ id = 5882, chance = 100000 }, -- Red Dragon Scale
	{ id = 5889, chance = 84000 }, -- Piece of Draconian Steel
	{ id = 5904, chance = 71000 }, -- Magic Sulphur
	{ id = 16120, chance = 60000, maxCount = 5 }, -- Violet Crystal Shard
	{ id = 16121, chance = 58000, maxCount = 5 }, -- Green Crystal Shard
	{ id = 16119, chance = 57000, maxCount = 5 }, -- Blue Crystal Shard
	{ id = 7642, chance = 57000, maxCount = 15 }, -- Great Spirit Potion
	{ id = 7643, chance = 56000, maxCount = 17 }, -- Ultimate Health Potion
	{ id = 238, chance = 51000, maxCount = 13 }, -- Great Mana Potion
	{ id = 22721, chance = 26000 }, -- Gold Token
	{ id = 22516, chance = 25000 }, -- Silver Token
	{ id = 3028, chance = 25000, maxCount = 19 }, -- Small Diamond
	{ id = 3039, chance = 25000 }, -- Red Gem
	{ id = 9057, chance = 23000, maxCount = 17 }, -- Small Topaz
	{ id = 3030, chance = 23000, maxCount = 19 }, -- Small Ruby
	{ id = 3041, chance = 22000 }, -- Blue Gem
	{ id = 9058, chance = 19500 }, -- Gold Ingot
	{ id = 3037, chance = 18200 }, -- Yellow Gem
	{ id = 9067, chance = 18200 }, -- Crystal of Power
	{ id = 11652, chance = 14300 }, -- Broken Key Ring
	{ id = 3032, chance = 14300, maxCount = 18 }, -- Small Emerald
	{ id = 8895, chance = 14300 }, -- Rusted Armor
	{ id = 281, chance = 14300 }, -- Giant Shimmering Pearl
	{ id = 8074, chance = 11700 }, -- Spellbook of Mind Control
	{ id = 3033, chance = 11700, maxCount = 19 }, -- Small Amethyst
	{ id = 7430, chance = 11700 }, -- Dragonbone Staff
	{ id = 3038, chance = 11700 }, -- Green Gem
	{ id = 8896, chance = 9100 }, -- Slightly Rusted Armor
	{ id = 50259, chance = 7800 }, -- Zaoan Monk Robe
	{ id = 10388, chance = 7800 }, -- Drakinata
	{ id = 8021, chance = 6500 }, -- Modified Crossbow
	{ id = 3036, chance = 6500 }, -- Violet Gem
	{ id = 5887, chance = 6500 }, -- Piece of Royal Steel
	{ id = 24968, chance = 5200 }, -- Golden Talon
	{ id = 10391, chance = 3900 }, -- Drachaku
	{ id = 4033, chance = 2600 }, -- Draken Boots
	{ id = 24955, chance = 3700 }, -- Part of a Rune (Two)
	{ id = 24967, chance = 1300 }, -- Dragon Crown
	{ id = 3400, chance = 1300 }, -- Dragon Scale Helmet
	{ id = 24954, chance = 3700 }, -- Part of a Rune (One)
	{ id = 24956, chance = 3700 }, -- Part of a Rune (Three)
	{ id = 24957, chance = 3700 }, -- Part of a Rune (Four)
	{ id = 24958, chance = 3700 }, -- Part of a Rune (Five)
	{ id = 24959, chance = 3700 }, -- Part of a Rune (Six)
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 112, attack = 85 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -110, maxDamage = -495, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -110, maxDamage = -495, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = -110, maxDamage = -495, radius = 8, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "charged energy elemental electrify", interval = 2000, chance = 15, minDamage = -1100, maxDamage = -1100, radius = 5, effect = CONST_ME_YELLOWENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -710, maxDamage = -895, length = 9, spread = 4, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -710, maxDamage = -895, length = 9, spread = 4, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -710, maxDamage = -895, length = 9, spread = 3, effect = CONST_ME_FIREAREA, target = false },
}

monster.defenses = {
	defense = 64,
	armor = 52,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 450, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
