local mType = Game.createMonsterType("The Souldespoiler")
local monster = {}

monster.description = "The Souldespoiler"
monster.experience = 50000
monster.outfit = {
	lookType = 875,
	lookHead = 0,
	lookBody = 3,
	lookLegs = 77,
	lookFeet = 81,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"CultsOfTibiaBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1422,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 290000
monster.maxHealth = 290000
monster.race = "blood"
monster.corpse = 23564
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 6000,
	chance = 30,
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

monster.summon = {
	maxSummons = 5,
	summons = {
		{ name = "Freed Soul", chance = 5, interval = 5000, count = 5 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Stop freeing the souls! They are mine alone!", yell = false },
	{ text = "The souls shall not escape me! ", yell = false },
	{ text = " You will be mine!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 23535, chance = 100000, maxCount = 5 }, -- Energy Bar
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 3035, chance = 100000, maxCount = 30 }, -- Platinum Coin
	{ id = 3033, chance = 17857, maxCount = 10 }, -- Small Amethyst
	{ id = 3028, chance = 17857, maxCount = 10 }, -- Small Diamond
	{ id = 3032, chance = 14285, maxCount = 10 }, -- Small Emerald
	{ id = 9057, chance = 26785, maxCount = 10 }, -- Small Topaz
	{ id = 23510, chance = 98214 }, -- Odd Organ
	{ id = 23506, chance = 98214 }, -- Plasma Pearls
	{ id = 24962, chance = 64285, maxCount = 10 }, -- Prismatic Quartz
	{ id = 3041, chance = 19642 }, -- Blue Gem
	{ id = 3038, chance = 14285 }, -- Green Gem
	{ id = 3037, chance = 26785 }, -- Yellow Gem
	{ id = 23511, chance = 64285, maxCount = 10 }, -- Curious Matter
	{ id = 23518, chance = 67857, maxCount = 10 }, -- Spark Sphere
	{ id = 281, chance = 17857 }, -- Giant Shimmering Pearl
	{ id = 7643, chance = 66071, maxCount = 5 }, -- Ultimate Health Potion
	{ id = 7642, chance = 46428, maxCount = 5 }, -- Great Spirit Potion
	{ id = 238, chance = 48214, maxCount = 5 }, -- Great Mana Potion
	{ id = 7437, chance = 4545 }, -- Sapphire Hammer
	{ id = 7407, chance = 15909 }, -- Haunted Blade
	{ id = 7452, chance = 17857, maxCount = 2 }, -- Spiked Squelcher
	{ id = 16096, chance = 21428 }, -- Wand of Defiance
	{ id = 22516, chance = 23214 }, -- Silver Token
	{ id = 22721, chance = 25000 }, -- Gold Token
	{ id = 7435, chance = 1000 }, -- Impaler
	{ id = 11688, chance = 1000 }, -- Shield of Corruption
	{ id = 3029, chance = 14285 }, -- Small Sapphire
	{ id = 8072, chance = 4545 }, -- Spellbook of Enlightenment
	{ id = 3036, chance = 5555 }, -- Violet Gem
	{ id = 3436, chance = 13636 }, -- Medusa Shield
	{ id = 818, chance = 12500 }, -- Magma Boots
	{ id = 25360, chance = 8333 }, -- Heart of the Mountain (Item)
	{ id = 8082, chance = 5357 }, -- Underworld Rod
	{ id = 7419, chance = 13157 }, -- Dreaded Cleaver
	{ id = 3039, chance = 15789 }, -- Red Gem
	{ id = 22727, chance = 8333 }, -- Rift Lance
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -783 },
	{ name = "combat", interval = 2000, chance = 60, type = COMBAT_DEATHDAMAGE, minDamage = -30, maxDamage = -181, range = 7, radius = 3, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_ENERGYDAMAGE, minDamage = -210, maxDamage = -538, length = 7, spread = 2, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "combat", interval = 3000, chance = 30, type = COMBAT_DROWNDAMAGE, minDamage = -125, maxDamage = -640, length = 9, spread = 0, effect = CONST_ME_LOSEENERGY, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 7000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
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

mType:register(monster)
