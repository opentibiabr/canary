local mType = Game.createMonsterType("Madareth")
local monster = {}

monster.description = "Madareth"
monster.experience = 10000
monster.outfit = {
	lookType = 12,
	lookHead = 77,
	lookBody = 78,
	lookLegs = 80,
	lookFeet = 79,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"InquisitionBossDeath",
}

monster.bosstiary = {
	bossRaceId = 414,
	bossRace = RARITY_BANE,
}

monster.health = 75000
monster.maxHealth = 75000
monster.race = "fire"
monster.corpse = 7893
monster.speed = 165
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 85,
	targetDistance = 1,
	runHealth = 1200,
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
	{ text = "I am going to play with yourself!", yell = false },
	{ text = "Feel my wrath!", yell = false },
	{ text = "No one matches my battle prowess!", yell = false },
	{ text = "You will all die!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 100 }, -- Gold Coin
	{ id = 8899, chance = 51000 }, -- Slightly Rusted Legs
	{ id = 8896, chance = 49000 }, -- Slightly Rusted Armor
	{ id = 7443, chance = 29000 }, -- Bullseye Potion
	{ id = 7642, chance = 27000 }, -- Great Spirit Potion
	{ id = 7643, chance = 25000 }, -- Ultimate Health Potion
	{ id = 238, chance = 24000 }, -- Great Mana Potion
	{ id = 6299, chance = 24000 }, -- Death Ring
	{ id = 239, chance = 24000 }, -- Great Health Potion
	{ id = 7439, chance = 23000 }, -- Berserk Potion
	{ id = 7440, chance = 21000 }, -- Mastermind Potion
	{ id = 3035, chance = 20000, maxCount = 30 }, -- Platinum Coin
	{ id = 3067, chance = 17300 }, -- Hailstorm Rod
	{ id = 3265, chance = 16800 }, -- Two Handed Sword
	{ id = 3071, chance = 16800 }, -- Wand of Inferno
	{ id = 8084, chance = 15600 }, -- Springsprout Rod
	{ id = 8094, chance = 15600 }, -- Wand of Voodoo
	{ id = 49271, chance = 15000 }, -- Transcendence Potion
	{ id = 8092, chance = 12100 }, -- Wand of Starstorm
	{ id = 7418, chance = 12100 }, -- Nightmare Blade
	{ id = 2966, chance = 12100 }, -- War Drum
	{ id = 7404, chance = 12100 }, -- Assassin Dagger
	{ id = 3053, chance = 11600 }, -- Time Ring
	{ id = 8082, chance = 11600 }, -- Underworld Rod
	{ id = 7386, chance = 11600 }, -- Mercenary Sword
	{ id = 5954, chance = 11600, maxCount = 2 }, -- Demon Horn
	{ id = 6499, chance = 11600 }, -- Demonic Essence
	{ id = 2958, chance = 11000 }, -- War Horn
	{ id = 2949, chance = 11000 }, -- Lyre
	{ id = 3093, chance = 11000 }, -- Club Ring
	{ id = 2950, chance = 11000 }, -- Lute
	{ id = 7416, chance = 11000 }, -- Bloody Edge
	{ id = 3092, chance = 11000 }, -- Axe Ring
	{ id = 7407, chance = 10400 }, -- Haunted Blade
	{ id = 2965, chance = 10400 }, -- Didgeridoo
	{ id = 3098, chance = 9800 }, -- Ring of Healing
	{ id = 3052, chance = 9800 }, -- Life Ring
	{ id = 7449, chance = 9800 }, -- Crystal Sword
	{ id = 3284, chance = 9200 }, -- Ice Rapier
	{ id = 2948, chance = 8700 }, -- Wooden Flute
	{ id = 3091, chance = 8100 }, -- Sword Ring
	{ id = 7383, chance = 6900 }, -- Relic Sword
	{ id = 3097, chance = 6400 }, -- Dwarven Ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -2000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -180, maxDamage = -660, radius = 4, effect = CONST_ME_PURPLEENERGY, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -600, maxDamage = -850, length = 5, spread = 2, effect = CONST_ME_BLACKSMOKE, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -200, radius = 4, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -250, radius = 5, effect = CONST_ME_MAGIC_RED, target = true },
}

monster.defenses = {
	defense = 46,
	armor = 48,
	--	mitigation = ???,
	{ name = "combat", interval = 3000, chance = 14, type = COMBAT_HEALING, minDamage = 400, maxDamage = 900, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 99 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -1 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 1 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 95 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
