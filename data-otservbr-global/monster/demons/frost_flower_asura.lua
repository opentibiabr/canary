local mType = Game.createMonsterType("Frost Flower Asura")
local monster = {}

monster.description = "a frost flower asura"
monster.experience = 4200
monster.outfit = {
	lookType = 150,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 86,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 1619
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

monster.health = 3500
monster.maxHealth = 3500
monster.race = "blood"
monster.corpse = 28807
monster.speed = 110
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
	canWalkOnFire = false,
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
	{ id = 3031, chance = 100000, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 6 }, -- Platinum Coin
	{ id = 6558, chance = 19900 }, -- Flask of Demonic Blood
	{ id = 21974, chance = 19200 }, -- Golden Lotus Brooch
	{ id = 5944, chance = 18700 }, -- Soul Orb
	{ id = 21975, chance = 16600 }, -- Peacock Feather Fan
	{ id = 6499, chance = 15500 }, -- Demonic Essence
	{ id = 239, chance = 12100, maxCount = 2 }, -- Great Health Potion
	{ id = 7368, chance = 9800, maxCount = 5 }, -- Assassin Star
	{ id = 3026, chance = 8300, maxCount = 2 }, -- White Pearl
	{ id = 3028, chance = 7900, maxCount = 3 }, -- Small Diamond
	{ id = 3029, chance = 7500, maxCount = 3 }, -- Small Sapphire
	{ id = 3017, chance = 5600 }, -- Silver Brooch
	{ id = 3027, chance = 5200, maxCount = 2 }, -- Black Pearl
	{ id = 9057, chance = 4900, maxCount = 2 }, -- Small Topaz
	{ id = 3030, chance = 4600, maxCount = 2 }, -- Small Ruby
	{ id = 3032, chance = 4100, maxCount = 2 }, -- Small Emerald
	{ id = 8083, chance = 3200 }, -- Northwind Rod
	{ id = 3403, chance = 3000 }, -- Tribal Mask
	{ id = 3037, chance = 1800 }, -- Yellow Gem
	{ id = 3054, chance = 1200 }, -- Silver Amulet
	{ id = 3067, chance = 1100 }, -- Hailstorm Rod
	{ id = 3567, chance = 770 }, -- Blue Robe
	{ id = 7404, chance = 420 }, -- Assassin Dagger
	{ id = 9058, chance = 420 }, -- Gold Ingot
	{ id = 8074, chance = 320 }, -- Spellbook of Mind Control
	{ id = 21981, chance = 320 }, -- Oriental Shoes
	{ id = 3041, chance = 320 }, -- Blue Gem
	{ id = 3007, chance = 300 }, -- Crystal Ring
	{ id = 8061, chance = 220 }, -- Skullcracker Armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -130, maxDamage = -440 },
	{ name = "combat", interval = 1300, chance = 14, type = COMBAT_HOLYDAMAGE, minDamage = -200, maxDamage = -230, length = 8, spread = 0, effect = CONST_ME_ICETORNADO, target = false },
	{ name = "combat", interval = 1000, chance = 9, type = COMBAT_ICEDAMAGE, minDamage = -250, maxDamage = -250, range = 7, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEATTACK, target = true },
}

monster.defenses = {
	defense = 30,
	armor = 56,
	mitigation = 1.62,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 90, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
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
