local mType = Game.createMonsterType("Midnight Asura")
local monster = {}

monster.description = "a midnight asura"
monster.experience = 4100
monster.outfit = {
	lookType = 150,
	lookHead = 0,
	lookBody = 114,
	lookLegs = 90,
	lookFeet = 90,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 1135
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Asura Palace.",
}

monster.health = 3100
monster.maxHealth = 3100
monster.race = "blood"
monster.corpse = 21988
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	{ text = "Death and Darkness!", yell = false },
	{ text = "Embrace the night!", yell = false },
	{ text = "May night fall upon you!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 78661, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 85456, maxCount = 6 }, -- Platinum Coin
	{ id = 6558, chance = 15666 }, -- Flask of Demonic Blood
	{ id = 5944, chance = 15372 }, -- Soul Orb
	{ id = 21974, chance = 14051 }, -- Golden Lotus Brooch
	{ id = 21975, chance = 12094 }, -- Peacock Feather Fan
	{ id = 6499, chance = 11368 }, -- Demonic Essence
	{ id = 239, chance = 9060, maxCount = 2 }, -- Great Health Potion
	{ id = 7368, chance = 7532, maxCount = 5 }, -- Assassin Star
	{ id = 3026, chance = 6349 }, -- White Pearl
	{ id = 3028, chance = 6114, maxCount = 3 }, -- Small Diamond
	{ id = 3029, chance = 5979, maxCount = 3 }, -- Small Sapphire
	{ id = 3017, chance = 3968 }, -- Silver Brooch
	{ id = 3027, chance = 3848, maxCount = 2 }, -- Black Pearl
	{ id = 9057, chance = 3368 }, -- Small Topaz
	{ id = 3030, chance = 3305 }, -- Small Ruby
	{ id = 3032, chance = 3638 }, -- Small Emerald
	{ id = 3069, chance = 2705 }, -- Necrotic Rod
	{ id = 3403, chance = 2361 }, -- Tribal Mask
	{ id = 3054, chance = 1186 }, -- Silver Amulet
	{ id = 3037, chance = 988 }, -- Yellow Gem
	{ id = 8082, chance = 909 }, -- Underworld Rod
	{ id = 3567, chance = 601 }, -- Blue Robe
	{ id = 21981, chance = 413 }, -- Oriental Shoes
	{ id = 7404, chance = 421 }, -- Assassin Dagger
	{ id = 3007, chance = 415 }, -- Crystal Ring
	{ id = 3041, chance = 248 }, -- Blue Gem
	{ id = 8061, chance = 178 }, -- Skullcracker Armor
	{ id = 9058, chance = 197 }, -- Gold Ingot
	{ id = 8074, chance = 155 }, -- Spellbook of Mind Control
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -387 },
	{ name = "combat", interval = 3300, chance = 10, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -70, range = 7, target = true },
	{ name = "combat", interval = 3700, chance = 17, type = COMBAT_ENERGYDAMAGE, minDamage = -150, maxDamage = -200, length = 5, spread = 0, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "combat", interval = 4100, chance = 27, type = COMBAT_DEATHDAMAGE, minDamage = -150, maxDamage = -300, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2700, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -50, maxDamage = -200, range = 5, shootEffect = CONST_ANI_SUDDENDEATH, target = true },
	{ name = "combat", interval = 3100, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -50, maxDamage = -100, range = 1, shootEffect = CONST_ANI_ENERGY, target = true },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -800, radius = 1, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_SLEEP, target = true, duration = 15000 },
}

monster.defenses = {
	defense = 55,
	armor = 55,
	mitigation = 1.60,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
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
