local mType = Game.createMonsterType("Lokathmor")
local monster = {}

monster.description = "Lokathmor"
monster.experience = 100000
monster.outfit = {
	lookType = 1062,
	lookHead = 22,
	lookBody = 57,
	lookLegs = 79,
	lookFeet = 77,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"lokathmorDeath",
}

monster.bosstiary = {
	bossRaceId = 1574,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "blood"
monster.corpse = 7893
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

monster.summon = {
	maxSummons = 5,
	summons = {
		{ name = "demon blood", chance = 10, interval = 2000, count = 5 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3043, chance = 100000, maxCount = 5 }, -- Crystal Coin
	{ id = 23373, chance = 100000, maxCount = 14 }, -- Ultimate Mana Potion
	{ id = 3081, chance = 100000 }, -- Stone Skin Amulet
	{ id = 3035, chance = 100000, maxCount = 44 }, -- Platinum Coin
	{ id = 22193, chance = 86000, maxCount = 23 }, -- Onyx Chip
	{ id = 3071, chance = 86000 }, -- Wand of Inferno
	{ id = 3039, chance = 57000 }, -- Red Gem
	{ id = 22516, chance = 57000, maxCount = 10 }, -- Silver Token
	{ id = 22721, chance = 43000, maxCount = 4 }, -- Gold Token
	{ id = 7643, chance = 43000, maxCount = 4 }, -- Ultimate Health Potion
	{ id = 6499, chance = 43000, maxCount = 4 }, -- Demonic Essence
	{ id = 3033, chance = 43000, maxCount = 14 }, -- Small Amethyst
	{ id = 3041, chance = 43000 }, -- Blue Gem
	{ id = 7443, chance = 43000, maxCount = 3 }, -- Bullseye Potion
	{ id = 7439, chance = 43000, maxCount = 2 }, -- Berserk Potion
	{ id = 9057, chance = 29000, maxCount = 5 }, -- Small Topaz
	{ id = 7440, chance = 29000, maxCount = 2 }, -- Mastermind Potion
	{ id = 7407, chance = 29000 }, -- Haunted Blade
	{ id = 8908, chance = 29000 }, -- Slightly Rusted Helmet
	{ id = 3567, chance = 29000 }, -- Blue Robe
	{ id = 5954, chance = 29000 }, -- Demon Horn
	{ id = 27933, chance = 14300 }, -- Ominous Book
	{ id = 27932, chance = 14300 }, -- Sinister Book
	{ id = 7642, chance = 14300, maxCount = 6 }, -- Great Spirit Potion
	{ id = 3028, chance = 14300, maxCount = 19 }, -- Small Diamond
	{ id = 7419, chance = 14300 }, -- Dreaded Cleaver
	{ id = 3030, chance = 14300, maxCount = 2 }, -- Small Ruby
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 150, attack = 250 },
	{ name = "combat", interval = 2000, chance = 8, type = COMBAT_LIFEDRAIN, minDamage = -1100, maxDamage = -2800, range = 7, radius = 5, shootEffect = CONST_ANI_WHIRLWINDAXE, effect = CONST_ME_DRAWBLOOD, target = true },
	{ name = "combat", interval = 1000, chance = 8, type = COMBAT_DEATHDAMAGE, minDamage = -800, maxDamage = -1900, radius = 9, effect = CONST_ME_MORTAREA, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 5000, chance = 18, minDamage = -1100, maxDamage = -2500, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -1000, maxDamage = -255, range = 7, radius = 6, effect = CONST_ME_LOSEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 8, type = COMBAT_PHYSICALDAMAGE, minDamage = -90, maxDamage = -200, range = 7, shootEffect = CONST_ANI_WHIRLWINDAXE, effect = CONST_ME_EXPLOSIONAREA, target = true },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
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
