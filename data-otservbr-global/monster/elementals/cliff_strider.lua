local mType = Game.createMonsterType("Cliff Strider")
local monster = {}

monster.description = "a cliff strider"
monster.experience = 7100
monster.outfit = {
	lookType = 497,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 889
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Warzone 3.",
}

monster.health = 9400
monster.maxHealth = 9400
monster.race = "undead"
monster.corpse = 16075
monster.speed = 123
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
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Knorrrr", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 199 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 10 }, -- Platinum Coin
	{ id = 238, chance = 34000, maxCount = 4 }, -- Great Mana Potion
	{ id = 7643, chance = 24000, maxCount = 2 }, -- Ultimate Health Potion
	{ id = 5944, chance = 18700 }, -- Soul Orb
	{ id = 16134, chance = 17300 }, -- Cliff Strider Claw
	{ id = 16133, chance = 17100 }, -- Pulverized Ore
	{ id = 16135, chance = 15800, maxCount = 2 }, -- Vein of Ore
	{ id = 5880, chance = 13800 }, -- Iron Ore
	{ id = 10310, chance = 12700 }, -- Shiny Stone
	{ id = 16124, chance = 10400, maxCount = 2 }, -- Blue Crystal Splinter
	{ id = 3027, chance = 9500 }, -- Black Pearl
	{ id = 16125, chance = 9400 }, -- Cyan Crystal Fragment
	{ id = 16141, chance = 9400, maxCount = 8 }, -- Prismatic Bolt
	{ id = 3026, chance = 9000, maxCount = 3 }, -- White Pearl
	{ id = 16119, chance = 6700 }, -- Blue Crystal Shard
	{ id = 3039, chance = 4800 }, -- Red Gem
	{ id = 9028, chance = 3200 }, -- Crystal of Balance
	{ id = 16096, chance = 2300 }, -- Wand of Defiance
	{ id = 7437, chance = 1800 }, -- Sapphire Hammer
	{ id = 7452, chance = 1600 }, -- Spiked Squelcher
	{ id = 16118, chance = 1500 }, -- Glacial Rod
	{ id = 9067, chance = 1400 }, -- Crystal of Power
	{ id = 3281, chance = 1200 }, -- Giant Sword
	{ id = 5904, chance = 1100 }, -- Magic Sulphur
	{ id = 3048, chance = 1000 }, -- Might Ring
	{ id = 3371, chance = 920 }, -- Knight Legs
	{ id = 3041, chance = 620 }, -- Blue Gem
	{ id = 16163, chance = 620 }, -- Crystal Crossbow
	{ id = 16160, chance = 540 }, -- Crystalline Sword
	{ id = 3381, chance = 460 }, -- Crown Armor
	{ id = 3391, chance = 380 }, -- Crusader Helmet
	{ id = 3332, chance = 150 }, -- Hammer of Wrath
	{ id = 3554, chance = 80 }, -- Steel Boots
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -499 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -800, radius = 4, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_STONES, target = true },
	{ name = "cliff strider skill reducer", interval = 2000, chance = 10, target = false },
	{ name = "cliff strider electrify", interval = 2000, chance = 15, range = 1, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1000, length = 6, spread = 0, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -100, maxDamage = -300, radius = 4, effect = CONST_ME_YELLOWENERGY, target = false },
}

monster.defenses = {
	defense = 55,
	armor = 89,
	mitigation = 2.60,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 35 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
