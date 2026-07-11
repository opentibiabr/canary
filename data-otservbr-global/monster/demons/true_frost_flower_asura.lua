local mType = Game.createMonsterType("True Frost Flower Asura")
local monster = {}

monster.description = "a true frost flower asura"
monster.experience = 7069
monster.outfit = {
	lookType = 1068,
	lookHead = 9,
	lookBody = 0,
	lookLegs = 86,
	lookFeet = 9,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1622
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Asura Palace, Asura Vaults",
}

monster.health = 4000
monster.maxHealth = 4000
monster.race = "blood"
monster.corpse = 28667
monster.speed = 150
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
	targetDistance = 3,
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
	{ id = 3035, chance = 89000, maxCount = 3 }, -- Platinum Coin
	{ id = 21974, chance = 20000 }, -- Golden Lotus Brooch
	{ id = 239, chance = 19800, maxCount = 2 }, -- Great Health Potion
	{ id = 5944, chance = 18500 }, -- Soul Orb
	{ id = 6499, chance = 17000, maxCount = 2 }, -- Demonic Essence
	{ id = 6558, chance = 17000 }, -- Flask of Demonic Blood
	{ id = 21975, chance = 16700 }, -- Peacock Feather Fan
	{ id = 3032, chance = 16100, maxCount = 5 }, -- Small Emerald
	{ id = 3029, chance = 11000, maxCount = 3 }, -- Small Sapphire
	{ id = 3027, chance = 10600, maxCount = 2 }, -- Black Pearl
	{ id = 3017, chance = 9300 }, -- Silver Brooch
	{ id = 9057, chance = 8100, maxCount = 2 }, -- Small Topaz
	{ id = 7368, chance = 7900, maxCount = 5 }, -- Assassin Star
	{ id = 3028, chance = 7900, maxCount = 3 }, -- Small Diamond
	{ id = 3043, chance = 5900 }, -- Crystal Coin
	{ id = 3030, chance = 5500, maxCount = 2 }, -- Small Ruby
	{ id = 675, chance = 5500, maxCount = 3 }, -- Small Enchanted Sapphire
	{ id = 3026, chance = 5100, maxCount = 2 }, -- White Pearl
	{ id = 3037, chance = 3100 }, -- Yellow Gem
	{ id = 25759, chance = 2600, maxCount = 3 }, -- Royal Star
	{ id = 3403, chance = 2400 }, -- Tribal Mask
	{ id = 3567, chance = 2200 }, -- Blue Robe
	{ id = 8083, chance = 2000 }, -- Northwind Rod
	{ id = 3007, chance = 2000 }, -- Crystal Ring
	{ id = 9058, chance = 1800 }, -- Gold Ingot
	{ id = 3054, chance = 1800 }, -- Silver Amulet
	{ id = 3067, chance = 1300 }, -- Hailstorm Rod
	{ id = 3041, chance = 1300 }, -- Blue Gem
	{ id = 7404, chance = 880 }, -- Assassin Dagger
	{ id = 8074, chance = 880 }, -- Spellbook of Mind Control
	{ id = 21981, chance = 660 }, -- Oriental Shoes
	{ id = 8061, chance = 440 }, -- Skullcracker Armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -75, maxDamage = -550, condition = { type = CONDITION_FREEZING, totalDamage = 400, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -75, maxDamage = -300, range = 7, target = false },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = -600, maxDamage = -820, length = 8, spread = 0, effect = CONST_ME_ICETORNADO, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -130, maxDamage = -330, length = 8, spread = 0, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -100, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000 },
}

monster.defenses = {
	defense = 55,
	armor = 72,
	mitigation = 2.11,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
