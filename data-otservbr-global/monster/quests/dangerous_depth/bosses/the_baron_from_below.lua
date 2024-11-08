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
	{ name = "platinum coin", chance = 100000, maxCount = 58 },
	{ name = "mastermind potion", chance = 100000 },
	{ name = "stone skin amulet", chance = 100000 },
	{ id = 27713, chance = 100000 }, -- heavy crystal fragment
	{ name = "wand of inferno", chance = 72920 },
	{ name = "violet crystal shard", chance = 64580 },
	{ name = "ultimate health potion", chance = 62500, maxCount = 18 },
	{ name = "fire sword", chance = 56250 },
	{ name = "great spirit potion", chance = 54170, maxCount = 18 },
	{ name = "magic sulphur", chance = 45830 },
	{ name = "great mana potion", chance = 43750, maxCount = 18 },
	{ name = "crystal mace", chance = 37500 },
	{ name = "silver token", chance = 33330 },
	{ name = "small emerald", chance = 20830 },
	{ name = "huge chunk of crude iron", chance = 20830 },
	{ name = "slightly rusted shield", chance = 18750 },
	{ name = "slightly rusted helmet", chance = 16670 },
	{ id = 3039, chance = 14580 }, -- red gem
	{ name = "luminous orb", chance = 14580 },
	{ name = "longing eyes", chance = 14580 },
	{ name = "small diamond", chance = 12500 },
	{ name = "small topaz", chance = 12500 },
	{ name = "small ruby", chance = 12500 },
	{ name = "violet gem", chance = 12500 },
	{ id = 27622, chance = 12500 }, -- chitinous mouth (baron)
	{ name = "calopteryx cape", chance = 10420 },
	{ name = "blue gem", chance = 10420 },
	{ name = "yellow gem", chance = 10420 },
	{ name = "gold ingot", chance = 8330 },
	{ name = "gold token", chance = 8330 },
	{ name = "crystal coin", chance = 8330 },
	{ name = "green gem", chance = 8330 },
	{ name = "small amethyst", chance = 6250 },
	{ name = "huge shell", chance = 4170 },
	{ name = "magma coat", chance = 4170 },
	{ name = "slimy leg", chance = 4170 },
	{ name = "badger boots", chance = 4170 },
	{ name = "spellbook of warding", chance = 2080 },
	{ name = "gnome sword", chance = 4170 },
	{ name = "gnome armor", chance = 3390 },
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
