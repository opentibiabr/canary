local mType = Game.createMonsterType("The Baron from Below")
local monster = {}

monster.description = "The Baron From Below"
monster.experience = 50000
monster.outfit = {
	lookType = 1045,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"DepthWarzoneBossDeath",
	"TheBaronFromBelowThink",
}

monster.health = 350000
monster.maxHealth = 350000
monster.race = "blood"
monster.corpse = 27633
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1518,
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
	{ text = "Krrrk!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 49 }, -- platinum coin
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 238, chance = 80000, maxCount = 10 }, -- great mana potion
	{ id = 7643, chance = 80000, maxCount = 10 }, -- ultimate health potion
	{ id = 7642, chance = 80000, maxCount = 8 }, -- great spirit potion
	{ id = 7440, chance = 80000, maxCount = 2 }, -- mastermind potion
	{ id = 3028, chance = 80000, maxCount = 12 }, -- small diamond
	{ id = 3032, chance = 80000, maxCount = 12 }, -- small emerald
	{ id = 16120, chance = 80000, maxCount = 4 }, -- violet crystal shard
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3081, chance = 80000 }, -- stone skin amulet
	{ id = 5892, chance = 80000 }, -- huge chunk of crude iron
	{ id = 3071, chance = 80000 }, -- wand of inferno
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 22086, chance = 80000 }, -- badger boots
	{ id = 3280, chance = 80000 }, -- fire sword
	{ id = 3333, chance = 80000 }, -- crystal mace
	{ id = 8902, chance = 80000 }, -- slightly rusted shield
	{ id = 27621, chance = 80000 }, -- huge shell
	{ id = 27624, chance = 80000 }, -- longing eyes
	{ id = 27623, chance = 80000 }, -- slimy leg
	{ id = 3033, chance = 80000 }, -- small amethyst
	{ id = 8908, chance = 80000 }, -- slightly rusted helmet
	{ id = 14086, chance = 80000 }, -- calopteryx cape
	{ id = 826, chance = 80000 }, -- magma coat
	{ id = 11454, chance = 80000 }, -- luminous orb
	{ id = 3030, chance = 80000 }, -- small ruby
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 27713, chance = 80000 }, -- heavy crystal fragment
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 9057, chance = 80000 }, -- small topaz
	{ id = 22516, chance = 80000 }, -- silver token
	{ id = 22721, chance = 80000 }, -- gold token
	{ id = 27651, chance = 80000 }, -- gnome sword
	{ id = 27650, chance = 80000 }, -- gnome shield
	{ id = 27648, chance = 80000 }, -- gnome armor
	{ id = 27655, chance = 80000 }, -- plan for a makeshift armour
	{ id = 27524, chance = 80000 }, -- mallet head
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 8073, chance = 80000 }, -- spellbook of warding
	{ id = 27605, chance = 80000 }, -- candle stump
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1000, radius = 8, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -1000, length = 8, spread = 5, effect = CONST_ME_YELLOW_RINGS, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -1000, length = 8, spread = 9, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -1000, radius = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -1000, radius = 5, effect = CONST_ME_SMALLPLANTS, target = false },
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
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
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
