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
	{ id = 22721, chance = 87500, maxCount = 2 }, -- Gold Token
	{ id = 2995, chance = 100000 }, -- Piggy Bank
	{ id = 3035, chance = 100000, maxCount = 5 }, -- Platinum Coin
	{ id = 22516, chance = 100000, maxCount = 2 }, -- Silver Token
	{ id = 3037, chance = 37500, maxCount = 2 }, -- Yellow Gem
	{ id = 23375, chance = 56250, maxCount = 20 }, -- Supreme Health Potion
	{ id = 23373, chance = 59375, maxCount = 14 }, -- Ultimate Mana Potion
	{ id = 23374, chance = 56250, maxCount = 20 }, -- Ultimate Spirit Potion
	{ id = 5892, chance = 40625 }, -- Huge Chunk of Crude Iron
	{ id = 3039, chance = 43750 }, -- Red Gem
	{ id = 23529, chance = 18750 }, -- Ring of Blue Plasma
	{ id = 7443, chance = 18750, maxCount = 10 }, -- Bullseye Potion
	{ id = 7427, chance = 18750 }, -- Chaos Mace
	{ id = 281, chance = 15625 }, -- Giant Shimmering Pearl
	{ id = 3041, chance = 12500 }, -- Blue Gem
	{ id = 7440, chance = 21875, maxCount = 10 }, -- Mastermind Potion
	{ id = 25759, chance = 28125, maxCount = 100 }, -- Royal Star
	{ id = 29422, chance = 15625 }, -- Winterblade
	{ id = 7439, chance = 9375, maxCount = 10 }, -- Berserk Potion
	{ id = 23543, chance = 12500 }, -- Collar of Green Plasma
	{ id = 23544, chance = 12500 }, -- Collar of Red Plasma
	{ id = 3043, chance = 18750, maxCount = 2 }, -- Crystal Coin
	{ id = 30056, chance = 6250 }, -- Ornate Locket
	{ id = 30169, chance = 12500 }, -- Pomegranate
	{ id = 23533, chance = 15625 }, -- Ring of Red Plasma
	{ id = 3006, chance = 18750 }, -- Ring of the Sky
	{ id = 3324, chance = 21875 }, -- Skull Staff
	{ id = 29944, chance = 6250 }, -- Izcandar's Snow Globe
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 5904, chance = 6250 }, -- Magic Sulphur
	{ id = 3038, chance = 12500 }, -- Green Gem
	{ id = 9058, chance = 31250 }, -- Gold Ingot
	{ id = 30168, chance = 6250 }, -- Ice Shield
	{ id = 3036, chance = 6250 }, -- Violet Gem
	{ id = 23531, chance = 6250 }, -- Ring of Green Plasma
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
