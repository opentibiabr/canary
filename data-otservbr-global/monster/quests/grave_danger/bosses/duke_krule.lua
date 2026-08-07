local mType = Game.createMonsterType("Duke Krule")
local monster = {}

monster.description = "Duke Krule"
monster.experience = 55000
monster.outfit = {
	lookType = 1221,
	lookHead = 8,
	lookBody = 8,
	lookLegs = 19,
	lookFeet = 79,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"grave_danger_death",
}

monster.health = 75000
monster.maxHealth = 75000
monster.race = "venom"
monster.corpse = 31599
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1758,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.summon = {
	maxSummons = 4,
	summons = {
		{ name = "Soul Scourge", chance = 20, interval = 2000, count = 4 },
	},
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 9 }, -- Platinum Coin
	{ id = 22516, chance = 100000, maxCount = 3 }, -- Silver Token
	{ id = 23374, chance = 58000, maxCount = 27 }, -- Ultimate Spirit Potion
	{ id = 23375, chance = 56000, maxCount = 32 }, -- Supreme Health Potion
	{ id = 23373, chance = 50000, maxCount = 34 }, -- Ultimate Mana Potion
	{ id = 3037, chance = 36000, maxCount = 2 }, -- Yellow Gem
	{ id = 3039, chance = 35000, maxCount = 2 }, -- Red Gem
	{ id = 5888, chance = 29000, maxCount = 7 }, -- Piece of Hell Steel
	{ id = 3391, chance = 25000 }, -- Crusader Helmet
	{ id = 3041, chance = 18800, maxCount = 2 }, -- Blue Gem
	{ id = 3043, chance = 17800, maxCount = 4 }, -- Crystal Coin
	{ id = 7440, chance = 17800, maxCount = 19 }, -- Mastermind Potion
	{ id = 7443, chance = 17800, maxCount = 19 }, -- Bullseye Potion
	{ id = 5885, chance = 16800 }, -- Flask of Warrior's Sweat
	{ id = 3038, chance = 15800 }, -- Green Gem
	{ id = 7439, chance = 14900, maxCount = 16 }, -- Berserk Potion
	{ id = 7427, chance = 13900 }, -- Chaos Mace
	{ id = 9058, chance = 13900 }, -- Gold Ingot
	{ id = 23543, chance = 12900 }, -- Collar of Green Plasma
	{ id = 31590, chance = 11900 }, -- Young Lich Worm
	{ id = 830, chance = 11900 }, -- Terra Hood
	{ id = 23529, chance = 10900 }, -- Ring of Blue Plasma
	{ id = 23526, chance = 10900 }, -- Collar of Blue Plasma
	{ id = 23544, chance = 9900 }, -- Collar of Red Plasma
	{ id = 3036, chance = 9900, maxCount = 2 }, -- Violet Gem
	{ id = 23531, chance = 7900 }, -- Ring of Green Plasma
	{ id = 31588, chance = 6900 }, -- Ancient Liche Bone
	{ id = 30061, chance = 5000 }, -- Giant Sapphire
	{ id = 49271, chance = 4000, maxCount = 8 }, -- Transcendence Potion
	{ id = 31578, chance = 2000 }, -- Bear Skin
	{ id = 23533, chance = 2000 }, -- Ring of Red Plasma
	{ id = 30060, chance = 990 }, -- Giant Emerald
	{ id = 31589, chance = 990 }, -- Rotten Heart
	{ id = 31595, chance = 990 }, -- Noble Amulet
	{ id = 31577, chance = 990 }, -- Terra Helmet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
	{ name = "combat", interval = 3500, chance = 37, type = COMBAT_PHYSICALDAMAGE, minDamage = -700, maxDamage = -1200, length = 7, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 2500, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -1000, length = 7, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 4200, chance = 40, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -500, radius = 9, effect = CONST_ME_HITBYFIRE, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 78,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_HEALING, minDamage = 150, maxDamage = 350, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
