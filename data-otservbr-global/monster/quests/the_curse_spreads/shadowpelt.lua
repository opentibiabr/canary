local mType = Game.createMonsterType("Shadowpelt")
local monster = {}

monster.description = "Shadowpelt"
monster.experience = 4600
monster.outfit = {
	lookType = 1040,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 6000
monster.maxHealth = 6000
monster.race = "blood"
monster.corpse = 27722
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 11,
}

monster.bosstiary = {
	bossRaceId = 1561,
	bossRace = RARITY_ARCHFOE,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 300,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "Werebear", chance = 20, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3031, chance = 79548, maxCount = 82 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 3 }, -- Platinum Coin
	{ id = 22057, chance = 100000 }, -- Werebear Fur
	{ id = 22056, chance = 100000 }, -- Werebear Skull
	{ id = 22194, chance = 45384, maxCount = 2 }, -- Opal
	{ id = 24961, chance = 43771, maxCount = 2 }, -- Tiger Eye
	{ id = 7432, chance = 30873 }, -- Furry Club
	{ id = 3582, chance = 12614 }, -- Ham
	{ id = 282, chance = 7308 }, -- Giant Shimmering Pearl (Brown)
	{ id = 7419, chance = 7709 }, -- Dreaded Cleaver
	{ id = 5902, chance = 15501 }, -- Honeycomb
	{ id = 3098, chance = 3290 }, -- Ring of Healing
	{ id = 7452, chance = 4257 }, -- Spiked Squelcher
	{ id = 7643, chance = 12610 }, -- Ultimate Health Potion
	{ id = 22083, chance = 2570 }, -- Moonlight Crystals
	{ id = 22060, chance = 3854 }, -- Werewolf Amulet
	{ id = 239, chance = 35364 }, -- Great Health Potion
	{ id = 3027, chance = 54687, maxCount = 2 }, -- Black Pearl
	{ id = 5896, chance = 100000 }, -- Bear Paw
	{ id = 22085, chance = 6184 }, -- Fur Armor
	{ id = 3081, chance = 561 }, -- Stone Skin Amulet
	{ id = 22103, chance = 4498 }, -- Werebear Trophy
	{ id = 22084, chance = 160 }, -- Wolf Backpack
	{ id = 675, chance = 32958 }, -- Small Enchanted Sapphire
	{ id = 22516, chance = 1930 }, -- Silver Token
	{ id = 7383, chance = 1927 }, -- Relic Sword
	{ id = 7439, chance = 2408 }, -- Berserk Potion
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 50, attack = 50 },
	{ name = "combat", interval = 100, chance = 22, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -310, radius = 3, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "outfit", interval = 1000, chance = 1, radius = 1, target = true, duration = 2000, outfitMonster = "Werebear" },
	{ name = "combat", interval = 100, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -200, radius = 3, effect = CONST_ME_SOUND_WHITE, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 7, type = COMBAT_HEALING, minDamage = 120, maxDamage = 310, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 10, speedChange = 520, effect = CONST_ME_POFF, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
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
