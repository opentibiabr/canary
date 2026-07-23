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
	{ id = 3035, chance = 80000, maxCount = 33 }, -- Platinum Coin
	{ id = 3031, chance = 49000, maxCount = 181 }, -- Gold Coin
	{ id = 7642, chance = 43000, maxCount = 9 }, -- Great Spirit Potion
	{ id = 7643, chance = 31000, maxCount = 7 }, -- Ultimate Health Potion
	{ id = 238, chance = 27000, maxCount = 9 }, -- Great Mana Potion
	{ id = 3046, chance = 24000 }, -- Magic Light Wand
	{ id = 3062, chance = 22000 }, -- Mind Stone
	{ id = 3048, chance = 20000 }, -- Might Ring
	{ id = 3098, chance = 20000 }, -- Ring of Healing
	{ id = 3049, chance = 20000 }, -- Stealth Ring
	{ id = 3051, chance = 18400 }, -- Energy Ring
	{ id = 3032, chance = 14300, maxCount = 6 }, -- Small Emerald
	{ id = 2852, chance = 14300 }, -- Red Tome
	{ id = 6528, chance = 14300, maxCount = 27 }, -- Infernal Bolt
	{ id = 3061, chance = 14300 }, -- Life Crystal
	{ id = 3029, chance = 12200, maxCount = 9 }, -- Small Sapphire
	{ id = 3058, chance = 12200 }, -- Strange Symbol
	{ id = 2903, chance = 12200 }, -- Golden Mug
	{ id = 3007, chance = 12200 }, -- Crystal Ring
	{ id = 3076, chance = 10200 }, -- Crystal Ball
	{ id = 3060, chance = 10200 }, -- Orb
	{ id = 3027, chance = 10200, maxCount = 8 }, -- Black Pearl
	{ id = 3033, chance = 8200, maxCount = 7 }, -- Small Amethyst
	{ id = 3038, chance = 8200 }, -- Green Gem
	{ id = 7368, chance = 8200, maxCount = 28 }, -- Assassin Star
	{ id = 7421, chance = 6100 }, -- Onyx Flail
	{ id = 3554, chance = 6100 }, -- Steel Boots
	{ id = 3356, chance = 6100 }, -- Devil Helmet
	{ id = 3028, chance = 6100, maxCount = 8 }, -- Small Diamond
	{ id = 6499, chance = 6100, maxCount = 3 }, -- Demonic Essence
	{ id = 5954, chance = 6100, maxCount = 3 }, -- Demon Horn
	{ id = 3034, chance = 4100, maxCount = 2 }, -- Talon
	{ id = 8100, chance = 4100 }, -- Obsidian Truncheon
	{ id = 2993, chance = 4100 }, -- Teddy Bear
	{ id = 3026, chance = 4100, maxCount = 5 }, -- White Pearl
	{ id = 821, chance = 4100 }, -- Magma Legs
	{ id = 826, chance = 4100 }, -- Magma Coat
	{ id = 3364, chance = 4100 }, -- Golden Legs
	{ id = 3320, chance = 4100 }, -- Fire Axe
	{ id = 6299, chance = 4100 }, -- Death Ring
	{ id = 3281, chance = 4100 }, -- Giant Sword
	{ id = 3063, chance = 2000 }, -- Gold Ring
	{ id = 3366, chance = 2000 }, -- Magic Plate Armor
	{ id = 9058, chance = 2000 }, -- Gold Ingot
	{ id = 3420, chance = 2000 }, -- Demon Shield
	{ id = 8022, chance = 2000 }, -- Chain Bolter
	{ id = 8023, chance = 2000 }, -- Royal Crossbow
	{ id = 8025, chance = 2000 }, -- The Ironworker
	{ id = 3041, chance = 9090 }, -- Blue Gem
	{ id = 7431, chance = 13640 }, -- Demonbone
	{ id = 3275, chance = 18180 }, -- Double Axe
	{ id = 239, chance = 4550 }, -- Great Health Potion
	{ id = 3414, chance = 4550 }, -- Mastermind Shield
	{ id = 8037, chance = 22730 }, -- Dark Lord's Cape
	{ id = 8039, chance = 4550 }, -- Dragon Robe
	{ id = 8053, chance = 18180 }, -- Fireborn Giant Armor
	{ id = 3422, chance = 100000 }, -- Great Shield
	{ id = 8058, chance = 4550 }, -- Molten Plate
	{ id = 5943, chance = 13640 }, -- Morgaroth's Heart
	{ id = 8024, chance = 36360 }, -- The Devileye
	{ id = 8101, chance = 13640 }, -- The Stomper
	{ id = 3309, chance = 9090 }, -- Thunder Hammer
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
