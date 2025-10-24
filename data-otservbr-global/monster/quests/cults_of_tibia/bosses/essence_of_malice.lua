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
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 30 }, -- Platinum Coin
	{ id = 3420, chance = 10714 }, -- Demon Shield
	{ id = 3037, chance = 19642 }, -- Yellow Gem
	{ id = 3033, chance = 17460, maxCount = 10 }, -- Small Amethyst
	{ id = 23529, chance = 7142 }, -- Ring of Blue Plasma
	{ id = 822, chance = 2439 }, -- Lightning Legs
	{ id = 23510, chance = 98412 }, -- Odd Organ
	{ id = 23506, chance = 98412 }, -- Plasma Pearls
	{ id = 9304, chance = 65079 }, -- Shockwave Amulet
	{ id = 9653, chance = 71428 }, -- Witch Hat
	{ id = 7643, chance = 41269, maxCount = 10 }, -- Ultimate Health Potion
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 23535, chance = 100000, maxCount = 5 }, -- Energy Bar
	{ id = 11693, chance = 14285 }, -- Blade of Corruption
	{ id = 22721, chance = 28571 }, -- Gold Token
	{ id = 22516, chance = 23214 }, -- Silver Token
	{ id = 23533, chance = 3571 }, -- Ring of Red Plasma
	{ id = 3071, chance = 73015 }, -- Wand of Inferno
	{ id = 238, chance = 68253 }, -- Great Mana Potion
	{ id = 23531, chance = 3571 }, -- Ring of Green Plasma
	{ id = 3038, chance = 22222 }, -- Green Gem
	{ id = 7642, chance = 49206 }, -- Great Spirit Potion
	{ id = 3320, chance = 12500 }, -- Fire Axe
	{ id = 3029, chance = 22222 }, -- Small Sapphire
	{ id = 16096, chance = 7936 }, -- Wand of Defiance
	{ id = 3039, chance = 25396 }, -- Red Gem
	{ id = 281, chance = 15873 }, -- Giant Shimmering Pearl
	{ id = 16115, chance = 15873 }, -- Wand of Everblazing
	{ id = 827, chance = 14285 }, -- Magma Monocle
	{ id = 3028, chance = 17460 }, -- Small Diamond
	{ id = 7456, chance = 7142 }, -- Noble Axe
	{ id = 9057, chance = 14285 }, -- Small Topaz
	{ id = 3032, chance = 23214 }, -- Small Emerald
	{ id = 3036, chance = 6250 }, -- Violet Gem
	{ id = 25361, chance = 1000 }, -- Blood of the Mountain (Item)
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
