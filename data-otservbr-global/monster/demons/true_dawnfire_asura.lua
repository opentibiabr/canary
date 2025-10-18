local mType = Game.createMonsterType("True Dawnfire Asura")
local monster = {}

monster.description = "a true dawnfire asura"
monster.experience = 7475
monster.outfit = {
	lookType = 1068,
	lookHead = 114,
	lookBody = 94,
	lookLegs = 79,
	lookFeet = 121,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 1620
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

monster.health = 8500
monster.maxHealth = 8500
monster.race = "blood"
monster.corpse = 28664
monster.speed = 180
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
	{ id = 3035, chance = 99651, maxCount = 12 }, -- Platinum Coin
	{ id = 6558, chance = 29318, maxCount = 3 }, -- Flask of Demonic Blood
	{ id = 238, chance = 15726, maxCount = 2 }, -- Great Mana Potion
	{ id = 676, chance = 9481, maxCount = 3 }, -- Small Enchanted Ruby
	{ id = 3028, chance = 7585, maxCount = 2 }, -- Small Diamond
	{ id = 3030, chance = 11151, maxCount = 3 }, -- Small Ruby
	{ id = 3032, chance = 14105, maxCount = 5 }, -- Small Emerald
	{ id = 3033, chance = 6384, maxCount = 2 }, -- Small Amethyst
	{ id = 5944, chance = 16401 }, -- Soul Orb
	{ id = 6499, chance = 21596 }, -- Demonic Essence
	{ id = 9057, chance = 8733, maxCount = 2 }, -- Small Topaz
	{ id = 21974, chance = 21079 }, -- Golden Lotus Brooch
	{ id = 21975, chance = 20678 }, -- Peacock Feather Fan
	{ id = 826, chance = 1509 }, -- Magma Coat
	{ id = 3016, chance = 3810 }, -- Ruby Necklace
	{ id = 3039, chance = 3528 }, -- Red Gem
	{ id = 3041, chance = 2427 }, -- Blue Gem
	{ id = 3043, chance = 4157 }, -- Crystal Coin
	{ id = 3071, chance = 1580 }, -- Wand of Inferno
	{ id = 3078, chance = 3081 }, -- Mysterious Fetish
	{ id = 3574, chance = 2320 }, -- Mystic Turban
	{ id = 5911, chance = 2518 }, -- Red Piece of Cloth
	{ id = 8043, chance = 1910 }, -- Focus Cape
	{ id = 8074, chance = 794 }, -- Spellbook of Mind Control
	{ id = 21981, chance = 2595 }, -- Oriental Shoes
	{ id = 25759, chance = 3140, maxCount = 3 }, -- Royal Star
	{ id = 6299, chance = 920 }, -- Death Ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -700, condition = { type = CONDITION_FIRE, totalDamage = 500, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -50, maxDamage = -300, range = 7, target = false }, -- mana drain beam
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -450, maxDamage = -830, length = 1, spread = 0, effect = CONST_ME_HITBYFIRE, target = false }, -- fire missile
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -550, maxDamage = -750, radius = 4, effect = CONST_ME_BLACKSMOKE, target = false }, -- death ball
	{ name = "speed", interval = 2000, chance = 15, speedChange = -200, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000 }, -- smoke berserk
}

monster.defenses = {
	defense = 55,
	armor = 77,
	mitigation = 2.16,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
