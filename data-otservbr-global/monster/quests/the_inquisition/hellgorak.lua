local mType = Game.createMonsterType("Hellgorak")
local monster = {}

monster.description = "Hellgorak"
monster.experience = 10000
monster.outfit = {
	lookType = 12,
	lookHead = 19,
	lookBody = 77,
	lookLegs = 3,
	lookFeet = 80,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"InquisitionBossDeath",
}

monster.bosstiary = {
	bossRaceId = 403,
	bossRace = RARITY_BANE,
}

monster.health = 25850
monster.maxHealth = 25850
monster.race = "blood"
monster.corpse = 6068
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
	{ text = "I'll sacrifice yours souls to seven!", yell = false },
	{ text = "I'm bad news for you mortals!", yell = false },
	{ text = "No man can defeat me!", yell = false },
	{ text = "Your puny skills are no match for me.", yell = false },
	{ text = "I smell your fear.", yell = false },
	{ text = "Delicious!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 283 }, -- Gold Coin
	{ id = 3035, chance = 20490, maxCount = 29 }, -- Platinum Coin
	{ id = 6499, chance = 100000 }, -- Demonic Essence
	{ id = 3030, chance = 13150, maxCount = 25 }, -- Small Ruby
	{ id = 3033, chance = 11990, maxCount = 22 }, -- Small Amethyst
	{ id = 3028, chance = 12830, maxCount = 21 }, -- Small Diamond
	{ id = 3032, chance = 15832, maxCount = 25 }, -- Small Emerald
	{ id = 3029, chance = 11560, maxCount = 21 }, -- Small Sapphire
	{ id = 9057, chance = 11250, maxCount = 25 }, -- Small Topaz
	{ id = 3027, chance = 14200, maxCount = 22 }, -- Black Pearl
	{ id = 3026, chance = 13250, maxCount = 25 }, -- White Pearl
	{ id = 7642, chance = 21136 }, -- Great Spirit Potion
	{ id = 239, chance = 17454 }, -- Great Health Potion
	{ id = 238, chance = 18067 }, -- Great Mana Potion
	{ id = 7643, chance = 45986, maxCount = 2 }, -- Ultimate Health Potion
	{ id = 5954, chance = 10721, maxCount = 2 }, -- Demon Horn
	{ id = 3008, chance = 14478 }, -- Crystal Necklace
	{ id = 3081, chance = 10655 }, -- Stone Skin Amulet
	{ id = 3013, chance = 9981 }, -- Golden Amulet
	{ id = 3016, chance = 10249 }, -- Ruby Necklace
	{ id = 8896, chance = 32208 }, -- Slightly Rusted Armor
	{ id = 8899, chance = 51542 }, -- Slightly Rusted Legs
	{ id = 3344, chance = 30263 }, -- Beastslayer Axe
	{ id = 7456, chance = 12099 }, -- Noble Axe
	{ id = 7412, chance = 2243 }, -- Butcher's Axe
	{ id = 8042, chance = 10336 }, -- Spirit Cloak
	{ id = 8043, chance = 9981 }, -- Focus Cape
	{ id = 3567, chance = 8098 }, -- Blue Robe
	{ id = 3381, chance = 18108 }, -- Crown Armor
	{ id = 3371, chance = 8508 }, -- Knight Legs
	{ id = 3382, chance = 9370 }, -- Crown Legs
	{ id = 821, chance = 11571 }, -- Magma Legs
	{ id = 3554, chance = 9687 }, -- Steel Boots
	{ id = 3079, chance = 1000 }, -- Boots of Haste
	{ id = 8073, chance = 30727 }, -- Spellbook of Warding
	{ id = 8074, chance = 9380 }, -- Spellbook of Mind Control
	{ id = 3360, chance = 2097 }, -- Golden Armor
	{ id = 3364, chance = 684 }, -- Golden Legs
	{ id = 8075, chance = 8452 }, -- Spellbook of Lost Souls
	{ id = 7388, chance = 1353 }, -- Vile Axe
	{ id = 3019, chance = 580 }, -- Demonbone Amulet
	{ id = 7453, chance = 831 }, -- Executioner
	{ id = 8076, chance = 1123 }, -- Spellscroll of Prophecies
	{ id = 8051, chance = 455 }, -- Voltage Armor
	{ id = 8098, chance = 475 }, -- Demonwing Axe
	{ id = 3303, chance = 260 }, -- Great Axe
	{ id = 8090, chance = 160 }, -- Spellbook of Dark Mysteries
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -910 },
	{ name = "combat", interval = 1000, chance = 11, type = COMBAT_ENERGYDAMAGE, minDamage = -250, maxDamage = -819, length = 8, spread = 3, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_MANADRAIN, minDamage = -90, maxDamage = -500, radius = 5, effect = CONST_ME_STUN, target = false },
	{ name = "combat", interval = 1000, chance = 11, type = COMBAT_FIREDAMAGE, minDamage = -50, maxDamage = -520, radius = 5, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -150, radius = 7, effect = CONST_ME_POFF, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 70,
	--	mitigation = ???,
	{ name = "combat", interval = 1000, chance = 11, type = COMBAT_HEALING, minDamage = 400, maxDamage = 900, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 98 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 98 },
	{ type = COMBAT_EARTHDAMAGE, percent = 98 },
	{ type = COMBAT_FIREDAMAGE, percent = 98 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = -205 },
	{ type = COMBAT_ICEDAMAGE, percent = 98 },
	{ type = COMBAT_HOLYDAMAGE, percent = 95 },
	{ type = COMBAT_DEATHDAMAGE, percent = 98 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
