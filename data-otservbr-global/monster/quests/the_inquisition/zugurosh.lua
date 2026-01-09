local mType = Game.createMonsterType("Zugurosh")
local monster = {}

monster.description = "Zugurosh"
monster.experience = 10000
monster.outfit = {
	lookType = 12,
	lookHead = 3,
	lookBody = 18,
	lookLegs = 19,
	lookFeet = 91,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"InquisitionBossDeath",
}

monster.bosstiary = {
	bossRaceId = 434,
	bossRace = RARITY_BANE,
}

monster.health = 90500
monster.maxHealth = 90500
monster.race = "fire"
monster.corpse = 7893
monster.speed = 165
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 15,
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
	runHealth = 4500,
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
	{ text = "You will run out of resources soon enough!", yell = false },
	{ text = "One little mistake and you're all are mine!", yell = false },
	{ text = "I sense your strength fading!", yell = false },
	{ text = "I know you will show a weakness!", yell = false },
	{ text = "Your fear will make you prone to mistakes!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 182 }, -- Gold Coin
	{ id = 3035, chance = 22836, maxCount = 28 }, -- Platinum Coin
	{ id = 3034, chance = 20655, maxCount = 30 }, -- Talon
	{ id = 5944, chance = 23097, maxCount = 10 }, -- Soul Orb
	{ id = 5914, chance = 16071, maxCount = 9 }, -- Yellow Piece of Cloth
	{ id = 5913, chance = 14386, maxCount = 9 }, -- Brown Piece of Cloth
	{ id = 8896, chance = 48149 }, -- Slightly Rusted Armor
	{ id = 5909, chance = 14820, maxCount = 10 }, -- White Piece of Cloth
	{ id = 5912, chance = 15830, maxCount = 10 }, -- Blue Piece of Cloth
	{ id = 5910, chance = 15491, maxCount = 10 }, -- Green Piece of Cloth
	{ id = 5911, chance = 17276, maxCount = 10 }, -- Red Piece of Cloth
	{ id = 8899, chance = 51850 }, -- Slightly Rusted Legs
	{ id = 9058, chance = 20464 }, -- Gold Ingot
	{ id = 7642, chance = 25592 }, -- Great Spirit Potion
	{ id = 3017, chance = 20226 }, -- Silver Brooch
	{ id = 7643, chance = 24004 }, -- Ultimate Health Potion
	{ id = 3027, chance = 1000, maxCount = 11 }, -- Black Pearl
	{ id = 3029, chance = 1000, maxCount = 7 }, -- Small Sapphire
	{ id = 7365, chance = 1000, maxCount = 8 }, -- Onyx Arrow
	{ id = 3079, chance = 8850 }, -- Boots of Haste
	{ id = 3554, chance = 4980 }, -- Steel Boots
	{ id = 3081, chance = 1000 }, -- Stone Skin Amulet
	{ id = 3057, chance = 4912 }, -- Amulet of Loss
	{ id = 238, chance = 25099 }, -- Great Mana Potion
	{ id = 239, chance = 26087, maxCount = 2 }, -- Great Health Potion
	{ id = 6104, chance = 20835 }, -- Jewel Case
	{ id = 5954, chance = 9476 }, -- Demon Horn
	{ id = 3555, chance = 1290 }, -- Golden Boots
	{ id = 6499, chance = 100000 }, -- Demonic Essence
	{ id = 3041, chance = 1000 }, -- Blue Gem
	{ id = 3076, chance = 1000 }, -- Crystal Ball
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -800 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -500, range = 4, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -500, length = 7, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -100, radius = 4, effect = CONST_ME_SMALLCLOUDS, target = false },
	-- fire
	{ name = "condition", type = CONDITION_FIRE, interval = 3000, chance = 20, minDamage = -10, maxDamage = -10, radius = 4, effect = CONST_ME_EXPLOSIONHIT, target = true },
	{ name = "combat", interval = 1000, chance = 13, type = COMBAT_MANADRAIN, minDamage = -60, maxDamage = -200, radius = 5, effect = CONST_ME_WATERSPLASH, target = false },
}

monster.defenses = {
	defense = 55,
	armor = 45,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_HEALING, minDamage = 40, maxDamage = 60, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_HEALING, minDamage = 400, maxDamage = 600, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "invisible", interval = 1000, chance = 5, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
