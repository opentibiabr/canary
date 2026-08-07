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
	{ id = 23535, chance = 100000, maxCount = 9 }, -- Energy Bar
	{ id = 3035, chance = 100000, maxCount = 44 }, -- Platinum Coin
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 3031, chance = 100000, maxCount = 382 }, -- Gold Coin
	{ id = 23506, chance = 99000 }, -- Plasma Pearls
	{ id = 23510, chance = 99000 }, -- Odd Organ
	{ id = 9653, chance = 69000 }, -- Witch Hat
	{ id = 9304, chance = 67000, maxCount = 2 }, -- Shockwave Amulet
	{ id = 3071, chance = 67000 }, -- Wand of Inferno
	{ id = 238, chance = 60000, maxCount = 13 }, -- Great Mana Potion
	{ id = 7642, chance = 57000, maxCount = 14 }, -- Great Spirit Potion
	{ id = 7643, chance = 48000, maxCount = 16 }, -- Ultimate Health Potion
	{ id = 22721, chance = 27000 }, -- Gold Token
	{ id = 3032, chance = 24000, maxCount = 19 }, -- Small Emerald
	{ id = 22516, chance = 24000 }, -- Silver Token
	{ id = 3038, chance = 24000 }, -- Green Gem
	{ id = 3029, chance = 21000, maxCount = 19 }, -- Small Sapphire
	{ id = 3037, chance = 18700 }, -- Yellow Gem
	{ id = 9057, chance = 18700, maxCount = 18 }, -- Small Topaz
	{ id = 3039, chance = 17300 }, -- Red Gem
	{ id = 3041, chance = 17300 }, -- Blue Gem
	{ id = 3033, chance = 14700, maxCount = 18 }, -- Small Amethyst
	{ id = 3028, chance = 13300, maxCount = 19 }, -- Small Diamond
	{ id = 3369, chance = 13300 }, -- Warrior Helmet
	{ id = 3320, chance = 13300 }, -- Fire Axe
	{ id = 281, chance = 12000 }, -- Giant Shimmering Pearl
	{ id = 827, chance = 9300 }, -- Magma Monocle
	{ id = 3420, chance = 9300 }, -- Demon Shield
	{ id = 16096, chance = 6700 }, -- Wand of Defiance
	{ id = 16115, chance = 6700 }, -- Wand of Everblazing
	{ id = 7456, chance = 5300 }, -- Noble Axe
	{ id = 23529, chance = 5300 }, -- Ring of Blue Plasma
	{ id = 8063, chance = 5300 }, -- Paladin Armor
	{ id = 3036, chance = 2700 }, -- Violet Gem
	{ id = 23531, chance = 2700 }, -- Ring of Green Plasma
	{ id = 822, chance = 2700 }, -- Lightning Legs
	{ id = 25361, chance = 1300 }, -- Blood of the Mountain (Item)
	{ id = 11693, chance = 1300 }, -- Blade of Corruption
	{ id = 23533, chance = 1300 }, -- Ring of Red Plasma
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
