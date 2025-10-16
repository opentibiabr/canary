local mType = Game.createMonsterType("Essence of Malice")
local monster = {}

monster.description = "Essence of Malice"
monster.experience = 150000
monster.outfit = {
	lookType = 351,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"CultsOfTibiaBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1487,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 250000
monster.maxHealth = 250000
monster.race = "undead"
monster.corpse = 10445
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 5,
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
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 366,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 4,
	color = 119,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Your demised will please me!", yell = false },
	{ text = "You will suffer!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 30 }, -- platinum coin
	{ id = 3420, chance = 80000 }, -- demon shield
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3033, chance = 80000, maxCount = 10 }, -- small amethyst
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 822, chance = 80000 }, -- lightning legs
	{ id = 23510, chance = 80000 }, -- odd organ
	{ id = 23506, chance = 80000 }, -- plasma pearls
	{ id = 9304, chance = 80000 }, -- shockwave amulet
	{ id = 9653, chance = 80000 }, -- witch hat
	{ id = 7643, chance = 80000, maxCount = 10 }, -- ultimate health potion
	{ id = 23509, chance = 80000 }, -- mysterious remains
	{ id = 23535, chance = 80000, maxCount = 5 }, -- energy bar
	{ id = 11693, chance = 80000 }, -- blade of corruption
	{ id = 22721, chance = 80000 }, -- gold token
	{ id = 22516, chance = 80000 }, -- silver token
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 3071, chance = 80000 }, -- wand of inferno
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 7642, chance = 80000 }, -- great spirit potion
	{ id = 3320, chance = 80000 }, -- fire axe
	{ id = 3029, chance = 80000 }, -- small sapphire
	{ id = 16096, chance = 80000 }, -- wand of defiance
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 16115, chance = 80000 }, -- wand of everblazing
	{ id = 827, chance = 80000 }, -- magma monocle
	{ id = 3028, chance = 80000 }, -- small diamond
	{ id = 7456, chance = 80000 }, -- noble axe
	{ id = 9057, chance = 80000 }, -- small topaz
	{ id = 3032, chance = 80000 }, -- small emerald
	{ id = 3036, chance = 80000 }, -- violet gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -603 },
	{ name = "ghastly dragon curse", interval = 2000, chance = 5, range = 5, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -520, maxDamage = -780, range = 5, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -80, maxDamage = -230, range = 7, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -120, maxDamage = -250, length = 8, spread = 0, effect = CONST_ME_LOSEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -110, maxDamage = -180, radius = 4, effect = CONST_ME_MORTAREA, target = false },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -800, range = 7, effect = CONST_ME_SMALLCLOUDS, target = true, duration = 30000 },
}

monster.defenses = {
	defense = 35,
	armor = 35,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -50 },
	{ type = COMBAT_EARTHDAMAGE, percent = -50 },
	{ type = COMBAT_FIREDAMAGE, percent = -50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = -50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
