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
	{ id = 28792, chance = 1000 }, -- Sturdy Book
	{ id = 30060, chance = 25000 }, -- Giant Emerald
	{ id = 3038, chance = 12500 }, -- Green Gem
	{ id = 3037, chance = 20833 }, -- Yellow Gem
	{ id = 5904, chance = 8333 }, -- Magic Sulphur
	{ id = 27933, chance = 9677 }, -- Ominous Book
	{ id = 27934, chance = 4166 }, -- Knowledgeable Book
	{ id = 7642, chance = 21875, maxCount = 4 }, -- Great Spirit Potion
	{ id = 23374, chance = 1000, maxCount = 4 }, -- Ultimate Spirit Potion
	{ id = 7643, chance = 35483, maxCount = 4 }, -- Ultimate Health Potion
	{ id = 23373, chance = 100000, maxCount = 8 }, -- Ultimate Mana Potion
	{ id = 7439, chance = 29032, maxCount = 2 }, -- Berserk Potion
	{ id = 3073, chance = 1000 }, -- Wand of Cosmic Energy
	{ id = 3071, chance = 70967 }, -- Wand of Inferno
	{ id = 7419, chance = 41935 }, -- Dreaded Cleaver
	{ id = 3081, chance = 100000 }, -- Stone Skin Amulet
	{ id = 3035, chance = 100000, maxCount = 58 }, -- Platinum Coin
	{ id = 3043, chance = 100000, maxCount = 4 }, -- Crystal Coin
	{ id = 22193, chance = 67741, maxCount = 12 }, -- Onyx Chip
	{ id = 3033, chance = 28125, maxCount = 12 }, -- Small Amethyst
	{ id = 3032, chance = 25000, maxCount = 12 }, -- Small Emerald
	{ id = 3028, chance = 12903, maxCount = 12 }, -- Small Diamond
	{ id = 3079, chance = 48000 }, -- Boots of Haste
	{ id = 22516, chance = 56250, maxCount = 6 }, -- Silver Token
	{ id = 22721, chance = 45161, maxCount = 5 }, -- Gold Token
	{ id = 5954, chance = 53125 }, -- Demon Horn
	{ id = 7440, chance = 31250, maxCount = 2 }, -- Mastermind Potion
	{ id = 8908, chance = 21875 }, -- Slightly Rusted Helmet
	{ id = 281, chance = 12000 }, -- Giant Shimmering Pearl
	{ id = 10438, chance = 1000 }, -- Spellweaver's Robe
	{ id = 7407, chance = 29032 }, -- Haunted Blade
	{ id = 7443, chance = 29032 }, -- Bullseye Potion
	{ id = 8902, chance = 29166 }, -- Slightly Rusted Shield
	{ id = 6499, chance = 25806 }, -- Demonic Essence
	{ id = 9057, chance = 25806 }, -- Small Topaz
	{ id = 23507, chance = 29166 }, -- Crystallized Anger
	{ id = 3041, chance = 41935 }, -- Blue Gem
	{ id = 28829, chance = 4166 }, -- Rotten Demonbone
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
