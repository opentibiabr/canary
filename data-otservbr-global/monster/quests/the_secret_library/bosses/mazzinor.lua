local mType = Game.createMonsterType("Mazzinor")
local monster = {}

monster.description = "Mazzinor"
monster.experience = 100000
monster.outfit = {
	lookType = 1062,
	lookHead = 85,
	lookBody = 7,
	lookLegs = 3,
	lookFeet = 15,
	lookAddons = 2,
	lookMount = 0,
}

monster.events = {
	"mazzinorDeath",
	"mazzinorHealth",
}

monster.bosstiary = {
	bossRaceId = 1605,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "blood"
monster.corpse = 22495
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 4,
}

monster.strategiesTarget = {
	nearest = 100,
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
	staticAttackChance = 98,
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
	{ id = 3043, chance = 85000, maxCount = 10 }, -- Crystal Coin
	{ id = 6499, chance = 26315 }, -- Demonic Essence
	{ id = 8902, chance = 28947 }, -- Slightly Rusted Shield
	{ id = 3035, chance = 100000, maxCount = 39 }, -- Platinum Coin
	{ id = 7443, chance = 45000 }, -- Bullseye Potion
	{ id = 7439, chance = 40000 }, -- Berserk Potion
	{ id = 22516, chance = 78947, maxCount = 6 }, -- Silver Token
	{ id = 281, chance = 12121 }, -- Giant Shimmering Pearl
	{ id = 3028, chance = 15000, maxCount = 12 }, -- Small Diamond
	{ id = 3030, chance = 29032, maxCount = 12 }, -- Small Ruby
	{ id = 3037, chance = 22580 }, -- Yellow Gem
	{ id = 820, chance = 32500 }, -- Lightning Boots
	{ id = 5954, chance = 37500 }, -- Demon Horn
	{ id = 27933, chance = 50000 }, -- Ominous Book
	{ id = 23375, chance = 57500, maxCount = 4 }, -- Supreme Health Potion
	{ id = 23374, chance = 60000, maxCount = 8 }, -- Ultimate Spirit Potion
	{ id = 23373, chance = 50000, maxCount = 12 }, -- Ultimate Mana Potion
	{ id = 8092, chance = 67500 }, -- Wand of Starstorm
	{ id = 22193, chance = 65000, maxCount = 12 }, -- Onyx Chip
	{ id = 3081, chance = 100000 }, -- Stone Skin Amulet
	{ id = 22721, chance = 30000, maxCount = 4 }, -- Gold Token
	{ id = 28793, chance = 50000 }, -- Epaulette
	{ id = 7419, chance = 35000 }, -- Dreaded Cleaver
	{ id = 12603, chance = 1000 }, -- Wand of Dimensions
	{ id = 23519, chance = 25000 }, -- Frozen Lightning
	{ id = 27934, chance = 50000 }, -- Knowledgeable Book
	{ id = 3038, chance = 20000 }, -- Green Gem
	{ id = 28830, chance = 1000 }, -- Energized Demonbone
	{ id = 5904, chance = 28947 }, -- Magic Sulphur
	{ id = 825, chance = 6451 }, -- Lightning Robe
	{ id = 7440, chance = 31578 }, -- Mastermind Potion
	{ id = 9057, chance = 32258 }, -- Small Topaz
	{ id = 3039, chance = 21052 }, -- Red Gem
	{ id = 3019, chance = 6451 }, -- Demonbone Amulet
	{ id = 30060, chance = 19354 }, -- Giant Emerald
	{ id = 8908, chance = 23684 }, -- Slightly Rusted Helmet
	{ id = 16117, chance = 12903 }, -- Muck Rod
	{ id = 3033, chance = 21052 }, -- Small Amethyst
	{ id = 3041, chance = 26315 }, -- Blue Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 90, attack = 80 },
	{ name = "divine missile", interval = 2000, chance = 10, minDamage = -135, maxDamage = -700, target = true },
	{ name = "berserk", interval = 2000, chance = 20, minDamage = -90, maxDamage = -500, range = 7, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -135, maxDamage = -280, range = 7, radius = 5, effect = CONST_ME_MAGIC_BLUE, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -210, maxDamage = -600, length = 8, spread = 0, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HOLYDAMAGE, minDamage = -210, maxDamage = -700, length = 8, spread = 0, effect = CONST_ME_HOLYAREA, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
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
