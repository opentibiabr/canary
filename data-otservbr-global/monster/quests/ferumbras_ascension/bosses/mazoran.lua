local mType = Game.createMonsterType("Mazoran")
local monster = {}

monster.description = "Mazoran"
monster.experience = 500000
monster.outfit = {
	lookType = 842,
	lookHead = 77,
	lookBody = 79,
	lookLegs = 78,
	lookFeet = 94,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"AscendantBossesDeath",
}

monster.bosstiary = {
	bossRaceId = 1186,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 290000
monster.maxHealth = 290000
monster.race = "fire"
monster.corpse = 22495
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 1,
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
	{ id = 3031, chance = 100000, maxCount = 357 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 40 }, -- Platinum Coin
	{ id = 22516, chance = 100000 }, -- Silver Token
	{ id = 16126, chance = 80000, maxCount = 7 }, -- Red Crystal Fragment
	{ id = 6499, chance = 74000 }, -- Demonic Essence
	{ id = 16127, chance = 71000, maxCount = 7 }, -- Green Crystal Fragment
	{ id = 16125, chance = 69000, maxCount = 7 }, -- Cyan Crystal Fragment
	{ id = 238, chance = 63000, maxCount = 15 }, -- Great Mana Potion
	{ id = 7643, chance = 60000, maxCount = 15 }, -- Ultimate Health Potion
	{ id = 6558, chance = 46000, maxCount = 8 }, -- Flask of Demonic Blood
	{ id = 7642, chance = 46000, maxCount = 10 }, -- Great Spirit Potion
	{ id = 3033, chance = 29000, maxCount = 9 }, -- Small Amethyst
	{ id = 3051, chance = 26000 }, -- Energy Ring
	{ id = 817, chance = 23000 }, -- Magma Amulet
	{ id = 3038, chance = 23000 }, -- Green Gem
	{ id = 3032, chance = 23000, maxCount = 9 }, -- Small Emerald
	{ id = 9057, chance = 20000, maxCount = 9 }, -- Small Topaz
	{ id = 3041, chance = 17100 }, -- Blue Gem
	{ id = 3037, chance = 17100 }, -- Yellow Gem
	{ id = 3039, chance = 17100 }, -- Red Gem
	{ id = 281, chance = 17100 }, -- Giant Shimmering Pearl
	{ id = 3030, chance = 14300, maxCount = 7 }, -- Small Ruby
	{ id = 3315, chance = 14300 }, -- Guardian Halberd
	{ id = 3029, chance = 11400, maxCount = 9 }, -- Small Sapphire
	{ id = 22727, chance = 8600 }, -- Rift Lance
	{ id = 22866, chance = 8600 }, -- Rift Bow
	{ id = 821, chance = 8600 }, -- Magma Legs
	{ id = 3320, chance = 8600 }, -- Fire Axe
	{ id = 16115, chance = 5700 }, -- Wand of Everblazing
	{ id = 22726, chance = 5700 }, -- Rift Shield
	{ id = 3036, chance = 5700 }, -- Violet Gem
	{ id = 826, chance = 5700 }, -- Magma Coat
	{ id = 3019, chance = 2900 }, -- Demonbone Amulet
	{ id = 22867, chance = 2900 }, -- Rift Crossbow
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1500, maxDamage = -2500 },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -1000, length = 10, spread = 3, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "speed", interval = 2000, chance = 25, speedChange = -600, radius = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -700, radius = 5, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -800, length = 10, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -800, length = 8, spread = 3, effect = CONST_ME_FIREATTACK, target = false },
}

monster.defenses = {
	defense = 125,
	armor = 125,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 2090, maxDamage = 4500, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 35, speedChange = 700, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 6000 },
	{ name = "mazoran fire", interval = 30000, chance = 45, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
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
