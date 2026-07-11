local mType = Game.createMonsterType("Sir Baeloc")
local monster = {}

monster.description = "Sir Baeloc"
monster.experience = 55000
monster.outfit = {
	lookType = 1222,
	lookHead = 57,
	lookBody = 81,
	lookLegs = 3,
	lookFeet = 93,
	lookAddons = 1,
	lookMount = 0,
}

monster.health = 75000
monster.maxHealth = 75000
monster.race = "venom"
monster.corpse = 31599
monster.speed = 125
monster.manaCost = 0

monster.events = {
	"BossHealthCheck",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1755,
	bossRace = RARITY_ARCHFOE,
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

monster.summon = {
	maxSummons = 3,
	summons = {
		{ name = "Retainer of Baeloc", chance = 20, interval = 2000, count = 3 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 9 }, -- Platinum Coin
	{ id = 22516, chance = 100000, maxCount = 3 }, -- Silver Token
	{ id = 23375, chance = 60000, maxCount = 36 }, -- Supreme Health Potion
	{ id = 23373, chance = 56000, maxCount = 36 }, -- Ultimate Mana Potion
	{ id = 23374, chance = 52000, maxCount = 37 }, -- Ultimate Spirit Potion
	{ id = 3039, chance = 40000, maxCount = 2 }, -- Red Gem
	{ id = 3037, chance = 37000, maxCount = 2 }, -- Yellow Gem
	{ id = 5888, chance = 34000, maxCount = 7 }, -- Piece of Hell Steel
	{ id = 3324, chance = 23000 }, -- Skull Staff
	{ id = 3043, chance = 20000, maxCount = 4 }, -- Crystal Coin
	{ id = 3371, chance = 20000 }, -- Knight Legs
	{ id = 7439, chance = 16800, maxCount = 19 }, -- Berserk Potion
	{ id = 5887, chance = 15800 }, -- Piece of Royal Steel
	{ id = 7440, chance = 13700, maxCount = 19 }, -- Mastermind Potion
	{ id = 9058, chance = 13700 }, -- Gold Ingot
	{ id = 7443, chance = 13700, maxCount = 19 }, -- Bullseye Potion
	{ id = 31590, chance = 13700 }, -- Young Lich Worm
	{ id = 23543, chance = 12600 }, -- Collar of Green Plasma
	{ id = 3041, chance = 12600 }, -- Blue Gem
	{ id = 3038, chance = 9500 }, -- Green Gem
	{ id = 23529, chance = 9500 }, -- Ring of Blue Plasma
	{ id = 23531, chance = 8400 }, -- Ring of Green Plasma
	{ id = 827, chance = 8400 }, -- Magma Monocle
	{ id = 23544, chance = 7400 }, -- Collar of Red Plasma
	{ id = 31589, chance = 6300 }, -- Rotten Heart
	{ id = 49271, chance = 6300, maxCount = 15 }, -- Transcendence Potion
	{ id = 23533, chance = 6300 }, -- Ring of Red Plasma
	{ id = 30061, chance = 5300 }, -- Giant Sapphire
	{ id = 30060, chance = 4200 }, -- Giant Emerald
	{ id = 3036, chance = 4200 }, -- Violet Gem
	{ id = 23526, chance = 4200 }, -- Collar of Blue Plasma
	{ id = 31588, chance = 4200 }, -- Ancient Liche Bone
	{ id = 31592, chance = 3200 }, -- Signet Ring
	{ id = 30059, chance = 2100 }, -- Giant Ruby
	{ id = 31577, chance = 1100 }, -- Terra Helmet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", interval = 3100, chance = 37, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -1000, length = 7, spread = 0, effect = CONST_ME_DRAWBLOOD, target = false },
	{ name = "combat", interval = 2500, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = -350, maxDamage = -625, range = 5, shootEffect = CONST_ANI_WHIRLWINDAXE, effect = CONST_ME_DRAWBLOOD, target = true },
	{ name = "combat", interval = 2700, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -180, maxDamage = -250, range = 1, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = {
	defense = 25,
	armor = 78,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_HEALING, minDamage = 350, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 70 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 35 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
