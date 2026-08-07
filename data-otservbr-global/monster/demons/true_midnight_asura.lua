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
	{ id = 3035, chance = 91000, maxCount = 3 }, -- Platinum Coin
	{ id = 21974, chance = 19900 }, -- Golden Lotus Brooch
	{ id = 21975, chance = 19500 }, -- Peacock Feather Fan
	{ id = 5944, chance = 17700 }, -- Soul Orb
	{ id = 239, chance = 17400, maxCount = 2 }, -- Great Health Potion
	{ id = 6558, chance = 16900 }, -- Flask of Demonic Blood
	{ id = 6499, chance = 13400 }, -- Demonic Essence
	{ id = 678, chance = 13100, maxCount = 3 }, -- Small Enchanted Amethyst
	{ id = 3028, chance = 12200, maxCount = 3 }, -- Small Diamond
	{ id = 3017, chance = 10400 }, -- Silver Brooch
	{ id = 3029, chance = 10200, maxCount = 3 }, -- Small Sapphire
	{ id = 3027, chance = 9600, maxCount = 2 }, -- Black Pearl
	{ id = 7368, chance = 9000, maxCount = 5 }, -- Assassin Star
	{ id = 3026, chance = 7200, maxCount = 2 }, -- White Pearl
	{ id = 3032, chance = 7100, maxCount = 2 }, -- Small Emerald
	{ id = 9057, chance = 6900, maxCount = 2 }, -- Small Topaz
	{ id = 3030, chance = 6800, maxCount = 2 }, -- Small Ruby
	{ id = 3043, chance = 4000 }, -- Crystal Coin
	{ id = 3069, chance = 3200 }, -- Necrotic Rod
	{ id = 3403, chance = 3100 }, -- Tribal Mask
	{ id = 25759, chance = 3100, maxCount = 3 }, -- Royal Star
	{ id = 21981, chance = 1700 }, -- Oriental Shoes
	{ id = 7404, chance = 1600 }, -- Assassin Dagger
	{ id = 9058, chance = 1500 }, -- Gold Ingot
	{ id = 3054, chance = 1300 }, -- Silver Amulet
	{ id = 3036, chance = 1300 }, -- Violet Gem
	{ id = 3041, chance = 1200 }, -- Blue Gem
	{ id = 8061, chance = 1100 }, -- Skullcracker Armor
	{ id = 3007, chance = 920 }, -- Crystal Ring
	{ id = 3567, chance = 790 }, -- Blue Robe
	{ id = 8074, chance = 660 }, -- Spellbook of Mind Control
	{ id = 8082, chance = 660 }, -- Underworld Rod
	{ id = 3037, chance = 660 }, -- Yellow Gem
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
