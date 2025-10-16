local mType = Game.createMonsterType("Ghazbaran")
local monster = {}

monster.description = "Ghazbaran"
monster.experience = 15000
monster.outfit = {
	lookType = 12,
	lookHead = 0,
	lookBody = 85,
	lookLegs = 78,
	lookFeet = 94,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 312,
	bossRace = RARITY_NEMESIS,
}

monster.health = 77000
monster.maxHealth = 77000
monster.race = "undead"
monster.corpse = 6068
monster.speed = 200
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
	runHealth = 3500,
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
		{ name = "Deathslicer", chance = 20, interval = 4000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "COME AND GIVE ME SOME AMUSEMENT", yell = true },
	{ text = "IS THAT THE BEST YOU HAVE TO OFFER, TIBIANS?", yell = true },
	{ text = "I AM GHAZBARAN OF THE TRIANGLE... AND I AM HERE TO CHALLENGE YOU ALL.", yell = true },
	{ text = "FLAWLESS VICTORY!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 73 }, -- platinum coin
	{ id = 3043, chance = 80000, maxCount = 2 }, -- crystal coin
	{ id = 3033, chance = 80000, maxCount = 15 }, -- small amethyst
	{ id = 3032, chance = 80000, maxCount = 6 }, -- small emerald
	{ id = 3028, chance = 80000, maxCount = 5 }, -- small diamond
	{ id = 3029, chance = 80000, maxCount = 9 }, -- small sapphire
	{ id = 3034, chance = 80000, maxCount = 4 }, -- talon
	{ id = 3026, chance = 80000, maxCount = 15 }, -- white pearl
	{ id = 3027, chance = 80000, maxCount = 15 }, -- black pearl
	{ id = 6499, chance = 80000, maxCount = 500 }, -- demonic essence
	{ id = 5954, chance = 80000, maxCount = 2 }, -- demon horn
	{ id = 7365, chance = 80000, maxCount = 82 }, -- onyx arrow
	{ id = 7368, chance = 80000, maxCount = 47 }, -- assassin star
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 22196, chance = 80000 }, -- crystal ball
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3061, chance = 80000 }, -- life crystal
	{ id = 3060, chance = 80000 }, -- orb
	{ id = 3366, chance = 80000 }, -- magic plate armor
	{ id = 8056, chance = 80000 }, -- oceanborn leviathan armor
	{ id = 8038, chance = 80000 }, -- robe of the ice queen
	{ id = 8059, chance = 80000 }, -- frozen plate
	{ id = 8050, chance = 80000 }, -- crystalline armor
	{ id = 3414, chance = 80000 }, -- mastermind shield
	{ id = 3281, chance = 80000 }, -- giant sword
	{ id = 8076, chance = 80000 }, -- spellscroll of prophecies
	{ id = 8073, chance = 80000 }, -- spellbook of warding
	{ id = 8090, chance = 80000 }, -- spellbook of dark mysteries
	{ id = 8075, chance = 80000 }, -- spellbook of lost souls
	{ id = 8074, chance = 80000 }, -- spellbook of mind control
	{ id = 823, chance = 80000 }, -- glacier kilt
	{ id = 3420, chance = 80000 }, -- demon shield
	{ id = 3275, chance = 80000 }, -- double axe
	{ id = 3324, chance = 80000 }, -- skull staff
	{ id = 3335, chance = 80000 }, -- twin axe
	{ id = 7454, chance = 80000 }, -- glorious axe
	{ id = 7405, chance = 80000 }, -- havoc blade
	{ id = 7428, chance = 80000 }, -- bonebreaker
	{ id = 7431, chance = 80000 }, -- demonbone
	{ id = 3360, chance = 80000 }, -- golden armor
	{ id = 3364, chance = 80000 }, -- golden legs
	{ id = 3555, chance = 80000 }, -- golden boots
	{ id = 2903, chance = 80000 }, -- golden mug
	{ id = 3116, chance = 80000 }, -- big bone
	{ id = 3058, chance = 80000 }, -- strange symbol
	{ id = 3062, chance = 80000 }, -- mind stone
	{ id = 3047, chance = 80000 }, -- magic light wand
	{ id = 3054, chance = 80000 }, -- silver amulet
	{ id = 3084, chance = 80000 }, -- protection amulet
	{ id = 3055, chance = 80000 }, -- platinum amulet
	{ id = 22746, chance = 80000 }, -- ancient amulet
	{ id = 3006, chance = 80000 }, -- ring of the sky
	{ id = 3051, chance = 80000 }, -- energy ring
	{ id = 3048, chance = 80000 }, -- might ring
	{ id = 3063, chance = 80000 }, -- gold ring
	{ id = 6299, chance = 80000 }, -- death ring
	{ id = 3098, chance = 80000 }, -- ring of healing
	{ id = 3049, chance = 80000 }, -- stealth ring
	{ id = 6093, chance = 80000 }, -- crystal ring
	{ id = 7643, chance = 80000 }, -- ultimate health potion
	{ id = 7642, chance = 80000, maxCount = 2 }, -- great spirit potion
	{ id = 239, chance = 80000, maxCount = 6 }, -- great health potion
	{ id = 238, chance = 80000, maxCount = 4 }, -- great mana potion
	{ id = 236, chance = 80000 }, -- strong health potion
	{ id = 7439, chance = 80000 }, -- berserk potion
	{ id = 2993, chance = 80000 }, -- teddy bear
	{ id = 2850, chance = 80000 }, -- blue tome
	{ id = 6553, chance = 80000 }, -- ruthless axe
	{ id = 7433, chance = 80000 }, -- ravenwing
	{ id = 7455, chance = 80000 }, -- mythril axe
	{ id = 762, chance = 80000, maxCount = 46 }, -- shiver arrow
	{ id = 761, chance = 80000, maxCount = 74 }, -- flash arrow
	{ id = 7364, chance = 80000, maxCount = 85 }, -- sniper arrow
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -2191 },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -500, range = 7, radius = 6, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 3000, chance = 34, type = COMBAT_PHYSICALDAMAGE, minDamage = -120, maxDamage = -500, range = 7, radius = 1, shootEffect = CONST_ANI_WHIRLWINDSWORD, target = true },
	{ name = "combat", interval = 4000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -100, maxDamage = -800, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -480, range = 14, radius = 5, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -650, range = 7, radius = 13, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 4000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -600, radius = 14, effect = CONST_ME_LOSEENERGY, target = false },
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -750, range = 7, radius = 4, effect = CONST_ME_ENERGYAREA, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 55,
	--	mitigation = ???,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 300, maxDamage = 800, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 4000, chance = 80, speedChange = 440, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 1 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
