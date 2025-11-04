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
	{ id = 3031, chance = 100000 }, -- Gold Coin
	{ id = 3035, chance = 100000 }, -- Platinum Coin
	{ id = 3029, chance = 7570 }, -- Small Sapphire
	{ id = 3030, chance = 4580 }, -- Small Ruby
	{ id = 3032, chance = 4120 }, -- Small Emerald
	{ id = 9057, chance = 4770 }, -- Small Topaz
	{ id = 3037, chance = 1750 }, -- Yellow Gem
	{ id = 3017, chance = 5550 }, -- Silver Brooch
	{ id = 3054, chance = 1190 }, -- Silver Amulet
	{ id = 7368, chance = 9700 }, -- Assassin Star
	{ id = 6558, chance = 19970 }, -- Flask of Demonic Blood
	{ id = 6499, chance = 15470 }, -- Demonic Essence
	{ id = 3007, chance = 320 }, -- Crystal Ring
	{ id = 21974, chance = 19210 }, -- Golden Lotus Brooch
	{ id = 239, chance = 12050 }, -- Great Health Potion
	{ id = 21975, chance = 16790 }, -- Peacock Feather Fan
	{ id = 5944, chance = 18810 }, -- Soul Orb
	{ id = 8083, chance = 3210 }, -- Northwind Rod
	{ id = 3067, chance = 1210 }, -- Hailstorm Rod
	{ id = 8061, chance = 219 }, -- Skullcracker Armor
	{ id = 3567, chance = 750 }, -- Blue Robe
	{ id = 21981, chance = 350 }, -- Oriental Shoes
	{ id = 7404, chance = 460 }, -- Assassin Dagger
	{ id = 9058, chance = 430 }, -- Gold Ingot
	{ id = 3041, chance = 320 }, -- Blue Gem
	{ id = 8074, chance = 350 }, -- Spellbook of Mind Control
	{ id = 3027, chance = 5200 }, -- Black Pearl
	{ id = 3028, chance = 8160 }, -- Small Diamond
	{ id = 3026, chance = 8250 }, -- White Pearl
	{ id = 3403, chance = 2960 }, -- Tribal Mask
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -110, maxDamage = -400 },
	{ name = "combat", interval = 1300, chance = 14, type = COMBAT_HOLYDAMAGE, minDamage = -185, maxDamage = -210, length = 8, spread = 0, effect = CONST_ME_ICETORNADO, target = false },
	{ name = "combat", interval = 1000, chance = 9, type = COMBAT_ICEDAMAGE, minDamage = -120, maxDamage = -200, range = 7, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEATTACK, target = true },
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
