local mType = Game.createMonsterType("Megasylvan Yselda")
local monster = {}

monster.description = "Megasylvan Yselda"
monster.experience = 19900
monster.outfit = {
	lookTypeEx = 36928,
}

monster.bosstiary = {
	bossRaceId = 2114,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 32000
monster.maxHealth = 32000
monster.race = "blood"
monster.corpse = 36929
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canPushItems = false,
	canPushCreatures = true,
	staticAttackChance = 70,
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
	maxSummons = 1,
	summons = {
		{ name = "Carnisylvan Sapling", chance = 70, interval = 2000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "What are you... doing!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 9 }, -- Platinum Coin
	{ id = 8010, chance = 100000, maxCount = 5 }, -- Potato
	{ id = 23375, chance = 58000, maxCount = 36 }, -- Supreme Health Potion
	{ id = 23373, chance = 55000, maxCount = 35 }, -- Ultimate Mana Potion
	{ id = 23374, chance = 31000, maxCount = 11 }, -- Ultimate Spirit Potion
	{ id = 7440, chance = 23000, maxCount = 20 }, -- Mastermind Potion
	{ id = 7443, chance = 19500, maxCount = 18 }, -- Bullseye Potion
	{ id = 3036, chance = 15700, maxCount = 2 }, -- Violet Gem
	{ id = 7439, chance = 14300, maxCount = 17 }, -- Berserk Potion
	{ id = 3043, chance = 13800, maxCount = 5 }, -- Crystal Coin
	{ id = 3037, chance = 12900, maxCount = 2 }, -- Yellow Gem
	{ id = 3038, chance = 11900, maxCount = 2 }, -- Green Gem
	{ id = 3041, chance = 11000, maxCount = 2 }, -- Blue Gem
	{ id = 14112, chance = 10000 }, -- Bar of Gold
	{ id = 3039, chance = 9000 }, -- Red Gem
	{ id = 49271, chance = 5700, maxCount = 18 }, -- Transcendence Potion
	{ id = 30060, chance = 4300 }, -- Giant Emerald
	{ id = 36808, chance = 3300 }, -- Old Royal Diary
	{ id = 811, chance = 2400 }, -- Terra Mantle
	{ id = 3065, chance = 1900 }, -- Terra Rod
	{ id = 830, chance = 1900 }, -- Terra Hood
	{ id = 36809, chance = 1400 }, -- Curl of Hair
	{ id = 814, chance = 1400 }, -- Terra Amulet
	{ id = 36811, chance = 950 }, -- megasylvan sapling
	{ id = 32623, chance = 480 }, -- Giant Topaz
	{ id = 812, chance = 480 }, -- Terra Legs
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -270, maxDamage = -500 },
	{ name = "earth beamMY", interval = 2000, chance = 50, minDamage = -400, maxDamage = -900, target = false },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -800, range = 5, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -800, radius = 5, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "mana leechMY", interval = 2000, chance = 50, minDamage = -100, maxDamage = -400, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 82,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 85 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 80 },
	{ type = COMBAT_EARTHDAMAGE, percent = 90 },
	{ type = COMBAT_FIREDAMAGE, percent = 60 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 90 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 70 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
