local mType = Game.createMonsterType("Plagueroot")
local monster = {}

monster.description = "Plagueroot"
monster.experience = 55000
monster.outfit = {
	lookType = 1121,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 320000
monster.maxHealth = 320000
monster.race = "venom"
monster.corpse = 30022
monster.speed = 85
monster.manaCost = 0

monster.events = {
	"dreamCourtsDeath",
	"facelessHealth",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1695,
	bossRace = RARITY_NEMESIS,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
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

monster.loot = {
	{ id = 23535, chance = 100000 }, -- Energy Bar
	{ id = 3035, chance = 100000, maxCount = 9 }, -- Platinum Coin
	{ id = 2995, chance = 100000 }, -- Piggy Bank
	{ id = 22516, chance = 100000, maxCount = 4 }, -- Silver Token
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 22721, chance = 78000, maxCount = 3 }, -- Gold Token
	{ id = 23374, chance = 65000, maxCount = 27 }, -- Ultimate Spirit Potion
	{ id = 23373, chance = 61000, maxCount = 27 }, -- Ultimate Mana Potion
	{ id = 23375, chance = 43000, maxCount = 33 }, -- Supreme Health Potion
	{ id = 3039, chance = 41000, maxCount = 2 }, -- Red Gem
	{ id = 3037, chance = 37000, maxCount = 2 }, -- Yellow Gem
	{ id = 5892, chance = 35000 }, -- Huge Chunk of Crude Iron
	{ id = 25759, chance = 33000, maxCount = 165 }, -- Royal Star
	{ id = 9058, chance = 22000 }, -- Gold Ingot
	{ id = 7443, chance = 19600, maxCount = 16 }, -- Bullseye Potion
	{ id = 23544, chance = 17400 }, -- Collar of Red Plasma
	{ id = 7427, chance = 17400 }, -- Chaos Mace
	{ id = 7440, chance = 15200, maxCount = 19 }, -- Mastermind Potion
	{ id = 3324, chance = 15200 }, -- Skull Staff
	{ id = 5904, chance = 13000 }, -- Magic Sulphur
	{ id = 3043, chance = 13000, maxCount = 3 }, -- Crystal Coin
	{ id = 3041, chance = 13000, maxCount = 2 }, -- Blue Gem
	{ id = 23526, chance = 13000 }, -- Collar of Blue Plasma
	{ id = 3036, chance = 10900 }, -- Violet Gem
	{ id = 3038, chance = 10900, maxCount = 2 }, -- Green Gem
	{ id = 3006, chance = 10900 }, -- Ring of the Sky
	{ id = 281, chance = 10900 }, -- Giant Shimmering Pearl
	{ id = 23533, chance = 8700 }, -- Ring of Red Plasma
	{ id = 30169, chance = 8700 }, -- Pomegranate
	{ id = 23529, chance = 6500 }, -- Ring of Blue Plasma
	{ id = 30060, chance = 6500 }, -- Giant Emerald
	{ id = 7439, chance = 4300, maxCount = 14 }, -- Berserk Potion
	{ id = 49271, chance = 4300, maxCount = 11 }, -- Transcendence Potion
	{ id = 23531, chance = 4300 }, -- Ring of Green Plasma
	{ id = 30055, chance = 4300 }, -- Crunor Idol
	{ id = 29418, chance = 2200 }, -- Living Armor
	{ id = 23543, chance = 2200 }, -- Collar of Green Plasma
	{ id = 29417, chance = 2200 }, -- Living Vine Bow
	{ id = 3341, chance = 2200 }, -- Arcane Staff
	{ id = 5809, chance = 2200 }, -- Soul Stone
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 210, attack = -560 },
	-- fire
	{ name = "condition", type = CONDITION_FIRE, interval = 1000, chance = 7, minDamage = -200, maxDamage = -1000, range = 2, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 1000, chance = 7, type = COMBAT_PHYSICALDAMAGE, minDamage = -350, maxDamage = -1050, radius = 6, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 1000, chance = 50, type = COMBAT_FIREDAMAGE, minDamage = -20, maxDamage = -100, radius = 5, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "firefield", interval = 1000, chance = 4, radius = 8, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 1000, chance = 34, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -650, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 1000, chance = 13, type = COMBAT_FIREDAMAGE, minDamage = -250, maxDamage = -600, length = 8, spread = 0, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -600, length = 8, spread = 0, effect = CONST_ME_FIREAREA, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 60,
	--	mitigation = ???,
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_HEALING, minDamage = 500, maxDamage = 1000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 1000, chance = 25, type = COMBAT_HEALING, minDamage = 200, maxDamage = 300, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 10, speedChange = 1800, effect = CONST_ME_MAGIC_RED, target = false, duration = 3000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 1 },
	{ type = COMBAT_EARTHDAMAGE, percent = 120 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
