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
	lookMount = 0
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
	Locations = "Infernatil's Throneroom The Inquisition Quest Area, Hellgorge, \z
		Roshamuul Prison, Chyllfroest, Oramond Dungeon, The Extension Site and under the Asura Palace."
	}

monster.health = 7500
monster.maxHealth = 7500
monster.race = "blood"
monster.corpse = 6331
monster.speed = 180
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "GROOOOWL!", yell = false}
}

monster.loot = {
	{id = 7426, chance = 2000}, -- amber staff
	{id = 7368, chance = 25000, maxCount = 10}, -- assassin star
	{id = 3116, chance = 900}, -- big bone
	{id = 3027, chance = 9200, maxCount = 4}, -- black pearl
	{id = 16131, chance = 12500}, -- blazing bone
	{id = 6558, chance = 20000, maxCount = 2}, -- flask of demonic blood
	{id = 6499, chance = 20000}, -- demonic essence
	{id = 4871, chance = 400}, -- explorer brooch
	{id = 9636, chance = 10000}, -- fiery heart
	{id = 3280, chance = 7000}, -- fire sword
	{id = 3281, chance = 1000}, -- giant sword
	{id = 9058, chance = 1500}, -- gold ingot
	{id = 238, chance = 30000, maxCount = 3}, -- great mana potion
	{id = 7642, chance = 20000}, -- great spirit potion
	{id = 3038, chance = 1000}, -- green gem
	{id = 3582, chance = 30000, maxCount = 14}, -- ham
	{id = 5925, chance = 10000}, -- hardened bone
	{id = 9637, chance = 20000}, -- hellhound slobber
	{id = 3318, chance = 7500}, -- knight axe
	{id = 817, chance = 3000}, -- magma amulet
	{id = 818, chance = 1500}, -- magma boots
	{id = 826, chance = 800}, -- magma coat
	{id = 821, chance = 1000}, -- magma legs
	{id = 827, chance = 900}, -- magma monocle
	{id = 7421, chance = 1000}, -- onyx flail
	{id = 3035, chance = 100000, maxCount = 7}, -- platinum coin
	{id = 3039, chance = 4500}, -- red gem
	{id = 6553, chance = 1000}, -- ruthless axe
	{id = 3032, chance = 10000, maxCount = 3}, -- small emerald
	{id = 3030, chance = 10000, maxCount = 3}, -- small ruby
	{id = 9057, chance = 10000, maxCount = 3}, -- small topaz
	{id = 5944, chance = 20000}, -- soul orb
	{id = 7643, chance = 16000}, -- ultimate health potion
	{id = 3071, chance = 7000}, -- wand of inferno
	{id = 3037, chance = 4500}, -- yellow gem
	{id = 5911, chance = 3000}, -- red piece of cloth
	{id = 5910, chance = 5000}, -- green piece of cloth
	{id = 5914, chance = 6000} -- yellow piece of cloth
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -520, condition = {type = CONDITION_POISON, totalDamage = 800, interval = 4000}},
	{name ="combat", interval = 2000, chance = 5, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -700, length = 8, spread = 3, effect = CONST_ME_CARNIPHILA, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -395, maxDamage = -498, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -660, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -350, maxDamage = -976, length = 8, spread = 3, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -403, radius = 1, effect = CONST_ME_HITBYFIRE, target = true},
	{name ="combat", interval = 2000, chance = 5, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -549, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 60,
	{name ="speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 220, maxDamage = 425, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 20},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -5},
	{type = COMBAT_HOLYDAMAGE , percent = -5},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = true},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
