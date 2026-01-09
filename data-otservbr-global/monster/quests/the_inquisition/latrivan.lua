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
	{ id = 3031, chance = 100000, maxCount = 150 }, -- Gold Coin
	{ id = 3035, chance = 1000, maxCount = 6 }, -- Platinum Coin
	{ id = 3034, chance = 1000, maxCount = 13 }, -- Talon
	{ id = 3033, chance = 15879, maxCount = 15 }, -- Small Amethyst
	{ id = 3032, chance = 11590, maxCount = 4 }, -- Small Emerald
	{ id = 3029, chance = 14160, maxCount = 9 }, -- Small Sapphire
	{ id = 3028, chance = 8150, maxCount = 4 }, -- Small Diamond
	{ id = 3027, chance = 18146, maxCount = 28 }, -- Black Pearl
	{ id = 3026, chance = 15450, maxCount = 13 }, -- White Pearl
	{ id = 7365, chance = 4290, maxCount = 7 }, -- Onyx Arrow
	{ id = 6499, chance = 11344 }, -- Demonic Essence
	{ id = 9058, chance = 9870 }, -- Gold Ingot
	{ id = 3084, chance = 4290 }, -- Protection Amulet
	{ id = 3054, chance = 14954 }, -- Silver Amulet
	{ id = 3055, chance = 1000 }, -- Platinum Amulet
	{ id = 3081, chance = 13084 }, -- Stone Skin Amulet
	{ id = 3063, chance = 7300 }, -- Gold Ring
	{ id = 3049, chance = 19828 }, -- Stealth Ring
	{ id = 3051, chance = 9870 }, -- Energy Ring
	{ id = 3048, chance = 5150 }, -- Might Ring
	{ id = 6299, chance = 13860 }, -- Death Ring
	{ id = 3046, chance = 19406 }, -- Magic Light Wand
	{ id = 3072, chance = 2150 }, -- Wand of Decay
	{ id = 3069, chance = 1290 }, -- Necrotic Rod
	{ id = 3066, chance = 4216 }, -- Snakebite Rod
	{ id = 3098, chance = 26582 }, -- Ring of Healing
	{ id = 3041, chance = 1290 }, -- Blue Gem
	{ id = 3038, chance = 2150 }, -- Green Gem
	{ id = 3284, chance = 7730 }, -- Ice Rapier
	{ id = 7440, chance = 1000 }, -- Mastermind Potion
	{ id = 3356, chance = 6752 }, -- Devil Helmet
	{ id = 3320, chance = 10730 }, -- Fire Axe
	{ id = 3275, chance = 20250 }, -- Double Axe
	{ id = 239, chance = 36553 }, -- Great Health Potion
	{ id = 3290, chance = 14765 }, -- Silver Dagger
	{ id = 3324, chance = 3430 }, -- Skull Staff
	{ id = 3079, chance = 2580 }, -- Boots of Haste
	{ id = 3364, chance = 860 }, -- Golden Legs
	{ id = 3420, chance = 11393 }, -- Demon Shield
	{ id = 3281, chance = 8021 }, -- Giant Sword
	{ id = 3414, chance = 860 }, -- Mastermind Shield
	{ id = 3306, chance = 860 }, -- Golden Sickle
	{ id = 3076, chance = 3430 }, -- Crystal Ball
	{ id = 7368, chance = 430 }, -- Assassin Star
	{ id = 3062, chance = 3860 }, -- Mind Stone
	{ id = 3070, chance = 2580 }, -- Moonlight Rod
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
