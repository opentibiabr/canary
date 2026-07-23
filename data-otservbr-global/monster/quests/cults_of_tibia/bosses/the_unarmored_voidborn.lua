local mType = Game.createMonsterType("The Unarmored Voidborn")
local monster = {}

monster.description = "The Unarmored Voidborn"
monster.experience = 15000
monster.outfit = {
	lookType = 987,
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
	bossRaceId = 1406,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 250000
monster.maxHealth = 250000
monster.race = "undead"
monster.corpse = 26133
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 50,
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
	canPushCreatures = false,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 23535, chance = 100000, maxCount = 9 }, -- Energy Bar
	{ id = 22191, chance = 100000 }, -- Skull Fetish
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 3035, chance = 100000, maxCount = 47 }, -- Platinum Coin
	{ id = 3031, chance = 100000, maxCount = 384 }, -- Gold Coin
	{ id = 7642, chance = 65000, maxCount = 12 }, -- Great Spirit Potion
	{ id = 5904, chance = 64000 }, -- Magic Sulphur
	{ id = 9058, chance = 62000 }, -- Gold Ingot
	{ id = 7643, chance = 55000, maxCount = 13 }, -- Ultimate Health Potion
	{ id = 238, chance = 51000, maxCount = 17 }, -- Great Mana Potion
	{ id = 22516, chance = 31000 }, -- Silver Token
	{ id = 5887, chance = 27000 }, -- Piece of Royal Steel
	{ id = 3028, chance = 26000, maxCount = 18 }, -- Small Diamond
	{ id = 3037, chance = 26000 }, -- Yellow Gem
	{ id = 9057, chance = 24000, maxCount = 18 }, -- Small Topaz
	{ id = 3029, chance = 23000, maxCount = 19 }, -- Small Sapphire
	{ id = 22721, chance = 20000 }, -- Gold Token
	{ id = 281, chance = 19000 }, -- Giant Shimmering Pearl
	{ id = 3039, chance = 19000 }, -- Red Gem
	{ id = 3038, chance = 17900 }, -- Green Gem
	{ id = 3033, chance = 17900, maxCount = 18 }, -- Small Amethyst
	{ id = 23533, chance = 15500 }, -- Ring of Red Plasma
	{ id = 23529, chance = 15500 }, -- Ring of Blue Plasma
	{ id = 23543, chance = 11900 }, -- Collar of Green Plasma
	{ id = 3041, chance = 11900 }, -- Blue Gem
	{ id = 7414, chance = 11900 }, -- Abyss Hammer
	{ id = 23531, chance = 11900 }, -- Ring of Green Plasma
	{ id = 3032, chance = 9500, maxCount = 19 }, -- Small Emerald
	{ id = 830, chance = 9500 }, -- Terra Hood
	{ id = 7428, chance = 8300 }, -- Bonebreaker
	{ id = 23544, chance = 8300 }, -- Collar of Red Plasma
	{ id = 7451, chance = 8300 }, -- Shadow Sceptre
	{ id = 21171, chance = 6000 }, -- Metal Bat
	{ id = 812, chance = 4800 }, -- Terra Legs
	{ id = 5741, chance = 4800 }, -- Skull Helmet
	{ id = 23526, chance = 4800 }, -- Collar of Blue Plasma
	{ id = 7388, chance = 2400 }, -- Vile Axe
	{ id = 8052, chance = 1200 }, -- Swamplair Armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -400, length = 7, spread = 5, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -250, maxDamage = -440, radius = 5, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 50,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -300 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -255 },
	{ type = COMBAT_EARTHDAMAGE, percent = -255 },
	{ type = COMBAT_FIREDAMAGE, percent = -255 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -300 },
	{ type = COMBAT_HOLYDAMAGE, percent = -300 },
	{ type = COMBAT_DEATHDAMAGE, percent = -300 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
