local mType = Game.createMonsterType("True Midnight Asura")
local monster = {}

monster.description = "a true midnight asura"
monster.experience = 7313
monster.outfit = {
	lookType = 1068,
	lookHead = 0,
	lookBody = 76,
	lookLegs = 53,
	lookFeet = 0,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 1621
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Asura Palace, Asura Vaults.",
}

monster.health = 9000
monster.maxHealth = 9000
monster.race = "blood"
monster.corpse = 28617
monster.speed = 170
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
	staticAttackChance = 80,
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
}

monster.loot = {
	{ id = 3035, chance = 97598, maxCount = 8 }, -- Platinum Coin
	{ id = 239, chance = 19078, maxCount = 2 }, -- Great Health Potion
	{ id = 678, chance = 11805, maxCount = 3 }, -- Small Enchanted Amethyst
	{ id = 3017, chance = 10002 }, -- Silver Brooch
	{ id = 3026, chance = 7373, maxCount = 2 }, -- White Pearl
	{ id = 3027, chance = 9160, maxCount = 2 }, -- Black Pearl
	{ id = 3028, chance = 14372, maxCount = 3 }, -- Small Diamond
	{ id = 3029, chance = 11123, maxCount = 3 }, -- Small Sapphire
	{ id = 3030, chance = 8320, maxCount = 2 }, -- Small Ruby
	{ id = 3032, chance = 8144, maxCount = 2 }, -- Small Emerald
	{ id = 3043, chance = 5318, maxCount = 3 }, -- Crystal Coin
	{ id = 5944, chance = 18716 }, -- Soul Orb
	{ id = 6499, chance = 14424 }, -- Demonic Essence
	{ id = 6558, chance = 19256 }, -- Flask of Demonic Blood
	{ id = 7368, chance = 9834, maxCount = 5 }, -- Assassin Star
	{ id = 9057, chance = 8030, maxCount = 2 }, -- Small Topaz
	{ id = 21974, chance = 21847 }, -- Golden Lotus Brooch
	{ id = 21975, chance = 21110 }, -- Peacock Feather Fan
	{ id = 3036, chance = 1995 }, -- Violet Gem
	{ id = 3037, chance = 1154 }, -- Yellow Gem
	{ id = 3041, chance = 1568 }, -- Blue Gem
	{ id = 3054, chance = 1850 }, -- Silver Amulet
	{ id = 3069, chance = 3512 }, -- Necrotic Rod
	{ id = 3403, chance = 2858 }, -- Tribal Mask
	{ id = 7404, chance = 1532 }, -- Assassin Dagger
	{ id = 8082, chance = 1165 }, -- Underworld Rod
	{ id = 9058, chance = 2016 }, -- Gold Ingot
	{ id = 21981, chance = 1663 }, -- Oriental Shoes
	{ id = 25759, chance = 3735, maxCount = 3 }, -- Royal Star
	{ id = 3007, chance = 827 }, -- Crystal Ring
	{ id = 3567, chance = 814 }, -- Blue Robe
	{ id = 8061, chance = 586 }, -- Skullcracker Armor
	{ id = 8074, chance = 818 }, -- Spellbook of Mind Control
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -650, range = 5, effect = CONST_ME_MORTAREA, target = true }, --Death Missile
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -50, maxDamage = -280, range = 7, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -240, length = 8, spread = 0, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -700, length = 8, spread = 0, effect = CONST_ME_BLACKSMOKE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -100, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000 },
}

monster.defenses = {
	defense = 55,
	armor = 75,
	mitigation = 2.16,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
	{ name = "invisible", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
