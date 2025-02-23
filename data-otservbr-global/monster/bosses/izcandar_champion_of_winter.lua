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
	{ name = "Energy Bar", chance = 100000 },
	{ name = "Gold Token", chance = 100000, maxCount = 2 },
	{ name = "Piggy Bank", chance = 100000 },
	{ name = "Platinum Coin", chance = 100000, maxCount = 5 },
	{ name = "Silver Token", chance = 100000, maxCount = 2 },
	{ name = "Mysterious Remains", chance = 100000 },
	{ name = "Yellow Gem", chance = 69230, maxCount = 2 },
	{ name = "Ultimate Spirit Potion", chance = 61540, maxCount = 20 },
	{ name = "Supreme Health Potion", chance = 53850, maxCount = 20 },
	{ name = "Ultimate Mana Potion", chance = 53850, maxCount = 14 },
	{ id = 3039, chance = 46150 }, -- red gem
	{ id = 23529, chance = 38460 }, -- Ring of Blue Plasma
	{ name = "Chaos Mace", chance = 23080 },
	{ name = "Huge Chunk of Crude Iron", chance = 30777 },
	{ name = "Bullseye Potion", chance = 23080, maxCount = 10 },
	{ name = "Winterblade", chance = 100, unique = true },
	{ id = 281, chance = 23080 }, -- giant shimmering pearl
	{ name = "Royal Star", chance = 23080, maxCount = 100 },
	{ name = "Blue Gem", chance = 15380 },
	{ name = "Mastermind Potion", chance = 15380, maxCount = 10 },
	{ name = "Skull Staff", chance = 15380 },
	{ name = "Berserk Potion", chance = 7690, maxCount = 10 },
	{ id = 23543, chance = 7690 }, -- Collar of Green Plasma
	{ id = 23544, chance = 7690 }, -- Collar of Red Plasma
	{ name = "Crystal Coin", chance = 7690, maxCount = 2 },
	{ name = "Ornate Locket", chance = 7690 },
	{ name = "Pomegranate", chance = 7690 },
	{ id = 23533, chance = 7690 }, -- Ring of Red Plasma
	{ name = "Ring of the Sky", chance = 7690 },
	{ name = "Izcandar's Snow Globe", chance = 1500 },
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
