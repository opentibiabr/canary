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
	{ id = 6499, chance = 100000 }, -- Demonic Essence
	{ id = 3031, chance = 100000, maxCount = 198 }, -- Gold Coin
	{ id = 8899, chance = 52000 }, -- Slightly Rusted Legs
	{ id = 7643, chance = 42000, maxCount = 2 }, -- Ultimate Health Potion
	{ id = 8896, chance = 32000 }, -- Slightly Rusted Armor
	{ id = 8073, chance = 31000 }, -- Spellbook of Warding
	{ id = 3344, chance = 30000 }, -- Beastslayer Axe
	{ id = 7642, chance = 21000 }, -- Great Spirit Potion
	{ id = 3035, chance = 20000, maxCount = 30 }, -- Platinum Coin
	{ id = 3381, chance = 18400 }, -- Crown Armor
	{ id = 238, chance = 18400 }, -- Great Mana Potion
	{ id = 239, chance = 18200 }, -- Great Health Potion
	{ id = 3008, chance = 14500 }, -- Crystal Necklace
	{ id = 3027, chance = 14000, maxCount = 25 }, -- Black Pearl
	{ id = 3026, chance = 13400, maxCount = 25 }, -- White Pearl
	{ id = 3030, chance = 13100, maxCount = 25 }, -- Small Ruby
	{ id = 3028, chance = 12700, maxCount = 25 }, -- Small Diamond
	{ id = 7456, chance = 12000 }, -- Noble Axe
	{ id = 3033, chance = 11800, maxCount = 25 }, -- Small Amethyst
	{ id = 3029, chance = 11700, maxCount = 25 }, -- Small Sapphire
	{ id = 3032, chance = 11700, maxCount = 25 }, -- Small Emerald
	{ id = 9057, chance = 11500, maxCount = 25 }, -- Small Topaz
	{ id = 821, chance = 10900 }, -- Magma Legs
	{ id = 8042, chance = 10400 }, -- Spirit Cloak
	{ id = 3016, chance = 10200 }, -- Ruby Necklace
	{ id = 5954, chance = 10100, maxCount = 2 }, -- Demon Horn
	{ id = 3081, chance = 10000 }, -- Stone Skin Amulet
	{ id = 3382, chance = 9900 }, -- Crown Legs
	{ id = 8074, chance = 9900 }, -- Spellbook of Mind Control
	{ id = 3013, chance = 9700 }, -- Golden Amulet
	{ id = 8043, chance = 9500 }, -- Focus Cape
	{ id = 3554, chance = 9500 }, -- Steel Boots
	{ id = 8075, chance = 8700 }, -- Spellbook of Lost Souls
	{ id = 3371, chance = 8600 }, -- Knight Legs
	{ id = 3567, chance = 8200 }, -- Blue Robe
	{ id = 7412, chance = 2200 }, -- Butcher's Axe
	{ id = 3360, chance = 2000 }, -- Golden Armor
	{ id = 7388, chance = 1100 }, -- Vile Axe
	{ id = 8076, chance = 1000 }, -- Spellscroll of Prophecies
	{ id = 7453, chance = 800 }, -- Executioner
	{ id = 3019, chance = 700 }, -- Demonbone Amulet
	{ id = 3364, chance = 600 }, -- Golden Legs
	{ id = 8051, chance = 400 }, -- Voltage Armor
	{ id = 8098, chance = 300 }, -- Demonwing Axe
	{ id = 3303, chance = 250 }, -- Great Axe
	{ id = 8090, chance = 150 }, -- Spellbook of Dark Mysteries
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
