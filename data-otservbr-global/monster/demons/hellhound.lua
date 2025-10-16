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
	{ id = 3035, chance = 80000, maxCount = 7 }, -- platinum coin
	{ id = 238, chance = 80000, maxCount = 3 }, -- great mana potion
	{ id = 3582, chance = 80000, maxCount = 14 }, -- ham
	{ id = 7368, chance = 80000, maxCount = 10 }, -- assassin star
	{ id = 7642, chance = 23000 }, -- great spirit potion
	{ id = 9637, chance = 23000 }, -- hellhound slobber
	{ id = 5944, chance = 23000 }, -- soul orb
	{ id = 6499, chance = 23000 }, -- demonic essence
	{ id = 6558, chance = 23000, maxCount = 2 }, -- flask of demonic blood
	{ id = 7643, chance = 23000 }, -- ultimate health potion
	{ id = 3030, chance = 23000, maxCount = 3 }, -- small ruby
	{ id = 16131, chance = 23000 }, -- blazing bone
	{ id = 9636, chance = 23000 }, -- fiery heart
	{ id = 3071, chance = 23000 }, -- wand of inferno
	{ id = 3027, chance = 23000, maxCount = 4 }, -- black pearl
	{ id = 3032, chance = 23000, maxCount = 3 }, -- small emerald
	{ id = 9057, chance = 23000, maxCount = 3 }, -- small topaz
	{ id = 5925, chance = 23000 }, -- hardened bone
	{ id = 5914, chance = 23000 }, -- yellow piece of cloth
	{ id = 3318, chance = 23000 }, -- knight axe
	{ id = 3280, chance = 23000 }, -- fire sword
	{ id = 5910, chance = 5000 }, -- green piece of cloth
	{ id = 36706, chance = 5000 }, -- red gem
	{ id = 3037, chance = 5000 }, -- yellow gem
	{ id = 818, chance = 5000 }, -- magma boots
	{ id = 5911, chance = 5000 }, -- red piece of cloth
	{ id = 7426, chance = 5000 }, -- amber staff
	{ id = 9058, chance = 5000 }, -- gold ingot
	{ id = 817, chance = 5000 }, -- magma amulet
	{ id = 821, chance = 5000 }, -- magma legs
	{ id = 6553, chance = 1000 }, -- ruthless axe
	{ id = 3038, chance = 1000 }, -- green gem
	{ id = 3281, chance = 1000 }, -- giant sword
	{ id = 826, chance = 1000 }, -- magma coat
	{ id = 827, chance = 1000 }, -- magma monocle
	{ id = 7421, chance = 1000 }, -- onyx flail
	{ id = 3116, chance = 1000 }, -- big bone
	{ id = 4871, chance = 260 }, -- explorer brooch
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
