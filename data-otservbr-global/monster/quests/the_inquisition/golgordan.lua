local mType = Game.createMonsterType("Golgordan")
local monster = {}

monster.description = "Golgordan"
monster.experience = 10000
monster.outfit = {
	lookType = 12,
	lookHead = 52,
	lookBody = 99,
	lookLegs = 52,
	lookFeet = 91,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"InquisitionBossDeath",
}

monster.bosstiary = {
	bossRaceId = 416,
	bossRace = RARITY_BANE,
}

monster.health = 40000
monster.maxHealth = 40000
monster.race = "fire"
monster.corpse = 7893
monster.speed = 195
monster.manaCost = 0

monster.changeTarget = {
	interval = 7000,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 85,
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
	{ text = "Latrivan, you fool!", yell = false },
	{ text = "We are the right hand and the left hand of the seven!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 262 }, -- Gold Coin
	{ id = 239, chance = 39000, maxCount = 2 }, -- Great Health Potion
	{ id = 3098, chance = 28000 }, -- Ring of Healing
	{ id = 3046, chance = 24000 }, -- Magic Light Wand
	{ id = 3275, chance = 23000 }, -- Double Axe
	{ id = 3033, chance = 17800, maxCount = 20 }, -- Small Amethyst
	{ id = 3063, chance = 16900 }, -- Gold Ring
	{ id = 3049, chance = 16300 }, -- Stealth Ring
	{ id = 3051, chance = 15400 }, -- Energy Ring
	{ id = 3027, chance = 15100, maxCount = 15 }, -- Black Pearl
	{ id = 3029, chance = 14800, maxCount = 10 }, -- Small Sapphire
	{ id = 3290, chance = 13900 }, -- Silver Dagger
	{ id = 3054, chance = 13600 }, -- Silver Amulet
	{ id = 3032, chance = 13400, maxCount = 10 }, -- Small Emerald
	{ id = 3320, chance = 11000 }, -- Fire Axe
	{ id = 3081, chance = 11000 }, -- Stone Skin Amulet
	{ id = 3028, chance = 10400, maxCount = 5 }, -- Small Diamond
	{ id = 3026, chance = 10400, maxCount = 15 }, -- White Pearl
	{ id = 6499, chance = 8900 }, -- Demonic Essence
	{ id = 3420, chance = 8900 }, -- Demon Shield
	{ id = 3356, chance = 8900 }, -- Devil Helmet
	{ id = 3284, chance = 7700 }, -- Ice Rapier
	{ id = 7365, chance = 7100, maxCount = 8 }, -- Onyx Arrow
	{ id = 9058, chance = 6800 }, -- Gold Ingot
	{ id = 6299, chance = 5600 }, -- Death Ring
	{ id = 3281, chance = 5600 }, -- Giant Sword
	{ id = 3324, chance = 5000 }, -- Skull Staff
	{ id = 3048, chance = 4700 }, -- Might Ring
	{ id = 3084, chance = 4200 }, -- Protection Amulet
	{ id = 3070, chance = 3300 }, -- Moonlight Rod
	{ id = 3079, chance = 3000 }, -- Boots of Haste
	{ id = 3062, chance = 3000 }, -- Mind Stone
	{ id = 3076, chance = 2400 }, -- Crystal Ball
	{ id = 3069, chance = 2100 }, -- Necrotic Rod
	{ id = 3072, chance = 1800 }, -- Wand of Decay
	{ id = 3066, chance = 1800 }, -- Snakebite Rod
	{ id = 3041, chance = 1800 }, -- Blue Gem
	{ id = 3038, chance = 890 }, -- Green Gem
	{ id = 3414, chance = 590 }, -- Mastermind Shield
	{ id = 7368, chance = 300, maxCount = 6 }, -- Assassin Star
	{ id = 3055, chance = 300 }, -- Platinum Amulet
	{ id = 3306, chance = 300 }, -- Golden Sickle
	{ id = 3364, chance = 300 }, -- Golden Legs
	{ id = 3002, chance = 300 }, -- Voodoo Doll
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -60, maxDamage = -200, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 1000, chance = 11, minDamage = -30, maxDamage = -30, length = 5, spread = 3, effect = CONST_ME_POISONAREA, target = false },
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -50, maxDamage = -600, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -600, range = 4, radius = 1, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -600, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 1000, chance = 8, type = COMBAT_PHYSICALDAMAGE, minDamage = -50, maxDamage = -60, radius = 6, effect = CONST_ME_GROUNDSHAKER, target = false },
}

monster.defenses = {
	defense = 54,
	armor = 48,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 1 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -1 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -1 },
	{ type = COMBAT_HOLYDAMAGE, percent = 1 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
