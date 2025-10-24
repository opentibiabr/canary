local mType = Game.createMonsterType("The Monster")
local monster = {}

monster.description = "The Monster"
monster.experience = 30000
monster.outfit = {
	lookType = 1600,
}

monster.bosstiary = {
	bossRaceId = 2299,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 450000
monster.maxHealth = 450000
monster.race = "blood"
monster.corpse = 42247
monster.speed = 180
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15,
}

monster.strategiesTarget = {
	nearest = 60,
	health = 30,
	damage = 10,
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
	critChance = 10,
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

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 30 }, -- Platinum Coin
	{ id = 7643, chance = 41904, maxCount = 7 }, -- Ultimate Health Potion
	{ id = 23373, chance = 33333, maxCount = 5 }, -- Ultimate Mana Potion
	{ id = 23374, chance = 24761, maxCount = 4 }, -- Ultimate Spirit Potion
	{ id = 7440, chance = 33333, maxCount = 3 }, -- Mastermind Potion
	{ id = 7439, chance = 24761, maxCount = 3 }, -- Berserk Potion
	{ id = 7443, chance = 35238, maxCount = 3 }, -- Bullseye Potion
	{ id = 3037, chance = 28571, maxCount = 5 }, -- Yellow Gem
	{ id = 3039, chance = 24761, maxCount = 2 }, -- Red Gem
	{ id = 3041, chance = 17142 }, -- Blue Gem
	{ id = 3038, chance = 17142 }, -- Green Gem
	{ id = 3036, chance = 12380 }, -- Violet Gem
	{ id = 32622, chance = 12380 }, -- Giant Amethyst
	{ id = 32623, chance = 7619 }, -- Giant Topaz
	{ id = 30060, chance = 16190 }, -- Giant Emerald
	{ id = 40594, chance = 1000 }, -- Alchemist's Notepad
	{ id = 40588, chance = 1000 }, -- Antler-Horn Helmet
	{ id = 40595, chance = 1818 }, -- Mutant Bone Kilt
	{ id = 40591, chance = 1000 }, -- Mutated Skin Armor
	{ id = 40590, chance = 2000 }, -- Mutated Skin Legs
	{ id = 40589, chance = 1000 }, -- Stitched Mutant Hide Legs
	{ id = 40592, chance = 1000 }, -- Alchemist's Boots
	{ id = 40593, chance = 1000 }, -- Mutant Bone Boots
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -2800 },
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_ENERGYDAMAGE, minDamage = -600, maxDamage = -1200, effect = CONST_ME_ENERGYAREA, target = true, radius = 5, range = 3 },
	{ name = "destroy magic walls", interval = 1000, chance = 50 },
}

monster.defenses = {
	defense = 54,
	armor = 59,
	mitigation = 3.7,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 900, maxDamage = 2400, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
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
