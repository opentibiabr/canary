local mType = Game.createMonsterType("Fury")
local monster = {}

monster.description = "a fury"
monster.experience = 3600
monster.outfit = {
	lookType = 149,
	lookHead = 94,
	lookBody = 77,
	lookLegs = 78,
	lookFeet = 79,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 291
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Pits of Inferno (Apocalypse's Throne Room), The Inquisition Quest (The Shadow Nexus, Battlefield), \z
	Vengoth, Fury Dungeon, Oramond Fury Dungeon, The Extension Site, Grounds of Destruction and Halls of Ascension.",
}

monster.health = 4100
monster.maxHealth = 4100
monster.race = "blood"
monster.corpse = 18118
monster.speed = 200
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Ahhhhrrrr!", yell = false },
	{ text = "Waaaaah!", yell = false },
	{ text = "Caaarnaaage!", yell = false },
	{ text = "Dieee!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 98804, maxCount = 269 }, -- Gold Coin
	{ id = 6558, chance = 55361, maxCount = 3 }, -- Flask of Demonic Blood
	{ id = 8016, chance = 29938, maxCount = 4 }, -- Jalapeno Pepper
	{ id = 6499, chance = 22499 }, -- Demonic Essence
	{ id = 5944, chance = 20285 }, -- Soul Orb
	{ id = 3065, chance = 19818 }, -- Terra Rod
	{ id = 239, chance = 10058 }, -- Great Health Potion
	{ id = 8899, chance = 10516 }, -- Slightly Rusted Legs
	{ id = 3033, chance = 14369, maxCount = 3 }, -- Small Amethyst
	{ id = 5911, chance = 3798 }, -- Red Piece of Cloth
	{ id = 3035, chance = 4569, maxCount = 4 }, -- Platinum Coin
	{ id = 7456, chance = 1991 }, -- Noble Axe
	{ id = 5021, chance = 2499, maxCount = 4 }, -- Orichalcum Pearl
	{ id = 3554, chance = 812 }, -- Steel Boots
	{ id = 7404, chance = 643 }, -- Assassin Dagger
	{ id = 3007, chance = 352 }, -- Crystal Ring
	{ id = 6299, chance = 145 }, -- Death Ring
	{ id = 3364, chance = 198 }, -- Golden Legs
	{ id = 7368, chance = 109 }, -- Assassin Star
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -510 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -300, length = 8, spread = 3, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_DEATHDAMAGE, minDamage = -120, maxDamage = -700, length = 8, spread = 3, effect = CONST_ME_DRAWBLOOD, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -120, maxDamage = -300, radius = 4, effect = CONST_ME_DRAWBLOOD, target = false },
	{ name = "fury skill reducer", interval = 2000, chance = 5, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -120, maxDamage = -300, radius = 3, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -125, maxDamage = -250, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -800, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = false, duration = 30000 },
}

monster.defenses = {
	defense = 20,
	armor = 35,
	mitigation = 1.32,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 800, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
