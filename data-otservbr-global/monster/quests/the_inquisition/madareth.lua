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
	{ id = 3031, chance = 100000, maxCount = 150 }, -- Gold Coin
	{ id = 3035, chance = 19700, maxCount = 30 }, -- Platinum Coin
	{ id = 5954, chance = 10610, maxCount = 2 }, -- Demon Horn
	{ id = 3028, chance = 1000, maxCount = 2 }, -- Small Diamond
	{ id = 6499, chance = 11456 }, -- Demonic Essence
	{ id = 8896, chance = 45835 }, -- Slightly Rusted Armor
	{ id = 8899, chance = 54165 }, -- Slightly Rusted Legs
	{ id = 7440, chance = 28123 }, -- Mastermind Potion
	{ id = 7439, chance = 30205 }, -- Berserk Potion
	{ id = 7443, chance = 30206 }, -- Bullseye Potion
	{ id = 3092, chance = 11958 }, -- Axe Ring
	{ id = 6299, chance = 21874 }, -- Death Ring
	{ id = 3091, chance = 6520 }, -- Sword Ring
	{ id = 3093, chance = 12500 }, -- Club Ring
	{ id = 3097, chance = 3030 }, -- Dwarven Ring
	{ id = 3052, chance = 8694 }, -- Life Ring
	{ id = 3098, chance = 19568 }, -- Ring of Healing
	{ id = 7643, chance = 21740 }, -- Ultimate Health Potion
	{ id = 238, chance = 22919 }, -- Great Mana Potion
	{ id = 239, chance = 27084 }, -- Great Health Potion
	{ id = 7642, chance = 29168 }, -- Great Spirit Potion
	{ id = 3053, chance = 10868 }, -- Time Ring
	{ id = 3071, chance = 14582 }, -- Wand of Inferno
	{ id = 8092, chance = 8699 }, -- Wand of Starstorm
	{ id = 8094, chance = 14586 }, -- Wand of Voodoo
	{ id = 8082, chance = 15712 }, -- Underworld Rod
	{ id = 3067, chance = 17393 }, -- Hailstorm Rod
	{ id = 8084, chance = 19793 }, -- Springsprout Rod
	{ id = 2949, chance = 10872 }, -- Lyre
	{ id = 3046, chance = 1000 }, -- Magic Light Wand
	{ id = 2948, chance = 12502 }, -- Wooden Flute
	{ id = 2950, chance = 15215 }, -- Lute
	{ id = 2966, chance = 9784 }, -- War Drum
	{ id = 2958, chance = 11956 }, -- War Horn
	{ id = 2965, chance = 9373 }, -- Didgeridoo
	{ id = 7416, chance = 15219 }, -- Bloody Edge
	{ id = 7449, chance = 8699 }, -- Crystal Sword
	{ id = 7386, chance = 12503 }, -- Mercenary Sword
	{ id = 7383, chance = 6520 }, -- Relic Sword
	{ id = 7404, chance = 17141 }, -- Assassin Dagger
	{ id = 7418, chance = 16665 }, -- Nightmare Blade
	{ id = 7407, chance = 12120 }, -- Haunted Blade
	{ id = 3265, chance = 14129 }, -- Two Handed Sword
	{ id = 3284, chance = 7611 }, -- Ice Rapier
	{ id = 3079, chance = 1000 }, -- Boots of Haste
	{ id = 3387, chance = 1000 }, -- Demon Helmet
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
