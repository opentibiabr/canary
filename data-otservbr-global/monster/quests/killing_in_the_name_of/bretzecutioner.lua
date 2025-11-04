local mType = Game.createMonsterType("Bretzecutioner")
local monster = {}

monster.description = "Bretzecutioner"
monster.experience = 3700
monster.outfit = {
	lookType = 236,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 5600
monster.maxHealth = 5600
monster.race = "undead"
monster.corpse = 6319
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
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
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 99 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 8 }, -- Platinum Coin
	{ id = 281, chance = 43240 }, -- Giant Shimmering Pearl
	{ id = 3008, chance = 29730 }, -- Crystal Necklace
	{ id = 6499, chance = 62160, maxCount = 2 }, -- Demonic Essence
	{ id = 6299, chance = 100000 }, -- Death Ring
	{ id = 3383, chance = 67570 }, -- Dark Armor
	{ id = 3421, chance = 18920 }, -- Dark Shield
	{ id = 7368, chance = 100000, maxCount = 9 }, -- Assassin Star
	{ id = 10298, chance = 100000 }, -- Metal Spike
	{ id = 239, chance = 48650, maxCount = 3 }, -- Great Health Potion
	{ id = 238, chance = 21620, maxCount = 3 }, -- Great Mana Potion
	{ id = 7642, chance = 29730, maxCount = 3 }, -- Great Spirit Potion
	{ id = 3577, chance = 100000, maxCount = 6 }, -- Meat
	{ id = 3033, chance = 27030, maxCount = 5 }, -- Small Amethyst
	{ id = 3029, chance = 37840, maxCount = 5 }, -- Small Sapphire
	{ id = 3028, chance = 35140, maxCount = 5 }, -- Small Diamond
	{ id = 7452, chance = 40540 }, -- Spiked Squelcher
	{ id = 7427, chance = 18920 }, -- Chaos Mace
	{ id = 3281, chance = 16219 }, -- Giant Sword
	{ id = 7419, chance = 16219 }, -- Dreaded Cleaver
	{ id = 3554, chance = 5410 }, -- Steel Boots
	{ id = 5741, chance = 2700 }, -- Skull Helmet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -514 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -200, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	mitigation = 2.04,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 420, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
