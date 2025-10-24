local mType = Game.createMonsterType("Betrayed Wraith")
local monster = {}

monster.description = "a betrayed wraith"
monster.experience = 3500
monster.outfit = {
	lookType = 233,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 284
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Pits of Inferno, Helheim, The Inquisition Quest, Roshamuul Prison, Oramond Fury Dungeon",
}

monster.health = 4200
monster.maxHealth = 4200
monster.race = "undead"
monster.corpse = 6315
monster.speed = 173
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 300,
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
	{ text = "Rrrah!", yell = false },
	{ text = "Gnarr!", yell = false },
	{ text = "Tcharrr!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 99896, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 57222, maxCount = 8 }, -- Platinum Coin
	{ id = 3450, chance = 48622, maxCount = 15 }, -- Power Bolt
	{ id = 6558, chance = 52903 }, -- Flask of Demonic Blood
	{ id = 7368, chance = 9157, maxCount = 5 }, -- Assassin Star
	{ id = 6499, chance = 13258 }, -- Demonic Essence
	{ id = 238, chance = 8918, maxCount = 3 }, -- Great Mana Potion
	{ id = 5021, chance = 7075, maxCount = 2 }, -- Orichalcum Pearl
	{ id = 3028, chance = 10456, maxCount = 4 }, -- Small Diamond
	{ id = 5944, chance = 8599 }, -- Soul Orb
	{ id = 7643, chance = 15274 }, -- Ultimate Health Potion
	{ id = 10316, chance = 19141 }, -- Unholy Bone
	{ id = 7386, chance = 1171 }, -- Mercenary Sword
	{ id = 7416, chance = 252 }, -- Bloody Edge
	{ id = 6299, chance = 345 }, -- Death Ring
	{ id = 5799, chance = 491 }, -- Golden Figurine
	{ id = 5741, chance = 646 }, -- Skull Helmet
	{ id = 3081, chance = 1000 }, -- Stone Skin Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "betrayed wraith skill reducer", interval = 2000, chance = 10, target = false },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -600, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = true, duration = 3000 },
}

monster.defenses = {
	defense = 55,
	armor = 42,
	mitigation = 1.46,
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 350, maxDamage = 600, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 2000, chance = 10 },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 460, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
