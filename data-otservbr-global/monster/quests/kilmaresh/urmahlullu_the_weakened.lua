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
	{ id = 23535, chance = 100000 }, -- Energy Bar
	{ id = 3035, chance = 100000, maxCount = 9 }, -- Platinum Coin
	{ id = 3038, chance = 100000, maxCount = 3 }, -- Green Gem
	{ id = 23373, chance = 57000, maxCount = 29 }, -- Ultimate Mana Potion
	{ id = 23375, chance = 54000, maxCount = 35 }, -- Supreme Health Potion
	{ id = 3039, chance = 37000, maxCount = 2 }, -- Red Gem
	{ id = 3037, chance = 36000, maxCount = 2 }, -- Yellow Gem
	{ id = 23374, chance = 33000, maxCount = 32 }, -- Ultimate Spirit Potion
	{ id = 25759, chance = 31000, maxCount = 192 }, -- Royal Star
	{ id = 816, chance = 30000 }, -- Lightning Pendant
	{ id = 7439, chance = 22000, maxCount = 19 }, -- Berserk Potion
	{ id = 3041, chance = 22000, maxCount = 2 }, -- Blue Gem
	{ id = 761, chance = 21000, maxCount = 191 }, -- Flash Arrow
	{ id = 281, chance = 16900 }, -- Giant Shimmering Pearl
	{ id = 826, chance = 15800 }, -- Magma Coat
	{ id = 7443, chance = 15800, maxCount = 18 }, -- Bullseye Potion
	{ id = 7440, chance = 15300, maxCount = 19 }, -- Mastermind Potion
	{ id = 817, chance = 14800 }, -- Magma Amulet
	{ id = 9058, chance = 13100 }, -- Gold Ingot
	{ id = 3043, chance = 10400, maxCount = 5 }, -- Crystal Coin
	{ id = 3036, chance = 10400 }, -- Violet Gem
	{ id = 827, chance = 9800 }, -- Magma Monocle
	{ id = 31263, chance = 9300 }, -- Ring of Secret Thoughts
	{ id = 49271, chance = 8200, maxCount = 18 }, -- Transcendence Potion
	{ id = 822, chance = 7700 }, -- Lightning Legs
	{ id = 22516, chance = 6600, maxCount = 5 }, -- Silver Token
	{ id = 31622, chance = 6600 }, -- Urmahlullu's Tail
	{ id = 50150, chance = 4400 }, -- Ring of Orange Plasma
	{ id = 30059, chance = 3800 }, -- Giant Ruby
	{ id = 31557, chance = 2700 }, -- Enchanted Blister Ring
	{ id = 31573, chance = 2200 }, -- Sun Medal
	{ id = 30061, chance = 2200 }, -- Giant Sapphire
	{ id = 30060, chance = 2200 }, -- Giant Emerald
	{ id = 31614, chance = 1600 }, -- Tagralt Blade
	{ id = 31624, chance = 1600 }, -- Urmahlullu's Paw
	{ id = 31623, chance = 1100 }, -- Urmahlullu's Mane
	{ id = 31575, chance = 550 }, -- Golden Bijou
	{ id = 30402, chance = 550 }, -- Enchanted Theurgic Amulet
	{ id = 31572, chance = 550 }, -- Blue and Golden Cordon
	{ id = 31574, chance = 550 }, -- Sunray Emblem
	{ id = 31617, chance = 550 }, -- Winged Boots
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
