local mType = Game.createMonsterType("Latrivan")
local monster = {}

monster.description = "Latrivan"
monster.experience = 10000
monster.outfit = {
	lookType = 12,
	lookHead = 118,
	lookBody = 33,
	lookLegs = 118,
	lookFeet = 91,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"InquisitionBossDeath",
}

monster.health = 25000
monster.maxHealth = 25000
monster.race = "fire"
monster.corpse = 7893
monster.speed = 195
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 417,
	bossRace = RARITY_BANE,
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
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I might reward you for killing my brother ~ with a swift death!", yell = true },
	{ text = "Colateral damage is so fun!", yell = false },
	{ text = "Golgordan you fool!", yell = false },
	{ text = "We are the brothers of fear!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 273 }, -- Gold Coin
	{ id = 239, chance = 38000, maxCount = 2 }, -- Great Health Potion
	{ id = 3098, chance = 24000 }, -- Ring of Healing
	{ id = 3275, chance = 21000 }, -- Double Axe
	{ id = 3046, chance = 20000 }, -- Magic Light Wand
	{ id = 3049, chance = 19700 }, -- Stealth Ring
	{ id = 3027, chance = 16800, maxCount = 15 }, -- Black Pearl
	{ id = 3290, chance = 15000 }, -- Silver Dagger
	{ id = 3033, chance = 14400, maxCount = 19 }, -- Small Amethyst
	{ id = 3026, chance = 13800, maxCount = 15 }, -- White Pearl
	{ id = 3054, chance = 13500 }, -- Silver Amulet
	{ id = 3029, chance = 12600, maxCount = 10 }, -- Small Sapphire
	{ id = 3032, chance = 12600, maxCount = 10 }, -- Small Emerald
	{ id = 3320, chance = 12100 }, -- Fire Axe
	{ id = 3051, chance = 11800 }, -- Energy Ring
	{ id = 3081, chance = 11200 }, -- Stone Skin Amulet
	{ id = 6299, chance = 10900 }, -- Death Ring
	{ id = 6499, chance = 10600 }, -- Demonic Essence
	{ id = 3420, chance = 10000 }, -- Demon Shield
	{ id = 9058, chance = 10000 }, -- Gold Ingot
	{ id = 3281, chance = 8500 }, -- Giant Sword
	{ id = 3063, chance = 8200 }, -- Gold Ring
	{ id = 3028, chance = 7900, maxCount = 5 }, -- Small Diamond
	{ id = 3356, chance = 7600 }, -- Devil Helmet
	{ id = 3284, chance = 7400 }, -- Ice Rapier
	{ id = 3048, chance = 6500 }, -- Might Ring
	{ id = 3084, chance = 5000 }, -- Protection Amulet
	{ id = 3324, chance = 4700 }, -- Skull Staff
	{ id = 7365, chance = 4100, maxCount = 8 }, -- Onyx Arrow
	{ id = 3062, chance = 4100 }, -- Mind Stone
	{ id = 3066, chance = 3800 }, -- Snakebite Rod
	{ id = 3076, chance = 3200 }, -- Crystal Ball
	{ id = 3079, chance = 2900 }, -- Boots of Haste
	{ id = 3070, chance = 2400 }, -- Moonlight Rod
	{ id = 3072, chance = 2100 }, -- Wand of Decay
	{ id = 3069, chance = 2100 }, -- Necrotic Rod
	{ id = 3038, chance = 1800 }, -- Green Gem
	{ id = 3041, chance = 1800 }, -- Blue Gem
	{ id = 3306, chance = 880 }, -- Golden Sickle
	{ id = 3414, chance = 590 }, -- Mastermind Shield
	{ id = 3364, chance = 590 }, -- Golden Legs
	{ id = 7368, chance = 290 }, -- Assassin Star
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -850, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -50, maxDamage = -250, length = 7, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -600, range = 4, radius = 1, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -60, maxDamage = -200, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 35,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 1 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -1 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
