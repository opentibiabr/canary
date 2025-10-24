local mType = Game.createMonsterType("Ferumbras")
local monster = {}

monster.description = "Ferumbras"
monster.experience = 12000
monster.outfit = {
	lookType = 229,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 231,
	bossRace = RARITY_NEMESIS,
}

monster.health = 90000
monster.maxHealth = 90000
monster.race = "venom"
monster.corpse = 6078
monster.speed = 160
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 2,
	runHealth = 2500,
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
	maxSummons = 4,
	summons = {
		{ name = "Demon", chance = 12, interval = 3000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "NO ONE WILL STOP ME THIS TIME!", yell = true },
	{ text = "THE POWER IS MINE!", yell = true },
	{ text = "I returned from death and you dream about defeating me?", yell = false },
	{ text = "Witness the first seconds of my eternal world domination!", yell = false },
	{ text = "Even in my weakened state I will crush you all!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80606, maxCount = 270 }, -- Gold Coin
	{ id = 3027, chance = 19999, maxCount = 42 }, -- Black Pearl
	{ id = 3033, chance = 11513, maxCount = 76 }, -- Small Amethyst
	{ id = 3029, chance = 12119, maxCount = 92 }, -- Small Sapphire
	{ id = 3030, chance = 4080, maxCount = 49 }, -- Small Ruby
	{ id = 3026, chance = 12725, maxCount = 8 }, -- White Pearl
	{ id = 3028, chance = 12024, maxCount = 90 }, -- Small Diamond
	{ id = 9057, chance = 11833, maxCount = 86 }, -- Small Topaz
	{ id = 3032, chance = 12728, maxCount = 100 }, -- Small Emerald
	{ id = 281, chance = 17577, maxCount = 10 }, -- Giant Shimmering Pearl
	{ id = 5944, chance = 26665, maxCount = 8 }, -- Soul Orb
	{ id = 9058, chance = 31547, maxCount = 2 }, -- Gold Ingot
	{ id = 3034, chance = 1000 }, -- Talon
	{ id = 3066, chance = 1000 }, -- Snakebite Rod
	{ id = 3069, chance = 1000 }, -- Necrotic Rod
	{ id = 3063, chance = 1000 }, -- Gold Ring
	{ id = 3320, chance = 1000 }, -- Fire Axe
	{ id = 3007, chance = 1000 }, -- Crystal Ring
	{ id = 3051, chance = 1000 }, -- Energy Ring
	{ id = 3010, chance = 29697 }, -- Emerald Bangle
	{ id = 3062, chance = 1000 }, -- Mind Stone
	{ id = 3275, chance = 1000 }, -- Double Axe
	{ id = 3265, chance = 1000 }, -- Two Handed Sword
	{ id = 3054, chance = 1000 }, -- Silver Amulet
	{ id = 3360, chance = 11515 }, -- Golden Armor
	{ id = 3364, chance = 8642 }, -- Golden Legs
	{ id = 3055, chance = 1000 }, -- Platinum Amulet
	{ id = 3079, chance = 1000 }, -- Boots of Haste
	{ id = 3356, chance = 1000 }, -- Devil Helmet
	{ id = 7422, chance = 4429 }, -- Jade Hammer
	{ id = 3414, chance = 5064 }, -- Mastermind Shield
	{ id = 2993, chance = 1000 }, -- Teddy Bear
	{ id = 3366, chance = 15098 }, -- Magic Plate Armor
	{ id = 8074, chance = 7595 }, -- Spellbook of Mind Control
	{ id = 8075, chance = 11046 }, -- Spellbook of Lost Souls
	{ id = 8076, chance = 16075 }, -- Spellscroll of Prophecies
	{ id = 823, chance = 9697 }, -- Glacier Kilt
	{ id = 822, chance = 9524 }, -- Lightning Legs
	{ id = 812, chance = 8025 }, -- Terra Legs
	{ id = 821, chance = 9302 }, -- Magma Legs
	{ id = 7407, chance = 6059 }, -- Haunted Blade
	{ id = 7414, chance = 9613 }, -- Abyss Hammer
	{ id = 7403, chance = 4165 }, -- Berserker
	{ id = 7427, chance = 8023 }, -- Chaos Mace
	{ id = 7451, chance = 7879 }, -- Shadow Sceptre
	{ id = 7410, chance = 10200 }, -- Queen's Sceptre
	{ id = 7411, chance = 10200 }, -- Ornamented Axe
	{ id = 7388, chance = 8160 }, -- Vile Axe
	{ id = 8041, chance = 5554 }, -- Greenwood Coat
	{ id = 8057, chance = 8485 }, -- Divine Plate
	{ id = 8102, chance = 17310 }, -- Emerald Sword
	{ id = 8100, chance = 3796 }, -- Obsidian Truncheon
	{ id = 8090, chance = 6833 }, -- Spellbook of Dark Mysteries
	{ id = 7423, chance = 4346 }, -- Skullcrusher
	{ id = 3422, chance = 9259 }, -- Great Shield
	{ id = 2852, chance = 4080 }, -- Red Tome
	{ id = 3439, chance = 6329 }, -- Phoenix Shield
	{ id = 8096, chance = 10200 }, -- Hellforged Axe
	{ id = 7435, chance = 5767 }, -- Impaler
	{ id = 3442, chance = 21430 }, -- Tempest Shield
	{ id = 8040, chance = 22642 }, -- Velvet Mantle
	{ id = 7382, chance = 3163 }, -- Demonrage Sword
	{ id = 7416, chance = 3085 }, -- Bloody Edge
	{ id = 8098, chance = 5915 }, -- Demonwing Axe
	{ id = 7405, chance = 16984 }, -- Havoc Blade
	{ id = 7418, chance = 3085 }, -- Nightmare Blade
	{ id = 3420, chance = 10909 }, -- Demon Shield
	{ id = 7417, chance = 6396 }, -- Runed Sword
	{ id = 3303, chance = 4080 }, -- Great Axe
	{ id = 5903, chance = 34302 }, -- Ferumbras' Hat
	{ id = 3035, chance = 6961 }, -- Platinum Coin
	{ id = 3041, chance = 9482 }, -- Blue Gem
	{ id = 3039, chance = 11206 }, -- Red Gem
	{ id = 3038, chance = 5172 }, -- Green Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = -500, maxDamage = -700, range = 7, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -450, length = 8, spread = 0, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "combat", interval = 2000, chance = 21, type = COMBAT_LIFEDRAIN, minDamage = -450, maxDamage = -500, radius = 6, effect = CONST_ME_POFF, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 15, minDamage = -20, maxDamage = -40, range = 7, shootEffect = CONST_ANI_POISON, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -900, maxDamage = -1000, range = 4, radius = 3, effect = CONST_ME_DRAWBLOOD, target = false },
	-- energy damage
	{ name = "condition", type = CONDITION_ENERGY, interval = 2000, chance = 18, minDamage = -300, maxDamage = -400, radius = 6, effect = CONST_ME_ENERGYHIT, target = false },
	-- fire
	{ name = "condition", type = CONDITION_FIRE, interval = 3000, chance = 20, minDamage = -500, maxDamage = -600, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
}

monster.defenses = {
	defense = 120,
	armor = 100,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 900, maxDamage = 1500, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "invisible", interval = 4000, chance = 20, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 90 },
	{ type = COMBAT_EARTHDAMAGE, percent = 90 },
	{ type = COMBAT_FIREDAMAGE, percent = 90 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
