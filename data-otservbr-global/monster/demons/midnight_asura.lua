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
	{ id = 3035, chance = 80000, maxCount = 6 }, -- Platinum Coin
	{ id = 3031, chance = 71000, maxCount = 100 }, -- Gold Coin
	{ id = 6558, chance = 14000 }, -- Flask of Demonic Blood
	{ id = 5944, chance = 13900 }, -- Soul Orb
	{ id = 21974, chance = 12600 }, -- Golden Lotus Brooch
	{ id = 21975, chance = 10900 }, -- Peacock Feather Fan
	{ id = 6499, chance = 10200 }, -- Demonic Essence
	{ id = 239, chance = 8000, maxCount = 2 }, -- Great Health Potion
	{ id = 7368, chance = 6800, maxCount = 5 }, -- Assassin Star
	{ id = 3028, chance = 5500, maxCount = 3 }, -- Small Diamond
	{ id = 3026, chance = 5400, maxCount = 2 }, -- White Pearl
	{ id = 3029, chance = 5300, maxCount = 3 }, -- Small Sapphire
	{ id = 3027, chance = 3600, maxCount = 2 }, -- Black Pearl
	{ id = 3017, chance = 3600 }, -- Silver Brooch
	{ id = 3032, chance = 3400, maxCount = 2 }, -- Small Emerald
	{ id = 3030, chance = 3000, maxCount = 2 }, -- Small Ruby
	{ id = 9057, chance = 2900, maxCount = 2 }, -- Small Topaz
	{ id = 3069, chance = 2400 }, -- Necrotic Rod
	{ id = 3403, chance = 2200 }, -- Tribal Mask
	{ id = 3054, chance = 980 }, -- Silver Amulet
	{ id = 3037, chance = 920 }, -- Yellow Gem
	{ id = 8082, chance = 810 }, -- Underworld Rod
	{ id = 3567, chance = 530 }, -- Blue Robe
	{ id = 3007, chance = 390 }, -- Crystal Ring
	{ id = 21981, chance = 370 }, -- Oriental Shoes
	{ id = 7404, chance = 360 }, -- Assassin Dagger
	{ id = 3041, chance = 210 }, -- Blue Gem
	{ id = 9058, chance = 190 }, -- Gold Ingot
	{ id = 8061, chance = 160 }, -- Skullcracker Armor
	{ id = 8074, chance = 160 }, -- Spellbook of Mind Control
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
