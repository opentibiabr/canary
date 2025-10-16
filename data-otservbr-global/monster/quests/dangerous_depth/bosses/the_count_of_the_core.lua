local mType = Game.createMonsterType("The Count of the Core")
local monster = {}

monster.description = "The Count Of The Core"
monster.experience = 300000
monster.outfit = {
	lookType = 1046,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"DepthWarzoneBossDeath",
}

monster.health = 350000
monster.maxHealth = 350000
monster.race = "blood"
monster.corpse = 27637
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1519,
	bossRace = RARITY_BANE,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
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
	{ text = "Shluush!", yell = false },
	{ text = "Sluuurp!", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 3035, chance = 80000, maxCount = 53 }, -- platinum coin
	{ id = 22721, chance = 80000 }, -- gold token
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 7642, chance = 80000, maxCount = 18 }, -- great spirit potion
	{ id = 9057, chance = 80000, maxCount = 12 }, -- small topaz
	{ id = 7440, chance = 80000, maxCount = 2 }, -- mastermind potion
	{ id = 16121, chance = 80000, maxCount = 4 }, -- green crystal shard
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 3081, chance = 80000 }, -- stone skin amulet
	{ id = 7426, chance = 80000 }, -- amber staff
	{ id = 3071, chance = 80000 }, -- wand of inferno
	{ id = 3280, chance = 80000 }, -- fire sword
	{ id = 22516, chance = 80000 }, -- silver token
	{ id = 27625, chance = 80000 }, -- harpoon of a giant snail
	{ id = 27627, chance = 80000 }, -- huge spiky snail shell
	{ id = 8908, chance = 80000 }, -- slightly rusted helmet
	{ id = 8902, chance = 80000 }, -- slightly rusted shield
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 3033, chance = 80000 }, -- small amethyst
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 5892, chance = 80000 }, -- huge chunk of crude iron
	{ id = 11454, chance = 80000 }, -- luminous orb
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3030, chance = 80000 }, -- small ruby
	{ id = 27713, chance = 80000 }, -- heavy crystal fragment
	{ id = 3032, chance = 80000 }, -- small emerald
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 7643, chance = 80000 }, -- ultimate health potion
	{ id = 3028, chance = 80000 }, -- small diamond
	{ id = 27651, chance = 80000 }, -- gnome sword
	{ id = 27650, chance = 80000 }, -- gnome shield
	{ id = 27647, chance = 80000 }, -- gnome helmet
	{ id = 27605, chance = 80000 }, -- candle stump
	{ id = 27656, chance = 80000 }, -- tinged pot
	{ id = 27525, chance = 80000 }, -- mallet handle
	{ id = 14043, chance = 80000 }, -- guardian axe
	{ id = 3281, chance = 80000 }, -- giant sword
	{ id = 11657, chance = 80000 }, -- twiceslicer
	{ id = 826, chance = 80000 }, -- magma coat
	{ id = 8050, chance = 80000 }, -- crystalline armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
	{ name = "combat", interval = 6000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -1500, range = 3, length = 9, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 4000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -1500, range = 3, length = 9, spread = 4, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1500, radius = 8, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -1500, radius = 8, effect = CONST_ME_BLACKSMOKE, target = false },
}

monster.defenses = {
	defense = 160,
	armor = 160,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
