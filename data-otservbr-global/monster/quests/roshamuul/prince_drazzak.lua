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
	{ id = 3031, chance = 26470, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 89473, maxCount = 20 }, -- Platinum Coin
	{ id = 16120, chance = 36115, maxCount = 5 }, -- Violet Crystal Shard
	{ id = 16121, chance = 28947, maxCount = 5 }, -- Green Crystal Shard
	{ id = 16119, chance = 41181, maxCount = 5 }, -- Blue Crystal Shard
	{ id = 20062, chance = 100000, maxCount = 2 }, -- Cluster of Solace
	{ id = 20264, chance = 94736, maxCount = 3 }, -- Unrealized Dream
	{ id = 6499, chance = 92109 }, -- Demonic Essence
	{ id = 5954, chance = 26470 }, -- Demon Horn
	{ id = 238, chance = 30555, maxCount = 8 }, -- Great Mana Potion
	{ id = 7643, chance = 26320, maxCount = 8 }, -- Ultimate Health Potion
	{ id = 3038, chance = 47372 }, -- Green Gem
	{ id = 282, chance = 34380 }, -- Giant Shimmering Pearl (Brown)
	{ id = 20277, chance = 6250 }, -- Psychedelic Tapestry
	{ id = 20276, chance = 28130 }, -- Dream Warden Mask
	{ id = 20282, chance = 13162 }, -- Nightmare Hook
	{ id = 3554, chance = 16671 }, -- Steel Boots
	{ id = 7456, chance = 13893 }, -- Noble Axe
	{ id = 20279, chance = 9380 }, -- Eye Pod
	{ id = 8050, chance = 5560 }, -- Crystalline Armor
	{ id = 7417, chance = 6250 }, -- Runed Sword
	{ id = 820, chance = 17651 }, -- Lightning Boots
	{ id = 825, chance = 26315 }, -- Lightning Robe
	{ id = 5741, chance = 11115 }, -- Skull Helmet
	{ id = 7418, chance = 9380 }, -- Nightmare Blade
	{ id = 8090, chance = 1000 }, -- Spellbook of Dark Mysteries
	{ id = 7453, chance = 1000 }, -- Executioner
	{ id = 20274, chance = 1000 }, -- Nightmare Horn
	{ id = 20063, chance = 1000 }, -- Dream Matter
	{ id = 3381, chance = 1000 }, -- Crown Armor
	{ id = 8098, chance = 1000 }, -- Demonwing Axe
	{ id = 7414, chance = 3130 }, -- Abyss Hammer
	{ id = 3019, chance = 3130 }, -- Demonbone Amulet
	{ id = 281, chance = 1000 }, -- Giant Shimmering Pearl
	{ id = 16126, chance = 28947 }, -- Red Crystal Fragment
	{ id = 3098, chance = 23684 }, -- Ring of Healing
	{ id = 16127, chance = 43750 }, -- Green Crystal Fragment
	{ id = 20278, chance = 12500 }, -- Demonic Tapestry
	{ id = 16125, chance = 34210 }, -- Cyan Crystal Fragment
	{ id = 7642, chance = 30559 }, -- Great Spirit Potion
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
