local mType = Game.createMonsterType("Urmahlullu the Weakened")
local monster = {}

monster.description = "Urmahlullu the Weakened"
monster.experience = 55000
monster.outfit = {
	lookType = 1197,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1811,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 100000
monster.maxHealth = 512000
monster.race = "blood"
monster.corpse = 31413
monster.speed = 95
monster.manaCost = 0

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
	staticAttackChance = 70,
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
	{ text = "You will regret this!", yell = false },
	{ text = "Now you have to die!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 99862, maxCount = 9 }, -- Platinum Coin
	{ id = 23535, chance = 99725 }, -- Energy Bar
	{ id = 23375, chance = 54120, maxCount = 20 }, -- Supreme Health Potion
	{ id = 23373, chance = 55631, maxCount = 20 }, -- Ultimate Mana Potion
	{ id = 3037, chance = 35488 }, -- Yellow Gem
	{ id = 23374, chance = 34662, maxCount = 7 }, -- Ultimate Spirit Potion
	{ id = 3039, chance = 36263, maxCount = 2 }, -- Red Gem
	{ id = 761, chance = 20357, maxCount = 100 }, -- Flash Arrow
	{ id = 25759, chance = 29670, maxCount = 100 }, -- Royal Star
	{ id = 816, chance = 26272 }, -- Lightning Pendant
	{ id = 3038, chance = 96148 }, -- Green Gem
	{ id = 7443, chance = 19394, maxCount = 10 }, -- Bullseye Potion
	{ id = 7439, chance = 20357, maxCount = 12 }, -- Berserk Potion
	{ id = 826, chance = 15818 }, -- Magma Coat
	{ id = 3041, chance = 19119, maxCount = 2 }, -- Blue Gem
	{ id = 3043, chance = 10041, maxCount = 3 }, -- Crystal Coin
	{ id = 281, chance = 14855 }, -- Giant Shimmering Pearl
	{ id = 817, chance = 12792 }, -- Magma Amulet
	{ id = 7440, chance = 17881, maxCount = 18 }, -- Mastermind Potion
	{ id = 30402, chance = 1650 }, -- Enchanted Theurgic Amulet
	{ id = 30061, chance = 4401 }, -- Giant Sapphire
	{ id = 9058, chance = 16346 }, -- Gold Ingot
	{ id = 22516, chance = 9491, maxCount = 5 }, -- Silver Token
	{ id = 3036, chance = 8528 }, -- Violet Gem
	{ id = 30060, chance = 1650 }, -- Giant Emerald
	{ id = 30059, chance = 3988 }, -- Giant Ruby
	{ id = 827, chance = 10866 }, -- Magma Monocle
	{ id = 31263, chance = 12087 }, -- Ring of Secret Thoughts
	{ id = 31623, chance = 1788 }, -- Urmahlullu's Mane
	{ id = 31624, chance = 3713 }, -- Urmahlullu's Paw
	{ id = 31622, chance = 4676 }, -- Urmahlullu's Tail
	{ id = 31614, chance = 1788 }, -- Tagralt Blade
	{ id = 30323, chance = 340 }, -- Rainbow Necklace
	{ id = 31617, chance = 850 }, -- Winged Boots
	{ id = 31572, chance = 1190 }, -- Blue and Golden Cordon
	{ id = 31575, chance = 1000 }, -- Golden Bijou
	{ id = 31573, chance = 1375 }, -- Sun Medal
	{ id = 31625, chance = 850 }, -- Winged Backpack
	{ id = 822, chance = 7977 }, -- Lightning Legs
	{ id = 31557, chance = 3163 }, -- Enchanted Blister Ring
	{ id = 31574, chance = 500 }, -- Sunray Emblem
	{ id = 49271, chance = 4316, maxCount = 19 }, -- Transcendence Potion
	{ id = 50150, chance = 2877 }, -- Ring of Orange Plasma
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -50, maxDamage = -1100 },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -800, radius = 4, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -550, maxDamage = -800, radius = 3, effect = CONST_ME_FIREAREA, target = false },
	{ name = "urmahlulluring", interval = 2000, chance = 18, minDamage = -450, maxDamage = -600, target = false },
}

monster.defenses = {
	defense = 84,
	armor = 84,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
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
