local mType = Game.createMonsterType("Drume")
local monster = {}

monster.description = "Drume"
monster.experience = 25000
monster.outfit = {
	lookType = 1317,
	lookHead = 38,
	lookBody = 76,
	lookLegs = 57,
	lookFeet = 114,
	lookAddons = 2,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1957,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 80000
monster.maxHealth = 80000
monster.race = "blood"
monster.corpse = 33973
monster.speed = 130
monster.manaCost = 0

monster.faction = FACTION_LIONUSURPERS
monster.enemyFactions = { FACTION_LION, FACTION_PLAYER }

monster.summon = {
	maxSummons = 1,
	summons = {
		{ name = "preceptor lazare", chance = 10, interval = 8000, count = 1 },
		{ name = "grand commander soeren", chance = 10, interval = 8000, count = 1 },
		{ name = "grand chaplain gaunder", chance = 10, interval = 8000, count = 1 },
	},
}

monster.changeTarget = {
	interval = 4000,
	chance = 25,
}

monster.strategiesTarget = {
	nearest = 50,
	health = 20,
	damage = 20,
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "I've studied the Cobras - I wield the secrets of the snake!", yell = false },
	{ text = "I am a true knight of the lion, you will never defeat the true order!", yell = false },
	{ text = "The Falcons will come to my aid in need!", yell = false },
}

monster.loot = {
	{ id = 23535, chance = 100000 }, -- Energy Bar
	{ id = 3035, chance = 100000, maxCount = 9 }, -- Platinum Coin
	{ id = 23373, chance = 57000, maxCount = 36 }, -- Ultimate Mana Potion
	{ id = 23375, chance = 53000, maxCount = 38 }, -- Supreme Health Potion
	{ id = 23374, chance = 33000, maxCount = 11 }, -- Ultimate Spirit Potion
	{ id = 3039, chance = 31000, maxCount = 2 }, -- Red Gem
	{ id = 3037, chance = 31000, maxCount = 2 }, -- Yellow Gem
	{ id = 25759, chance = 24000, maxCount = 199 }, -- Royal Star
	{ id = 3038, chance = 23000, maxCount = 2 }, -- Green Gem
	{ id = 7440, chance = 17900, maxCount = 19 }, -- Mastermind Potion
	{ id = 3041, chance = 16700, maxCount = 2 }, -- Blue Gem
	{ id = 7443, chance = 16400, maxCount = 19 }, -- Bullseye Potion
	{ id = 9058, chance = 14000 }, -- Gold Ingot
	{ id = 22516, chance = 12800, maxCount = 5 }, -- Silver Token
	{ id = 49271, chance = 11900, maxCount = 19 }, -- Transcendence Potion
	{ id = 7439, chance = 11600, maxCount = 19 }, -- Berserk Potion
	{ id = 3065, chance = 11600 }, -- Terra Rod
	{ id = 3081, chance = 10700 }, -- Stone Skin Amulet
	{ id = 281, chance = 10400 }, -- Giant Shimmering Pearl
	{ id = 3043, chance = 9000 }, -- Crystal Coin
	{ id = 30061, chance = 8700 }, -- Giant Sapphire
	{ id = 811, chance = 8100 }, -- Terra Mantle
	{ id = 3036, chance = 7200, maxCount = 2 }, -- Violet Gem
	{ id = 812, chance = 6300 }, -- Terra Legs
	{ id = 830, chance = 4800 }, -- Terra Hood
	{ id = 33778, chance = 4500 }, -- Raw Watermelon Tourmaline
	{ id = 814, chance = 4200 }, -- Terra Amulet
	{ id = 30059, chance = 3600 }, -- Giant Ruby
	{ id = 8094, chance = 2400 }, -- Wand of Voodoo
	{ id = 8082, chance = 2400 }, -- Underworld Rod
	{ id = 34253, chance = 600 }, -- Lion Axe
	{ id = 34154, chance = 300 }, -- Lion Shield
	{ id = 34153, chance = 300 }, -- Lion Spellbook
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1100, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", interval = 2700, chance = 25, type = COMBAT_HOLYDAMAGE, minDamage = -850, maxDamage = -1150, length = 8, spread = 0, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "combat", interval = 3100, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -800, maxDamage = -1200, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 3300, chance = 22, type = COMBAT_DEATHDAMAGE, minDamage = -800, maxDamage = -1000, radius = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 3700, chance = 24, type = COMBAT_ICEDAMAGE, minDamage = -700, maxDamage = -900, length = 4, spread = 0, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "singlecloudchain", interval = 2100, chance = 34, minDamage = -600, maxDamage = -1100, range = 4, effect = CONST_ME_ENERGYHIT, target = true },
}

monster.defenses = {
	defense = 60,
	armor = 82,
	--	mitigation = ???,
	{ name = "combat", interval = 4000, chance = 40, type = COMBAT_HEALING, minDamage = 300, maxDamage = 800, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 35 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
