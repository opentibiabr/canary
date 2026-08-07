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
	{ id = 3035, chance = 100000, maxCount = 9 }, -- Platinum Coin
	{ id = 2995, chance = 100000 }, -- Piggy Bank
	{ id = 22516, chance = 100000, maxCount = 4 }, -- Silver Token
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 22721, chance = 82000, maxCount = 3 }, -- Gold Token
	{ id = 23374, chance = 69000, maxCount = 35 }, -- Ultimate Spirit Potion
	{ id = 23373, chance = 49000, maxCount = 29 }, -- Ultimate Mana Potion
	{ id = 3037, chance = 44000, maxCount = 2 }, -- Yellow Gem
	{ id = 25759, chance = 38000, maxCount = 194 }, -- Royal Star
	{ id = 5892, chance = 38000 }, -- Huge Chunk of Crude Iron
	{ id = 23375, chance = 33000, maxCount = 22 }, -- Supreme Health Potion
	{ id = 3041, chance = 28000, maxCount = 2 }, -- Blue Gem
	{ id = 7443, chance = 26000, maxCount = 15 }, -- Bullseye Potion
	{ id = 7440, chance = 26000, maxCount = 16 }, -- Mastermind Potion
	{ id = 3039, chance = 23000 }, -- Red Gem
	{ id = 3324, chance = 23000 }, -- Skull Staff
	{ id = 3043, chance = 21000, maxCount = 2 }, -- Crystal Coin
	{ id = 3038, chance = 17900, maxCount = 2 }, -- Green Gem
	{ id = 23544, chance = 17900 }, -- Collar of Red Plasma
	{ id = 7439, chance = 15400, maxCount = 19 }, -- Berserk Potion
	{ id = 281, chance = 15400 }, -- Giant Shimmering Pearl
	{ id = 30169, chance = 12800 }, -- Pomegranate
	{ id = 3036, chance = 12800 }, -- Violet Gem
	{ id = 7427, chance = 12800 }, -- Chaos Mace
	{ id = 23531, chance = 10300 }, -- Ring of Green Plasma
	{ id = 3006, chance = 7700 }, -- Ring of the Sky
	{ id = 29421, chance = 7700 }, -- Summerblade
	{ id = 23529, chance = 7700 }, -- Ring of Blue Plasma
	{ id = 5904, chance = 7700 }, -- Magic Sulphur
	{ id = 9058, chance = 7700 }, -- Gold Ingot
	{ id = 23526, chance = 7700 }, -- Collar of Blue Plasma
	{ id = 23533, chance = 5100 }, -- Ring of Red Plasma
	{ id = 5809, chance = 5100 }, -- Soul Stone
	{ id = 29945, chance = 5100 }, -- Izcandar's Sundial
	{ id = 23543, chance = 5100 }, -- Collar of Green Plasma
	{ id = 49271, chance = 2600, maxCount = 6 }, -- Transcendence Potion
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
