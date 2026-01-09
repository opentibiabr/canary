local mType = Game.createMonsterType("Sight of Surrender")
local monster = {}

monster.description = "a sight of surrender"
monster.experience = 17000
monster.outfit = {
	lookType = 583,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1012
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Dark Grounds, Guzzlemaw Valley (if less than 100 Blowing Horns tasks \z
		have been done the day before) and the Silencer Plateau (when Silencer Resonating Chambers are used there).",
}

monster.health = 28000
monster.maxHealth = 28000
monster.race = "undead"
monster.corpse = 20144
monster.speed = 170
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20,
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
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "BOW LOW!", yell = true },
	{ text = "FEEL THE TRUE MEANING OF VANQUISH!", yell = true },
	{ text = "HAHAHAHA DO YOU WANT TO AMUSE YOUR MASTER?", yell = true },
	{ text = "NOW YOU WILL SURRENDER!", yell = true },
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 20 }, -- Platinum Coin
	{ id = 20184, chance = 100000 }, -- Broken Visor
	{ id = 20183, chance = 100000 }, -- Sight of Surrender's Eye
	{ id = 238, chance = 76510, maxCount = 5 }, -- Great Mana Potion
	{ id = 7643, chance = 76920, maxCount = 5 }, -- Ultimate Health Potion
	{ id = 7642, chance = 75560, maxCount = 5 }, -- Great Spirit Potion
	{ id = 16124, chance = 34330, maxCount = 5 }, -- Blue Crystal Splinter
	{ id = 16122, chance = 32950, maxCount = 5 }, -- Green Crystal Splinter
	{ id = 16123, chance = 32729, maxCount = 5 }, -- Brown Crystal Splinter
	{ id = 16120, chance = 24740, maxCount = 3 }, -- Violet Crystal Shard
	{ id = 16119, chance = 25030, maxCount = 3 }, -- Blue Crystal Shard
	{ id = 16121, chance = 23930, maxCount = 3 }, -- Green Crystal Shard
	{ id = 3081, chance = 14390 }, -- Stone Skin Amulet
	{ id = 3048, chance = 5110 }, -- Might Ring
	{ id = 3333, chance = 5000 }, -- Crystal Mace
	{ id = 20062, chance = 2960 }, -- Cluster of Solace
	{ id = 3366, chance = 1860 }, -- Magic Plate Armor
	{ id = 3554, chance = 2350 }, -- Steel Boots
	{ id = 7422, chance = 1230 }, -- Jade Hammer
	{ id = 3428, chance = 1230 }, -- Tower Shield
	{ id = 3332, chance = 860 }, -- Hammer of Wrath
	{ id = 7421, chance = 1270 }, -- Onyx Flail
	{ id = 3391, chance = 770 }, -- Crusader Helmet
	{ id = 3382, chance = 480 }, -- Crown Legs
	{ id = 20208, chance = 440 }, -- String of Mending
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1100 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -800, length = 8, spread = 0, effect = CONST_ME_YELLOWENERGY, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -500, radius = 1, shootEffect = CONST_ANI_LARGEROCK, target = true },
}

monster.defenses = {
	defense = 70,
	armor = 92,
	mitigation = 2.31,
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 550, maxDamage = 1100, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 520, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 35 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 40 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
