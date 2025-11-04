local mType = Game.createMonsterType("Hellhound")
local monster = {}

monster.description = "a hellhound"
monster.experience = 5440
monster.outfit = {
	lookType = 240,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 294
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Pits of Inferno (Infernatil's Throneroom), The Inquisition Quest Area, Hellgorge, \z
	Roshamuul Prison, Chyllfroest, Oramond Dungeon, The Extension Site and Asura Vaults.",
}

monster.health = 7500
monster.maxHealth = 7500
monster.race = "blood"
monster.corpse = 6331
monster.speed = 180
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 3,
	color = 206,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "GROOOOWL!", yell = true },
}

monster.loot = {
	{ id = 3035, chance = 98920, maxCount = 7 }, -- Platinum Coin
	{ id = 238, chance = 19872, maxCount = 3 }, -- Great Mana Potion
	{ id = 3582, chance = 30518, maxCount = 14 }, -- Ham
	{ id = 7368, chance = 30689, maxCount = 10 }, -- Assassin Star
	{ id = 7642, chance = 20808 }, -- Great Spirit Potion
	{ id = 9637, chance = 17540 }, -- Hellhound Slobber
	{ id = 5944, chance = 30299 }, -- Soul Orb
	{ id = 6499, chance = 19045 }, -- Demonic Essence
	{ id = 6558, chance = 25579, maxCount = 2 }, -- Flask of Demonic Blood
	{ id = 7643, chance = 15116 }, -- Ultimate Health Potion
	{ id = 3030, chance = 9675, maxCount = 3 }, -- Small Ruby
	{ id = 16131, chance = 13134 }, -- Blazing Bone
	{ id = 9636, chance = 9990 }, -- Fiery Heart
	{ id = 3071, chance = 7824 }, -- Wand of Inferno
	{ id = 3027, chance = 10181, maxCount = 4 }, -- Black Pearl
	{ id = 3032, chance = 10721, maxCount = 3 }, -- Small Emerald
	{ id = 9057, chance = 11371, maxCount = 3 }, -- Small Topaz
	{ id = 5925, chance = 9875 }, -- Hardened Bone
	{ id = 5914, chance = 6226 }, -- Yellow Piece of Cloth
	{ id = 3318, chance = 8531 }, -- Knight Axe
	{ id = 3280, chance = 6068 }, -- Fire Sword
	{ id = 5910, chance = 5009 }, -- Green Piece of Cloth
	{ id = 3039, chance = 4966 }, -- Red Gem
	{ id = 3037, chance = 4630 }, -- Yellow Gem
	{ id = 818, chance = 1207 }, -- Magma Boots
	{ id = 5911, chance = 3478 }, -- Red Piece of Cloth
	{ id = 7426, chance = 2071 }, -- Amber Staff
	{ id = 9058, chance = 1752 }, -- Gold Ingot
	{ id = 817, chance = 3166 }, -- Magma Amulet
	{ id = 821, chance = 1071 }, -- Magma Legs
	{ id = 6553, chance = 869 }, -- Ruthless Axe
	{ id = 3038, chance = 882 }, -- Green Gem
	{ id = 3281, chance = 802 }, -- Giant Sword
	{ id = 826, chance = 655 }, -- Magma Coat
	{ id = 827, chance = 922 }, -- Magma Monocle
	{ id = 7421, chance = 781 }, -- Onyx Flail
	{ id = 3116, chance = 981 }, -- Big Bone
	{ id = 4871, chance = 391 }, -- Explorer Brooch
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -520, condition = { type = CONDITION_POISON, totalDamage = 800, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -700, length = 8, spread = 3, effect = CONST_ME_CARNIPHILA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -395, maxDamage = -498, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -660, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -350, maxDamage = -976, length = 8, spread = 3, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -403, radius = 1, effect = CONST_ME_HITBYFIRE, target = true },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -549, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 60,
	mitigation = 2.75,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 220, maxDamage = 425, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
