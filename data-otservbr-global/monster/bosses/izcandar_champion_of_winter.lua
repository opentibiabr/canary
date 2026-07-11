local mType = Game.createMonsterType("Izcandar Champion of Winter")
local monster = {}

monster.description = "Izcandar Champion of Winter"
monster.experience = 6900
monster.outfit = {
	lookType = 1137,
	lookHead = 48,
	lookBody = 38,
	lookLegs = 48,
	lookFeet = 48,
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
	{ id = 22516, chance = 100000, maxCount = 4 }, -- Silver Token
	{ id = 2995, chance = 100000 }, -- Piggy Bank
	{ id = 3035, chance = 100000, maxCount = 8 }, -- Platinum Coin
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 22721, chance = 82000, maxCount = 3 }, -- Gold Token
	{ id = 23373, chance = 73000, maxCount = 26 }, -- Ultimate Mana Potion
	{ id = 23375, chance = 64000, maxCount = 27 }, -- Supreme Health Potion
	{ id = 5892, chance = 45000 }, -- Huge Chunk of Crude Iron
	{ id = 3039, chance = 41000, maxCount = 2 }, -- Red Gem
	{ id = 23374, chance = 41000, maxCount = 26 }, -- Ultimate Spirit Potion
	{ id = 25759, chance = 36000, maxCount = 190 }, -- Royal Star
	{ id = 3043, chance = 27000, maxCount = 3 }, -- Crystal Coin
	{ id = 9058, chance = 27000 }, -- Gold Ingot
	{ id = 3324, chance = 23000 }, -- Skull Staff
	{ id = 3037, chance = 23000 }, -- Yellow Gem
	{ id = 30169, chance = 18200 }, -- Pomegranate
	{ id = 7440, chance = 18200, maxCount = 18 }, -- Mastermind Potion
	{ id = 23533, chance = 18200 }, -- Ring of Red Plasma
	{ id = 7427, chance = 18200 }, -- Chaos Mace
	{ id = 49271, chance = 13600, maxCount = 17 }, -- Transcendence Potion
	{ id = 3038, chance = 13600, maxCount = 2 }, -- Green Gem
	{ id = 23544, chance = 13600 }, -- Collar of Red Plasma
	{ id = 29422, chance = 9100 }, -- Winterblade
	{ id = 281, chance = 9100 }, -- Giant Shimmering Pearl
	{ id = 30056, chance = 9100 }, -- Ornate Locket
	{ id = 7443, chance = 9100, maxCount = 17 }, -- Bullseye Potion
	{ id = 7439, chance = 9100, maxCount = 17 }, -- Berserk Potion
	{ id = 23529, chance = 4500 }, -- Ring of Blue Plasma
	{ id = 23531, chance = 4500 }, -- Ring of Green Plasma
	{ id = 5809, chance = 4500 }, -- Soul Stone
	{ id = 30171, chance = 4500 }, -- Purple Tendril Lantern
	{ id = 5904, chance = 4500 }, -- Magic Sulphur
	{ id = 3041, chance = 4500, maxCount = 2 }, -- Blue Gem
	{ id = 30168, chance = 4500 }, -- Ice Shield
	{ id = 29944, chance = 4500 }, -- Izcandar's Snow Globe
	{ id = 23526, chance = 4500 }, -- Collar of Blue Plasma
	{ id = 23543, chance = 4500 }, -- Collar of Green Plasma
	{ id = 3036, chance = 4500 }, -- Violet Gem
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
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 310, maxDamage = 640, effect = CONST_ME_MAGIC_BLUE },
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
	{ type = "ice", condition = true },
}

mType:register(monster)
