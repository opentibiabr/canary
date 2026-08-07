local mType = Game.createMonsterType("Gorzindel")
local monster = {}

monster.description = "Gorzindel"
monster.experience = 100000
monster.outfit = {
	lookType = 1062,
	lookHead = 94,
	lookBody = 81,
	lookLegs = 10,
	lookFeet = 0,
	lookAddons = 1,
	lookMount = 0,
}

monster.events = {
	"gorzindelHealth",
}

monster.bosstiary = {
	bossRaceId = 1591,
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
}

monster.loot = {
	{ id = 3043, chance = 100000, maxCount = 9 }, -- Crystal Coin
	{ id = 3081, chance = 100000 }, -- Stone Skin Amulet
	{ id = 3035, chance = 100000, maxCount = 57 }, -- Platinum Coin
	{ id = 5954, chance = 100000 }, -- Demon Horn
	{ id = 23375, chance = 80000, maxCount = 8 }, -- Supreme Health Potion
	{ id = 22516, chance = 80000, maxCount = 11 }, -- Silver Token
	{ id = 7419, chance = 80000 }, -- Dreaded Cleaver
	{ id = 3073, chance = 60000 }, -- Wand of Cosmic Energy
	{ id = 23374, chance = 60000, maxCount = 5 }, -- Ultimate Spirit Potion
	{ id = 23373, chance = 60000, maxCount = 13 }, -- Ultimate Mana Potion
	{ id = 7439, chance = 60000, maxCount = 2 }, -- Berserk Potion
	{ id = 7427, chance = 60000 }, -- Chaos Mace
	{ id = 22193, chance = 40000, maxCount = 5 }, -- Onyx Chip
	{ id = 3032, chance = 40000, maxCount = 11 }, -- Small Emerald
	{ id = 3554, chance = 40000 }, -- Steel Boots
	{ id = 7440, chance = 40000, maxCount = 2 }, -- Mastermind Potion
	{ id = 22721, chance = 40000, maxCount = 7 }, -- Gold Token
	{ id = 30061, chance = 40000 }, -- Giant Sapphire
	{ id = 3041, chance = 40000 }, -- Blue Gem
	{ id = 8902, chance = 20000 }, -- Slightly Rusted Shield
	{ id = 8908, chance = 20000 }, -- Slightly Rusted Helmet
	{ id = 3033, chance = 20000, maxCount = 23 }, -- Small Amethyst
	{ id = 3030, chance = 20000, maxCount = 7 }, -- Small Ruby
	{ id = 9057, chance = 20000, maxCount = 21 }, -- Small Topaz
	{ id = 16117, chance = 20000 }, -- Muck Rod
	{ id = 281, chance = 20000 }, -- Giant Shimmering Pearl
	{ id = 3038, chance = 20000 }, -- Green Gem
	{ id = 7443, chance = 20000, maxCount = 2 }, -- Bullseye Potion
	{ id = 23511, chance = 20000 }, -- Curious Matter
	{ id = 3037, chance = 20000 }, -- Yellow Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 100, attack = 100 },
	{ name = "melee", interval = 2000, chance = 15, minDamage = -600, maxDamage = -2800 },
	{ name = "melee", interval = 1000, chance = 15, minDamage = -800, maxDamage = -1300 },
	{ name = "melee", interval = 1000, chance = 15, minDamage = -800, maxDamage = -1000 },
	{ name = "melee", interval = 1000, chance = 15, minDamage = -200, maxDamage = -800 },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -600, radius = 9, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.defenses = {
	defense = 33,
	armor = 28,
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
