local mType = Game.createMonsterType("Izcandar Champion of Summer")
local monster = {}

monster.description = "Izcandar Champion of Summer"
monster.experience = 6900
monster.outfit = {
	lookType = 1137,
	lookHead = 43,
	lookBody = 78,
	lookLegs = 43,
	lookFeet = 43,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 130000
monster.maxHealth = 130000
monster.race = "blood"
monster.corpse = 25151
monster.speed = 200
monster.manaCost = 0

monster.events = {
	"dreamCourtsDeath",
	"izcandarThink",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	{ text = "Dream or nightmare?", yell = false },
}

monster.loot = {
	{ id = 23535, chance = 100000 }, -- Energy Bar
	{ id = 22721, chance = 75555, maxCount = 2 }, -- Gold Token
	{ id = 2995, chance = 100000 }, -- Piggy Bank
	{ id = 3035, chance = 100000, maxCount = 5 }, -- Platinum Coin
	{ id = 22516, chance = 100000, maxCount = 2 }, -- Silver Token
	{ id = 23375, chance = 44444, maxCount = 20 }, -- Supreme Health Potion
	{ id = 3039, chance = 26666 }, -- Red Gem
	{ id = 3043, chance = 24444, maxCount = 3 }, -- Crystal Coin
	{ id = 3038, chance = 20000 }, -- Green Gem
	{ id = 5892, chance = 37777 }, -- Huge Chunk of Crude Iron
	{ id = 25759, chance = 40000, maxCount = 100 }, -- Royal Star
	{ id = 23373, chance = 46666, maxCount = 14 }, -- Ultimate Mana Potion
	{ id = 23374, chance = 62222, maxCount = 6 }, -- Ultimate Spirit Potion
	{ id = 7439, chance = 13333, maxCount = 10 }, -- Berserk Potion
	{ id = 23544, chance = 24444 }, -- Collar of Red Plasma
	{ id = 281, chance = 17777 }, -- Giant Shimmering Pearl
	{ id = 23531, chance = 8888 }, -- Ring of Green Plasma
	{ id = 23533, chance = 6666 }, -- Ring of Red Plasma
	{ id = 3324, chance = 22222 }, -- Skull Staff
	{ id = 5809, chance = 4444 }, -- Soul Stone
	{ id = 29945, chance = 5882 }, -- Izcandar's Sundial
	{ id = 30169, chance = 11111 }, -- Pomegranate
	{ id = 29421, chance = 6666 }, -- Summerblade
	{ id = 3037, chance = 35555 }, -- Yellow Gem
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 23529, chance = 8888 }, -- Ring of Blue Plasma
	{ id = 7443, chance = 26666 }, -- Bullseye Potion
	{ id = 9058, chance = 6666 }, -- Gold Ingot
	{ id = 5904, chance = 4444 }, -- Magic Sulphur
	{ id = 7440, chance = 22222 }, -- Mastermind Potion
	{ id = 3041, chance = 26666 }, -- Blue Gem
	{ id = 7427, chance = 14705 }, -- Chaos Mace
	{ id = 3006, chance = 8823 }, -- Ring of the Sky
	{ id = 3036, chance = 11764 }, -- Violet Gem
	{ id = 23526, chance = 8823 }, -- Collar of Blue Plasma
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -320, maxDamage = -750 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = -500, maxDamage = -850, radius = 6, effect = false, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DROWNDAMAGE, minDamage = -300, maxDamage = -850, length = 8, spread = 3, effect = false, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -444, maxDamage = -850, radius = 4, effect = false, shootEffect = CONST_ANI_SUDDENDEATH, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -410, maxDamage = -850, length = 9, effect = false, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -410, maxDamage = -850, length = 9, effect = false, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -410, maxDamage = -850, length = 9, effect = false, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -410, maxDamage = -850, radius = 3, shootEffect = CONST_ANI_EARTH, effect = false, target = false },
}

monster.defenses = {
	defense = 76,
	armor = 76,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 310, maxDamage = 640, effect = CONST_ME_REDSPARK },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "invisible", condition = true },
	{ type = "fire", condition = true },
}

mType:register(monster)
