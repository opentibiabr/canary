local mType = Game.createMonsterType("The Duke of the Depths")
local monster = {}

monster.description = "The Duke Of The Depths"
monster.experience = 300000
monster.outfit = {
	lookType = 1047,
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
monster.corpse = 27641
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 50,
}

monster.bosstiary = {
	bossRaceId = 1520,
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
	{ text = "SzzzSzzz!", yell = false },
	{ text = "Chhhhhh!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 36 }, -- platinum coin
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 16119, chance = 80000, maxCount = 4 }, -- blue crystal shard
	{ id = 27619, chance = 80000 }, -- giant tentacle
	{ id = 5892, chance = 80000 }, -- huge chunk of crude iron
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3028, chance = 80000, maxCount = 2 }, -- small diamond
	{ id = 3032, chance = 80000, maxCount = 12 }, -- small emerald
	{ id = 3033, chance = 80000, maxCount = 12 }, -- small amethyst
	{ id = 3030, chance = 80000, maxCount = 12 }, -- small ruby
	{ id = 9057, chance = 80000, maxCount = 12 }, -- small topaz
	{ id = 3071, chance = 80000 }, -- wand of inferno
	{ id = 3081, chance = 80000 }, -- stone skin amulet
	{ id = 7440, chance = 80000, maxCount = 2 }, -- mastermind potion
	{ id = 11454, chance = 80000 }, -- luminous orb
	{ id = 811, chance = 80000 }, -- terra mantle
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 3320, chance = 80000 }, -- fire axe
	{ id = 3280, chance = 80000 }, -- fire sword
	{ id = 239, chance = 80000, maxCount = 8 }, -- great health potion
	{ id = 7643, chance = 80000, maxCount = 8 }, -- ultimate health potion
	{ id = 238, chance = 80000, maxCount = 18 }, -- great mana potion
	{ id = 7642, chance = 80000, maxCount = 10 }, -- great spirit potion
	{ id = 27620, chance = 80000 }, -- damaged worm head
	{ id = 27618, chance = 80000 }, -- pristine worm head
	{ id = 16117, chance = 80000 }, -- muck rod
	{ id = 8908, chance = 80000 }, -- slightly rusted helmet
	{ id = 8050, chance = 80000 }, -- crystalline armor
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 8902, chance = 80000 }, -- slightly rusted shield
	{ id = 27713, chance = 80000 }, -- heavy crystal fragment
	{ id = 22516, chance = 80000 }, -- silver token
	{ id = 22721, chance = 80000 }, -- gold token
	{ id = 27651, chance = 80000 }, -- gnome sword
	{ id = 27650, chance = 80000 }, -- gnome shield
	{ id = 27605, chance = 80000 }, -- candle stump
	{ id = 27657, chance = 80000 }, -- crude wood planks
	{ id = 27649, chance = 80000 }, -- gnome legs
	{ id = 27526, chance = 80000 }, -- mallet pommel
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 826, chance = 80000 }, -- magma coat
	{ id = 10438, chance = 80000 }, -- spellweavers robe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -800 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -1000, range = 3, length = 6, spread = 8, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -1000, range = 3, length = 9, spread = 4, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -135, maxDamage = -1000, radius = 2, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1000, radius = 8, effect = CONST_ME_HITAREA, target = false },
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
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
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

monster.heals = {
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
}

mType:register(monster)
