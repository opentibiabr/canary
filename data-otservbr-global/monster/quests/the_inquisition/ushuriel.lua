local mType = Game.createMonsterType("Ushuriel")
local monster = {}

monster.description = "Ushuriel"
monster.experience = 10000
monster.outfit = {
	lookType = 12,
	lookHead = 0,
	lookBody = 57,
	lookLegs = 0,
	lookFeet = 80,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"InquisitionBossDeath",
}

monster.health = 31500
monster.maxHealth = 31500
monster.race = "fire"
monster.corpse = 6068
monster.speed = 220
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 415,
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
	{ text = "You can't run or hide forever!", yell = false },
	{ text = "I'm the executioner of the Seven!", yell = false },
	{ text = "The final punishment awaits you!", yell = false },
	{ text = "The judgement is guilty! The sentence is death!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 96990, maxCount = 102 }, -- Gold Coin
	{ id = 3035, chance = 20720, maxCount = 30 }, -- Platinum Coin
	{ id = 3028, chance = 1000, maxCount = 3 }, -- Small Diamond
	{ id = 3029, chance = 1000, maxCount = 8 }, -- Small Sapphire
	{ id = 3027, chance = 1000, maxCount = 14 }, -- Black Pearl
	{ id = 3032, chance = 1000, maxCount = 6 }, -- Small Emerald
	{ id = 3026, chance = 1000, maxCount = 14 }, -- White Pearl
	{ id = 3033, chance = 1000, maxCount = 17 }, -- Small Amethyst
	{ id = 239, chance = 26534, maxCount = 2 }, -- Great Health Potion
	{ id = 238, chance = 20892 }, -- Great Mana Potion
	{ id = 7642, chance = 24541 }, -- Great Spirit Potion
	{ id = 7643, chance = 25205 }, -- Ultimate Health Potion
	{ id = 7365, chance = 1000, maxCount = 8 }, -- Onyx Arrow
	{ id = 3725, chance = 96990, maxCount = 30 }, -- Brown Mushroom
	{ id = 5954, chance = 11107, maxCount = 2 }, -- Demon Horn
	{ id = 7385, chance = 9013 }, -- Crimson Sword
	{ id = 5880, chance = 45939, maxCount = 10 }, -- Iron Ore
	{ id = 5925, chance = 27870, maxCount = 20 }, -- Hardened Bone
	{ id = 3060, chance = 16913 }, -- Orb
	{ id = 3069, chance = 1000 }, -- Necrotic Rod
	{ id = 3066, chance = 1000 }, -- Snakebite Rod
	{ id = 3275, chance = 1000 }, -- Double Axe
	{ id = 3307, chance = 10572 }, -- Scimitar
	{ id = 3062, chance = 21060 }, -- Mind Stone
	{ id = 3046, chance = 1000 }, -- Magic Light Wand
	{ id = 6299, chance = 1000 }, -- Death Ring
	{ id = 3051, chance = 1000 }, -- Energy Ring
	{ id = 3049, chance = 1000 }, -- Stealth Ring
	{ id = 3063, chance = 1000 }, -- Gold Ring
	{ id = 9058, chance = 20895 }, -- Gold Ingot
	{ id = 3290, chance = 1000 }, -- Silver Dagger
	{ id = 3061, chance = 19904 }, -- Life Crystal
	{ id = 3054, chance = 1000 }, -- Silver Amulet
	{ id = 3084, chance = 1000 }, -- Protection Amulet
	{ id = 3356, chance = 1000 }, -- Devil Helmet
	{ id = 3373, chance = 8623 }, -- Strange Helmet
	{ id = 3048, chance = 1000 }, -- Might Ring
	{ id = 3081, chance = 1000 }, -- Stone Skin Amulet
	{ id = 3098, chance = 1000 }, -- Ring of Healing
	{ id = 6499, chance = 100000 }, -- Demonic Essence
	{ id = 3072, chance = 1000 }, -- Wand of Decay
	{ id = 3070, chance = 1000 }, -- Moonlight Rod
	{ id = 3281, chance = 11268 }, -- Giant Sword
	{ id = 3079, chance = 1000 }, -- Boots of Haste
	{ id = 5891, chance = 5197 }, -- Enchanted Chicken Wing
	{ id = 5668, chance = 20729 }, -- Mysterious Voodoo Skull
	{ id = 3038, chance = 1000 }, -- Green Gem
	{ id = 3041, chance = 1000 }, -- Blue Gem
	{ id = 3392, chance = 23719 }, -- Royal Helmet
	{ id = 5741, chance = 21722 }, -- Skull Helmet
	{ id = 3385, chance = 8955 }, -- Crown Helmet
	{ id = 3369, chance = 20567 }, -- Warrior Helmet
	{ id = 7391, chance = 19235 }, -- Thaian Sword
	{ id = 5892, chance = 14430 }, -- Huge Chunk of Crude Iron
	{ id = 5884, chance = 4970 }, -- Spirit Container
	{ id = 5885, chance = 3817 }, -- Flask of Warrior's Sweat
	{ id = 3271, chance = 10400 }, -- Spike Sword
	{ id = 3280, chance = 20234 }, -- Fire Sword
	{ id = 8896, chance = 16980 }, -- Slightly Rusted Armor
	{ id = 7402, chance = 10447 }, -- Dragon Slayer
	{ id = 6103, chance = 4476 }, -- Unholy Book
	{ id = 7417, chance = 9454 }, -- Runed Sword
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1088 },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -500, length = 10, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 1000, chance = 8, type = COMBAT_DEATHDAMAGE, minDamage = -30, maxDamage = -760, radius = 5, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 9, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -585, length = 8, spread = 3, effect = CONST_ME_SMALLPLANTS, target = false },
	{ name = "combat", interval = 1000, chance = 8, type = COMBAT_ICEDAMAGE, minDamage = 0, maxDamage = -430, radius = 6, effect = CONST_ME_ICETORNADO, target = false },
	{ name = "drunk", interval = 3000, chance = 11, radius = 6, effect = CONST_ME_SOUND_PURPLE, target = false },
	-- energy damage
	{ name = "condition", type = CONDITION_ENERGY, interval = 2000, chance = 15, minDamage = -250, maxDamage = -250, radius = 4, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 50,
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_HEALING, minDamage = 400, maxDamage = 600, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "speed", interval = 1000, chance = 4, speedChange = 400, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 7000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
