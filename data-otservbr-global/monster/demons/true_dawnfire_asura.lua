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
	{ id = 3035, chance = 100000, maxCount = 6 }, -- Platinum Coin
	{ id = 6558, chance = 28000, maxCount = 2 }, -- Flask of Demonic Blood
	{ id = 21974, chance = 19700 }, -- Golden Lotus Brooch
	{ id = 6499, chance = 18600, maxCount = 2 }, -- Demonic Essence
	{ id = 21975, chance = 18500 }, -- Peacock Feather Fan
	{ id = 3032, chance = 17800, maxCount = 5 }, -- Small Emerald
	{ id = 5944, chance = 17600 }, -- Soul Orb
	{ id = 238, chance = 15400, maxCount = 2 }, -- Great Mana Potion
	{ id = 3030, chance = 11300, maxCount = 3 }, -- Small Ruby
	{ id = 9057, chance = 8000, maxCount = 2 }, -- Small Topaz
	{ id = 676, chance = 7900, maxCount = 3 }, -- Small Enchanted Ruby
	{ id = 3028, chance = 7300, maxCount = 2 }, -- Small Diamond
	{ id = 3033, chance = 6500, maxCount = 2 }, -- Small Amethyst
	{ id = 3043, chance = 4400 }, -- Crystal Coin
	{ id = 25759, chance = 3300, maxCount = 3 }, -- Royal Star
	{ id = 3016, chance = 3300 }, -- Ruby Necklace
	{ id = 21981, chance = 3100 }, -- Oriental Shoes
	{ id = 3039, chance = 3000 }, -- Red Gem
	{ id = 3041, chance = 2800 }, -- Blue Gem
	{ id = 3078, chance = 2800 }, -- Mysterious Fetish
	{ id = 3574, chance = 2500 }, -- Mystic Turban
	{ id = 8043, chance = 2200 }, -- Focus Cape
	{ id = 5911, chance = 2200 }, -- Red Piece of Cloth
	{ id = 826, chance = 1700 }, -- Magma Coat
	{ id = 3071, chance = 1600 }, -- Wand of Inferno
	{ id = 8074, chance = 760 }, -- Spellbook of Mind Control
	{ id = 6299, chance = 490 }, -- Death Ring
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
