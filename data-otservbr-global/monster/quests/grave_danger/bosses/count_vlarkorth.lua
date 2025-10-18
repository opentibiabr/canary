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
	{ id = 3035, chance = 100000, maxCount = 5 }, -- Platinum Coin
	{ id = 22516, chance = 100000, maxCount = 2 }, -- Silver Token
	{ id = 23373, chance = 57090, maxCount = 20 }, -- Ultimate Mana Potion
	{ id = 23375, chance = 59636, maxCount = 20 }, -- Supreme Health Potion
	{ id = 23374, chance = 52000, maxCount = 20 }, -- Ultimate Spirit Potion
	{ id = 7439, chance = 20363, maxCount = 10 }, -- Berserk Potion
	{ id = 3043, chance = 19272, maxCount = 2 }, -- Crystal Coin
	{ id = 3371, chance = 26181 }, -- Knight Legs
	{ id = 23531, chance = 6909 }, -- Ring of Green Plasma
	{ id = 3041, chance = 15272 }, -- Blue Gem
	{ id = 23544, chance = 10909 }, -- Collar of Red Plasma
	{ id = 3037, chance = 32000 }, -- Yellow Gem
	{ id = 7443, chance = 17818, maxCount = 10 }, -- Bullseye Potion
	{ id = 23543, chance = 10181 }, -- Collar of Green Plasma
	{ id = 9058, chance = 17818 }, -- Gold Ingot
	{ id = 3038, chance = 17454, maxCount = 2 }, -- Green Gem
	{ id = 7440, chance = 20363, maxCount = 10 }, -- Mastermind Potion
	{ id = 23529, chance = 8363 }, -- Ring of Blue Plasma
	{ id = 3324, chance = 16000 }, -- Skull Staff
	{ id = 3036, chance = 7636 }, -- Violet Gem
	{ id = 31590, chance = 9090 }, -- Young Lich Worm
	{ id = 31591, chance = 1454 }, -- Medal of Valiance
	{ id = 31577, chance = 1401 }, -- Terra Helmet
	{ id = 31738, chance = 2409 }, -- Final Judgement
	{ id = 31579, chance = 1454 }, -- Embrace of Nature
	{ id = 5904, chance = 10545 }, -- Magic Sulphur
	{ id = 23533, chance = 6181 }, -- Ring of Red Plasma
	{ id = 3039, chance = 39272 }, -- Red Gem
	{ id = 23526, chance = 12000 }, -- Collar of Blue Plasma
	{ id = 818, chance = 9090 }, -- Magma Boots
	{ id = 31588, chance = 5090 }, -- Ancient Liche Bone
	{ id = 31578, chance = 1807 }, -- Bear Skin
	{ id = 31589, chance = 5090 }, -- Rotten Heart
	{ id = 30060, chance = 3271 }, -- Giant Emerald
	{ id = 30061, chance = 3636 }, -- Giant Sapphire
	{ id = 30059, chance = 2752 }, -- Giant Ruby
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
