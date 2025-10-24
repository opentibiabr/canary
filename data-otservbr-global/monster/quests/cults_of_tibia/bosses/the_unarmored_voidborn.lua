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
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 30 }, -- Platinum Coin
	{ id = 23535, chance = 100000, maxCount = 5 }, -- Energy Bar
	{ id = 238, chance = 50000, maxCount = 5 }, -- Great Mana Potion
	{ id = 7642, chance = 61842, maxCount = 5 }, -- Great Spirit Potion
	{ id = 7643, chance = 59210, maxCount = 5 }, -- Ultimate Health Potion
	{ id = 3029, chance = 26315, maxCount = 10 }, -- Small Sapphire
	{ id = 3033, chance = 18421, maxCount = 10 }, -- Small Amethyst
	{ id = 3038, chance = 18421 }, -- Green Gem
	{ id = 3037, chance = 25000 }, -- Yellow Gem
	{ id = 3039, chance = 23684 }, -- Red Gem
	{ id = 9058, chance = 64473 }, -- Gold Ingot
	{ id = 23529, chance = 14473 }, -- Ring of Blue Plasma
	{ id = 23543, chance = 10526 }, -- Collar of Green Plasma
	{ id = 22191, chance = 100000 }, -- Skull Fetish
	{ id = 7786, chance = 1000 }, -- Orc Tusk
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 830, chance = 14516 }, -- Terra Hood
	{ id = 5887, chance = 22368 }, -- Piece of Royal Steel
	{ id = 22516, chance = 32894 }, -- Silver Token
	{ id = 22721, chance = 14473 }, -- Gold Token
	{ id = 5904, chance = 65789 }, -- Magic Sulphur
	{ id = 23544, chance = 13157 }, -- Collar of Red Plasma
	{ id = 3032, chance = 11290 }, -- Small Emerald
	{ id = 281, chance = 13157 }, -- Giant Shimmering Pearl
	{ id = 812, chance = 7894 }, -- Terra Legs
	{ id = 21171, chance = 9677 }, -- Metal Bat
	{ id = 7428, chance = 11842 }, -- Bonebreaker
	{ id = 7388, chance = 4838 }, -- Vile Axe
	{ id = 23526, chance = 9210 }, -- Collar of Blue Plasma
	{ id = 3041, chance = 14473 }, -- Blue Gem
	{ id = 9057, chance = 25000 }, -- Small Topaz
	{ id = 25360, chance = 7142 }, -- Heart of the Mountain (Item)
	{ id = 3028, chance = 24242 }, -- Small Diamond
	{ id = 23533, chance = 13636 }, -- Ring of Red Plasma
	{ id = 23531, chance = 9090 }, -- Ring of Green Plasma
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
