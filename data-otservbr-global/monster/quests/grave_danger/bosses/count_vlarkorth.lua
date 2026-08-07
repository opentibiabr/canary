local mType = Game.createMonsterType("Count Vlarkorth")
local monster = {}

monster.description = "Count Vlarkorth"
monster.experience = 55000
monster.outfit = {
	lookType = 1221,
	lookHead = 19,
	lookBody = 0,
	lookLegs = 83,
	lookFeet = 20,
	lookAddons = 1,
	lookMount = 0,
}

monster.events = {
	"count_vlarkorth_transform",
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
	bossRaceId = 1753,
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
	maxSummons = 4,
	summons = {
		{ name = "Soulless Minion", chance = 70, interval = 5500, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 9 }, -- Platinum Coin
	{ id = 22516, chance = 100000, maxCount = 3 }, -- Silver Token
	{ id = 23373, chance = 67000, maxCount = 28 }, -- Ultimate Mana Potion
	{ id = 23375, chance = 57000, maxCount = 37 }, -- Supreme Health Potion
	{ id = 23374, chance = 45000, maxCount = 30 }, -- Ultimate Spirit Potion
	{ id = 3037, chance = 39000, maxCount = 2 }, -- Yellow Gem
	{ id = 3039, chance = 35000, maxCount = 2 }, -- Red Gem
	{ id = 7439, chance = 24000, maxCount = 19 }, -- Berserk Potion
	{ id = 9058, chance = 21000 }, -- Gold Ingot
	{ id = 3038, chance = 20000, maxCount = 2 }, -- Green Gem
	{ id = 3371, chance = 18100 }, -- Knight Legs
	{ id = 7440, chance = 17000, maxCount = 19 }, -- Mastermind Potion
	{ id = 3324, chance = 16000 }, -- Skull Staff
	{ id = 3043, chance = 14900, maxCount = 3 }, -- Crystal Coin
	{ id = 7443, chance = 13800, maxCount = 17 }, -- Bullseye Potion
	{ id = 23526, chance = 13800 }, -- Collar of Blue Plasma
	{ id = 3041, chance = 12800, maxCount = 2 }, -- Blue Gem
	{ id = 818, chance = 11700 }, -- Magma Boots
	{ id = 5904, chance = 11700, maxCount = 3 }, -- Magic Sulphur
	{ id = 3036, chance = 10600 }, -- Violet Gem
	{ id = 23544, chance = 9600 }, -- Collar of Red Plasma
	{ id = 31588, chance = 9600 }, -- Ancient Liche Bone
	{ id = 31590, chance = 8500 }, -- Young Lich Worm
	{ id = 23531, chance = 8500 }, -- Ring of Green Plasma
	{ id = 23543, chance = 7400 }, -- Collar of Green Plasma
	{ id = 30061, chance = 5300 }, -- Giant Sapphire
	{ id = 49271, chance = 4300, maxCount = 16 }, -- Transcendence Potion
	{ id = 23529, chance = 4300 }, -- Ring of Blue Plasma
	{ id = 23533, chance = 3200 }, -- Ring of Red Plasma
	{ id = 31589, chance = 3200 }, -- Rotten Heart
	{ id = 31738, chance = 2100 }, -- Final Judgement
	{ id = 31591, chance = 2100 }, -- Medal of Valiance
	{ id = 31578, chance = 1100 }, -- Bear Skin
	{ id = 31579, chance = 1100 }, -- Embrace of Nature
	{ id = 30060, chance = 1100 }, -- Giant Emerald
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -800, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", interval = 2300, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -250, maxDamage = -350, range = 1, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = -1, maxDamage = -250, length = 7, spread = 0, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2500, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -1500, length = 7, spread = 0, effect = CONST_ME_HITBYFIRE, target = false },
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
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
