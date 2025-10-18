local mType = Game.createMonsterType("Morgaroth")
local monster = {}

monster.description = "Morgaroth"
monster.experience = 15000
monster.outfit = {
	lookType = 12,
	lookHead = 2,
	lookBody = 94,
	lookLegs = 78,
	lookFeet = 79,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 229,
	bossRace = RARITY_NEMESIS,
}

monster.health = 55000
monster.maxHealth = 55000
monster.race = "fire"
monster.corpse = 6068
monster.speed = 305
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 20,
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
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 100,
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

monster.summon = {
	maxSummons = 6,
	summons = {
		{ name = "Demon", chance = 33, interval = 4000, count = 6 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I AM MORGAROTH, LORD OF THE TRIANGLE... AND YOU ARE LOST!", yell = true },
	{ text = "MY SEED IS FEAR AND MY HARVEST ARE YOUR SOULS!", yell = true },
	{ text = "ZATHROTH! LOOK AT THE DESTRUCTION I AM CAUSING IN YOUR NAME!", yell = true },
	{ text = "THE TRIANGLE OF TERROR WILL RISE!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 40909, maxCount = 295 }, -- Gold Coin
	{ id = 3035, chance = 84846, maxCount = 74 }, -- Platinum Coin
	{ id = 6499, chance = 38804, maxCount = 5 }, -- Demonic Essence
	{ id = 3033, chance = 21210, maxCount = 18 }, -- Small Amethyst
	{ id = 3032, chance = 20688, maxCount = 7 }, -- Small Emerald
	{ id = 3028, chance = 6062, maxCount = 5 }, -- Small Diamond
	{ id = 3026, chance = 10607, maxCount = 11 }, -- White Pearl
	{ id = 3029, chance = 17240, maxCount = 9 }, -- Small Sapphire
	{ id = 3027, chance = 13637, maxCount = 13 }, -- Black Pearl
	{ id = 3034, chance = 12122, maxCount = 7 }, -- Talon
	{ id = 9058, chance = 6666 }, -- Gold Ingot
	{ id = 5954, chance = 13794, maxCount = 2 }, -- Demon Horn
	{ id = 6528, chance = 15909, maxCount = 100 }, -- Infernal Bolt
	{ id = 7368, chance = 12122, maxCount = 35 }, -- Assassin Star
	{ id = 3025, chance = 1000 }, -- Ancient Amulet
	{ id = 3041, chance = 9999 }, -- Blue Gem
	{ id = 3079, chance = 1000 }, -- Boots of Haste
	{ id = 3076, chance = 9090 }, -- Crystal Ball
	{ id = 3063, chance = 7575 }, -- Gold Ring
	{ id = 3007, chance = 10607 }, -- Crystal Ring
	{ id = 6299, chance = 11941 }, -- Death Ring
	{ id = 3420, chance = 5172 }, -- Demon Shield
	{ id = 7431, chance = 17394 }, -- Demonbone
	{ id = 3356, chance = 6818 }, -- Devil Helmet
	{ id = 3275, chance = 18180 }, -- Double Axe
	{ id = 3051, chance = 18181 }, -- Energy Ring
	{ id = 3320, chance = 4550 }, -- Fire Axe
	{ id = 3281, chance = 5172 }, -- Giant Sword
	{ id = 3364, chance = 6896 }, -- Golden Legs
	{ id = 2903, chance = 15152 }, -- Golden Mug
	{ id = 239, chance = 4550 }, -- Great Health Potion
	{ id = 238, chance = 35819 }, -- Great Mana Potion
	{ id = 7642, chance = 33332 }, -- Great Spirit Potion
	{ id = 3038, chance = 24137 }, -- Green Gem
	{ id = 3284, chance = 1000 }, -- Ice Rapier
	{ id = 3061, chance = 16666 }, -- Life Crystal
	{ id = 3046, chance = 20895 }, -- Magic Light Wand
	{ id = 3265, chance = 1000 }, -- Two Handed Sword
	{ id = 3366, chance = 8620 }, -- Magic Plate Armor
	{ id = 826, chance = 6818 }, -- Magma Coat
	{ id = 3414, chance = 4550 }, -- Mastermind Shield
	{ id = 3048, chance = 17240 }, -- Might Ring
	{ id = 3062, chance = 16666 }, -- Mind Stone
	{ id = 3070, chance = 1000 }, -- Moonlight Rod
	{ id = 3069, chance = 1000 }, -- Necrotic Rod
	{ id = 7421, chance = 12500 }, -- Onyx Flail
	{ id = 3060, chance = 12120 }, -- Orb
	{ id = 3055, chance = 1000 }, -- Platinum Amulet
	{ id = 2848, chance = 1000 }, -- Purple Tome
	{ id = 2852, chance = 16665 }, -- Red Tome
	{ id = 3098, chance = 21213 }, -- Ring of Healing
	{ id = 3006, chance = 12500 }, -- Ring of the Sky
	{ id = 3054, chance = 1000 }, -- Silver Amulet
	{ id = 3290, chance = 1000 }, -- Silver Dagger
	{ id = 3324, chance = 1000 }, -- Skull Staff
	{ id = 3049, chance = 24241 }, -- Stealth Ring
	{ id = 3081, chance = 1000 }, -- Stone Skin Amulet
	{ id = 3058, chance = 9090 }, -- Strange Symbol
	{ id = 7643, chance = 28786 }, -- Ultimate Health Potion
	{ id = 3554, chance = 8620 }, -- Steel Boots
	{ id = 8022, chance = 10345 }, -- Chain Bolter
	{ id = 8037, chance = 22730 }, -- Dark Lord's Cape
	{ id = 8039, chance = 4550 }, -- Dragon Robe
	{ id = 8053, chance = 18180 }, -- Fireborn Giant Armor
	{ id = 3422, chance = 100000 }, -- Great Shield
	{ id = 8058, chance = 4550 }, -- Molten Plate
	{ id = 5943, chance = 13640 }, -- Morgaroth's Heart
	{ id = 8100, chance = 13640 }, -- Obsidian Truncheon
	{ id = 8023, chance = 8620 }, -- Royal Crossbow
	{ id = 2993, chance = 10344 }, -- Teddy Bear
	{ id = 8024, chance = 39126 }, -- The Devileye
	{ id = 8025, chance = 22730 }, -- The Ironworker
	{ id = 8101, chance = 13640 }, -- The Stomper
	{ id = 3309, chance = 9090 }, -- Thunder Hammer
	{ id = 821, chance = 6818 }, -- Magma Legs
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -2250 },
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -1210, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 1800, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -580, range = 7, radius = 5, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 3000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -300, maxDamage = -1450, length = 8, spread = 3, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 2500, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -480, range = 7, radius = 5, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -500, range = 7, radius = 13, effect = CONST_ME_SOUND_RED, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -450, radius = 14, effect = CONST_ME_LOSEENERGY, target = false },
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -200, range = 7, radius = 3, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -400, range = 7, effect = CONST_ME_SOUND_RED, target = false, duration = 20000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -70, maxDamage = -320, radius = 3, effect = CONST_ME_HITAREA, target = true },
	{ name = "dark torturer skill reducer", interval = 2000, chance = 5, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 130,
	--	mitigation = ???,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 800, maxDamage = 1100, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 9000, chance = 15, type = COMBAT_HEALING, minDamage = 3800, maxDamage = 4000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 4000, chance = 80, speedChange = 470, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 80 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 80 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
