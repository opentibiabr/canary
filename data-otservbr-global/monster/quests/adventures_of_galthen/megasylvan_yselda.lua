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
	{ id = 23373, chance = 58839, maxCount = 31 }, -- Ultimate Mana Potion
	{ id = 23375, chance = 53298, maxCount = 33 }, -- Supreme Health Potion
	{ id = 23374, chance = 33773, maxCount = 11 }, -- Ultimate Spirit Potion
	{ id = 7443, chance = 18469, maxCount = 19 }, -- Bullseye Potion
	{ id = 7439, chance = 19261, maxCount = 16 }, -- Berserk Potion
	{ id = 3041, chance = 14511 }, -- Blue Gem
	{ id = 7440, chance = 21635, maxCount = 21 }, -- Mastermind Potion
	{ id = 3038, chance = 15039, maxCount = 2 }, -- Green Gem
	{ id = 3036, chance = 17678, maxCount = 2 }, -- Violet Gem
	{ id = 3039, chance = 13192, maxCount = 2 }, -- Red Gem
	{ id = 3043, chance = 11609 }, -- Crystal Coin
	{ id = 30060, chance = 5804 }, -- Giant Emerald
	{ id = 3037, chance = 13192 }, -- Yellow Gem
	{ id = 14112, chance = 11081 }, -- Bar of Gold
	{ id = 36809, chance = 3693 }, -- Curl of Hair
	{ id = 3065, chance = 3166 }, -- Terra Rod
	{ id = 814, chance = 1583 }, -- Terra Amulet
	{ id = 830, chance = 2110 }, -- Terra Hood
	{ id = 32623, chance = 2110 }, -- Giant Topaz
	{ id = 36811, chance = 1319 }, -- Megasylvan Sapling
	{ id = 36808, chance = 3430 }, -- Old Royal Diary
	{ id = 811, chance = 1583 }, -- Terra Mantle
	{ id = 49271, chance = 1626, maxCount = 8 }, -- Transcendence Potion
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
