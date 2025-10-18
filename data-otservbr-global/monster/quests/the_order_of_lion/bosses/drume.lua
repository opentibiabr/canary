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
	{ id = 23535, chance = 164599 }, -- Energy Bar
	{ id = 3035, chance = 164599, maxCount = 5 }, -- Platinum Coin
	{ id = 23375, chance = 91989, maxCount = 20 }, -- Supreme Health Potion
	{ id = 23373, chance = 91602, maxCount = 14 }, -- Ultimate Mana Potion
	{ id = 3039, chance = 58720, maxCount = 2 }, -- Red Gem
	{ id = 25759, chance = 47545, maxCount = 100 }, -- Royal Star
	{ id = 7443, chance = 32299, maxCount = 16 }, -- Bullseye Potion
	{ id = 281, chance = 25258 }, -- Giant Shimmering Pearl
	{ id = 3038, chance = 28359 }, -- Green Gem
	{ id = 3081, chance = 16472 }, -- Stone Skin Amulet
	{ id = 3037, chance = 56007 }, -- Yellow Gem
	{ id = 3041, chance = 29974 }, -- Blue Gem
	{ id = 812, chance = 13565 }, -- Terra Legs
	{ id = 811, chance = 12015 }, -- Terra Mantle
	{ id = 7439, chance = 31782, maxCount = 10 }, -- Berserk Potion
	{ id = 3043, chance = 16925 }, -- Crystal Coin
	{ id = 30061, chance = 8139 }, -- Giant Sapphire
	{ id = 7440, chance = 32428, maxCount = 10 }, -- Mastermind Potion
	{ id = 830, chance = 9302 }, -- Terra Hood
	{ id = 23374, chance = 53940, maxCount = 6 }, -- Ultimate Spirit Potion
	{ id = 8082, chance = 4521 }, -- Underworld Rod
	{ id = 33778, chance = 6718 }, -- Raw Watermelon Tourmaline
	{ id = 9058, chance = 22868 }, -- Gold Ingot
	{ id = 22516, chance = 16666 }, -- Silver Token
	{ id = 3036, chance = 14470 }, -- Violet Gem
	{ id = 8094, chance = 7105 }, -- Wand of Voodoo
	{ id = 814, chance = 7751 }, -- Terra Amulet
	{ id = 3065, chance = 21447 }, -- Terra Rod
	{ id = 34158, chance = 125 }, -- Lion Amulet
	{ id = 34253, chance = 387 }, -- Lion Axe
	{ id = 34150, chance = 250 }, -- Lion Longbow
	{ id = 34157, chance = 1000 }, -- Lion Plate
	{ id = 34156, chance = 1000 }, -- Lion Spangenhelm
	{ id = 34152, chance = 250 }, -- Lion Wand
	{ id = 30059, chance = 4586 }, -- Giant Ruby
	{ id = 34153, chance = 357 }, -- Lion Spellbook
	{ id = 34254, chance = 214 }, -- Lion Hammer
	{ id = 34155, chance = 286 }, -- Lion Longsword
	{ id = 34151, chance = 166 }, -- Lion Rod
	{ id = 34154, chance = 266 }, -- Lion Shield
	{ id = 50162, chance = 1000 }, -- Lion Claws
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
