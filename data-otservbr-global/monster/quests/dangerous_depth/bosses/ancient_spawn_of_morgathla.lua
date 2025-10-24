local mType = Game.createMonsterType("Ancient Spawn of Morgathla")
local monster = {}

monster.description = "Ancient Spawn Of Morgathla"
monster.experience = 70000
monster.outfit = {
	lookType = 1055,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1551,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 900000
monster.maxHealth = 900000
monster.race = "blood"
monster.corpse = 21004
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 4,
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
	{ id = 7440, chance = 99600, maxCount = 4 }, -- Mastermind Potion
	{ id = 3035, chance = 100000, maxCount = 350 }, -- Platinum Coin
	{ id = 3098, chance = 99600 }, -- Ring of Healing
	{ id = 16119, chance = 63600, maxCount = 6 }, -- Blue Crystal Shard
	{ id = 3328, chance = 74400 }, -- Daramian Waraxe
	{ id = 16120, chance = 62800, maxCount = 6 }, -- Violet Crystal Shard
	{ id = 9632, chance = 60800, maxCount = 3 }, -- Ancient Stone
	{ id = 7642, chance = 52000, maxCount = 24 }, -- Great Spirit Potion
	{ id = 16121, chance = 63600, maxCount = 6 }, -- Green Crystal Shard
	{ id = 22193, chance = 60000, maxCount = 3 }, -- Onyx Chip
	{ id = 22516, chance = 47200 }, -- Silver Token
	{ id = 8084, chance = 63600 }, -- Springsprout Rod
	{ id = 238, chance = 55200, maxCount = 24 }, -- Great Mana Potion
	{ id = 5892, chance = 31600, maxCount = 6 }, -- Huge Chunk of Crude Iron
	{ id = 11454, chance = 22400 }, -- Luminous Orb
	{ id = 3018, chance = 13600 }, -- Scarab Amulet
	{ id = 830, chance = 7200 }, -- Terra Hood
	{ id = 7643, chance = 56800, maxCount = 24 }, -- Ultimate Health Potion
	{ id = 3037, chance = 16800, maxCount = 2 }, -- Yellow Gem
	{ id = 3041, chance = 20000, maxCount = 2 }, -- Blue Gem
	{ id = 7428, chance = 10000 }, -- Bonebreaker
	{ id = 3339, chance = 7600 }, -- Djinn Blade
	{ id = 281, chance = 12400, maxCount = 2 }, -- Giant Shimmering Pearl
	{ id = 22721, chance = 54000 }, -- Gold Token
	{ id = 3039, chance = 17600, maxCount = 2 }, -- Red Gem
	{ id = 3042, chance = 34800, maxCount = 50 }, -- Scarab Coin
	{ id = 3440, chance = 10400 }, -- Scarab Shield
	{ id = 3033, chance = 14400, maxCount = 20 }, -- Small Amethyst
	{ id = 3028, chance = 16000, maxCount = 20 }, -- Small Diamond
	{ id = 3032, chance = 17600, maxCount = 20 }, -- Small Emerald
	{ id = 3030, chance = 16000, maxCount = 20 }, -- Small Ruby
	{ id = 9057, chance = 22800, maxCount = 20 }, -- Small Topaz
	{ id = 8082, chance = 12400 }, -- Underworld Rod
	{ id = 27655, chance = 2580 }, -- Plan for a Makeshift Armour
	{ id = 27657, chance = 2800 }, -- Crude Wood Planks
	{ id = 27656, chance = 2400 }, -- Tinged Pot
	{ id = 8054, chance = 1000 }, -- Earthborn Titan Armor
	{ id = 5904, chance = 28800 }, -- Magic Sulphur
	{ id = 812, chance = 3200 }, -- Terra Legs
	{ id = 9631, chance = 99600 }, -- Scarab Pincers
	{ id = 3043, chance = 16400 }, -- Crystal Coin
	{ id = 5891, chance = 1052 }, -- Enchanted Chicken Wing
	{ id = 811, chance = 1600 }, -- Terra Mantle
	{ id = 3046, chance = 11200 }, -- Magic Light Wand
	{ id = 12304, chance = 2139 }, -- Maxilla Maximus
	{ id = 3038, chance = 15200 }, -- Green Gem
	{ id = 3036, chance = 4800 }, -- Violet Gem
	{ id = 13998, chance = 2139 }, -- Depth Scutum
	{ id = 3025, chance = 6400 }, -- Ancient Amulet
	{ id = 14042, chance = 2800 }, -- Warrior's Shield
	{ id = 21981, chance = 1052 }, -- Oriental Shoes
	{ id = 27605, chance = 1086 }, -- Candle Stump
	{ id = 7382, chance = 2173 }, -- Demonrage Sword
	{ id = 3331, chance = 1587 }, -- Ravager's Axe
	{ id = 12509, chance = 1000 }, -- Scorpion Sceptre
	{ id = 25360, chance = 1000 }, -- Heart of the Mountain (Item)
	{ id = 8053, chance = 1000 }, -- Fireborn Giant Armor
	{ id = 8062, chance = 1000 }, -- Robe of the Underworld
	{ id = 50176, chance = 1587 }, -- Depth Claws
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 90, attack = 80 },
	{ name = "combat", interval = 2000, chance = 8, type = COMBAT_LIFEDRAIN, minDamage = -135, maxDamage = -280, range = 7, radius = 5, shootEffect = CONST_ANI_WHIRLWINDAXE, effect = CONST_ME_HITAREA, target = true },
	{ name = "combat", interval = 2000, chance = 8, type = COMBAT_PHYSICALDAMAGE, minDamage = -90, maxDamage = -200, range = 7, shootEffect = CONST_ANI_WHIRLWINDAXE, effect = CONST_ME_EXPLOSIONAREA, target = true },
}

monster.defenses = {
	defense = 190,
	armor = 190,
	--	mitigation = ???,
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
