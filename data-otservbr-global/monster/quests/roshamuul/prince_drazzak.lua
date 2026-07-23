local mType = Game.createMonsterType("Prince Drazzak")
local monster = {}

monster.description = "Prince Drazzak"
monster.experience = 210000
monster.outfit = {
	lookType = 12,
	lookHead = 77,
	lookBody = 78,
	lookLegs = 94,
	lookFeet = 55,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 330000
monster.maxHealth = 330000
monster.race = "fire"
monster.corpse = 6068
monster.speed = 240
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 25,
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
	runHealth = 2000,
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
	{ text = "DIE!", yell = true },
	{ text = "All VOCATIONS must DIE!", yell = false },
	{ text = "GET OVER HERE!", yell = true },
	{ text = "CRUSH THEM ALL!", yell = true },
	{ text = "VARIPHOR WILL RULE!", yell = true },
	{ text = "They used you fools to escape and they left ME behind!!??", yell = false },
	{ text = "NOT EVEN AEONS OF IMPRISONMENT WILL STOP ME!", yell = true },
	{ text = "EVEN WITH ALL THAT TIME IN THE PRISON THAT WEAKENED ME, YOU ARE NO MATCH TO ME!", yell = true },
	{ text = "THEY WILL ALL PAY!", yell = true },
}

monster.loot = {
	{ id = 20062, chance = 100000, maxCount = 2 }, -- Cluster of Solace
	{ id = 7643, chance = 100000, maxCount = 15 }, -- Ultimate Health Potion
	{ id = 3035, chance = 100000, maxCount = 14 }, -- Platinum Coin
	{ id = 20264, chance = 100000, maxCount = 2 }, -- Unrealized Dream
	{ id = 6499, chance = 100000 }, -- Demonic Essence
	{ id = 820, chance = 50000 }, -- Lightning Boots
	{ id = 3038, chance = 50000 }, -- Green Gem
	{ id = 825, chance = 50000 }, -- Lightning Robe
	{ id = 20282, chance = 50000 }, -- Nightmare Hook
	{ id = 16121, chance = 50000, maxCount = 5 }, -- Green Crystal Shard
	{ id = 7431, chance = 50000 }, -- Demonbone
	{ id = 16126, chance = 50000, maxCount = 5 }, -- Red Crystal Fragment
	{ id = 16119, chance = 50000, maxCount = 3 }, -- Blue Crystal Shard
	{ id = 3031, chance = 50000, maxCount = 120 }, -- Gold Coin
	{ id = 16125, chance = 50000, maxCount = 4 }, -- Cyan Crystal Fragment
	{ id = 5954, chance = 50000 }, -- Demon Horn
	{ id = 3098, chance = 50000 }, -- Ring of Healing
	{ id = 16120, chance = 34380, maxCount = 5 }, -- Violet Crystal Shard
	{ id = 238, chance = 31250, maxCount = 8 }, -- Great Mana Potion
	{ id = 282, chance = 34380 }, -- Giant Shimmering Pearl (Brown)
	{ id = 20277, chance = 6250 }, -- Psychedelic Tapestry
	{ id = 20276, chance = 28130 }, -- Dream Warden Mask
	{ id = 3554, chance = 15630 }, -- Steel Boots
	{ id = 7456, chance = 9380 }, -- Noble Axe
	{ id = 20279, chance = 9380 }, -- Eye Pod
	{ id = 8050, chance = 3130 }, -- Crystalline Armor
	{ id = 7417, chance = 6250 }, -- Runed Sword
	{ id = 5741, chance = 9380 }, -- Skull Helmet
	{ id = 7418, chance = 9380 }, -- Nightmare Blade
	{ id = 7414, chance = 3130 }, -- Abyss Hammer
	{ id = 3019, chance = 3130 }, -- Demonbone Amulet
	{ id = 16127, chance = 43750 }, -- Green Crystal Fragment
	{ id = 20278, chance = 12500 }, -- Demonic Tapestry
	{ id = 7642, chance = 28130 }, -- Great Spirit Potion
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 190, attack = 100 },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_DEATHDAMAGE, minDamage = -1000, maxDamage = -3000, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 55,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 1500, maxDamage = 3000, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 35 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 35 },
	{ type = COMBAT_EARTHDAMAGE, percent = 35 },
	{ type = COMBAT_FIREDAMAGE, percent = 35 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 35 },
	{ type = COMBAT_HOLYDAMAGE, percent = 35 },
	{ type = COMBAT_DEATHDAMAGE, percent = 35 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
