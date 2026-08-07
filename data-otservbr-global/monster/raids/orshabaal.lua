local mType = Game.createMonsterType("Orshabaal")
local monster = {}

monster.description = "Orshabaal"
monster.experience = 10000
monster.outfit = {
	lookType = 201,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 201,
	bossRace = RARITY_NEMESIS,
}

monster.health = 22500
monster.maxHealth = 22500
monster.race = "fire"
monster.corpse = 5995
monster.speed = 270
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
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
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 2500,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 4,
	summons = {
		{ name = "demon", chance = 10, interval = 1000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "PRAISED BE MY MASTERS, THE RUTHLESS SEVEN!", yell = true },
	{ text = "YOU ARE DOOMED!", yell = true },
	{ text = "ORSHABAAL IS BACK!", yell = true },
	{ text = "Be prepared for the day my masters will come for you!", yell = false },
	{ text = "SOULS FOR ORSHABAAL!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 55000, maxCount = 176 }, -- Gold Coin
	{ id = 3035, chance = 48000, maxCount = 104 }, -- Platinum Coin
	{ id = 7642, chance = 33000, maxCount = 8 }, -- Great Spirit Potion
	{ id = 239, chance = 30000, maxCount = 9 }, -- Great Health Potion
	{ id = 238, chance = 27000, maxCount = 9 }, -- Great Mana Potion
	{ id = 2903, chance = 21000 }, -- Golden Mug
	{ id = 3054, chance = 21000 }, -- Silver Amulet
	{ id = 3275, chance = 18200 }, -- Double Axe
	{ id = 3028, chance = 18200 }, -- Small Diamond
	{ id = 3029, chance = 18200, maxCount = 18 }, -- Small Sapphire
	{ id = 3084, chance = 18200 }, -- Protection Amulet
	{ id = 7643, chance = 15200, maxCount = 9 }, -- Ultimate Health Potion
	{ id = 3026, chance = 15200, maxCount = 9 }, -- White Pearl
	{ id = 3265, chance = 15200 }, -- Two Handed Sword
	{ id = 3032, chance = 15200, maxCount = 18 }, -- Small Emerald
	{ id = 3033, chance = 15200, maxCount = 16 }, -- Small Amethyst
	{ id = 3076, chance = 15200 }, -- Crystal Ball
	{ id = 7365, chance = 12100, maxCount = 93 }, -- Onyx Arrow
	{ id = 3049, chance = 12100 }, -- Stealth Ring
	{ id = 3046, chance = 12100 }, -- Magic Light Wand
	{ id = 3061, chance = 12100 }, -- Life Crystal
	{ id = 3027, chance = 12100 }, -- Black Pearl
	{ id = 7368, chance = 12100, maxCount = 10 }, -- Assassin Star
	{ id = 3025, chance = 12100 }, -- Ancient Amulet
	{ id = 3034, chance = 9100, maxCount = 18 }, -- Talon
	{ id = 3058, chance = 9100 }, -- Strange Symbol
	{ id = 3281, chance = 9100 }, -- Giant Sword
	{ id = 3356, chance = 9100 }, -- Devil Helmet
	{ id = 3007, chance = 9100 }, -- Crystal Ring
	{ id = 3322, chance = 9100 }, -- Dragon Hammer
	{ id = 3060, chance = 6100 }, -- Orb
	{ id = 5808, chance = 6100 }, -- Orshabaal's Brain
	{ id = 3290, chance = 6100 }, -- Silver Dagger
	{ id = 3081, chance = 6100 }, -- Stone Skin Amulet
	{ id = 3062, chance = 6100 }, -- Mind Stone
	{ id = 3320, chance = 6100 }, -- Fire Axe
	{ id = 3306, chance = 6100 }, -- Golden Sickle
	{ id = 3008, chance = 6100 }, -- Crystal Necklace
	{ id = 3051, chance = 6100 }, -- Energy Ring
	{ id = 3041, chance = 6100 }, -- Blue Gem
	{ id = 6299, chance = 6100 }, -- Death Ring
	{ id = 6499, chance = 6100 }, -- Demonic Essence
	{ id = 5954, chance = 6100, maxCount = 3 }, -- Demon Horn
	{ id = 3284, chance = 3000 }, -- Ice Rapier
	{ id = 3364, chance = 3000 }, -- Golden Legs
	{ id = 3048, chance = 3000 }, -- Might Ring
	{ id = 3063, chance = 3000 }, -- Gold Ring
	{ id = 3055, chance = 3000 }, -- Platinum Amulet
	{ id = 3420, chance = 3000 }, -- Demon Shield
	{ id = 9058, chance = 3000 }, -- Gold Ingot
	{ id = 3079, chance = 3000 }, -- Boots of Haste
	{ id = 3324, chance = 3000 }, -- Skull Staff
	{ id = 3098, chance = 27780 }, -- Ring of Healing
	{ id = 2993, chance = 5560 }, -- Teddy Bear
	{ id = 3038, chance = 5560 }, -- Green Gem
	{ id = 2848, chance = 16670 }, -- Purple Tome
	{ id = 3309, chance = 5560 }, -- Thunder Hammer
	{ id = 3366, chance = 5560 }, -- Magic Plate Armor
	{ id = 3414, chance = 11110 }, -- Mastermind Shield
	{ id = 3002, chance = 5560 }, -- Voodoo Doll
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1990 },
	{ name = "combat", interval = 1000, chance = 13, type = COMBAT_MANADRAIN, minDamage = -300, maxDamage = -600, range = 7, target = false },
	{ name = "combat", interval = 1000, chance = 6, type = COMBAT_MANADRAIN, minDamage = -150, maxDamage = -350, radius = 5, effect = CONST_ME_POISONAREA, target = false },
	{ name = "effect", interval = 1000, chance = 6, radius = 5, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 1000, chance = 34, type = COMBAT_FIREDAMAGE, minDamage = -310, maxDamage = -600, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "firefield", interval = 1000, chance = 10, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, target = true },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -850, length = 8, spread = 3, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.defenses = {
	defense = 111,
	armor = 90,
	--	mitigation = ???,
	{ name = "combat", interval = 1000, chance = 9, type = COMBAT_HEALING, minDamage = 1500, maxDamage = 2500, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 1000, chance = 17, type = COMBAT_HEALING, minDamage = 600, maxDamage = 1000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 5, speedChange = 1901, effect = CONST_ME_MAGIC_RED, target = false, duration = 7000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 80 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -1 },
	{ type = COMBAT_HOLYDAMAGE, percent = -1 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
