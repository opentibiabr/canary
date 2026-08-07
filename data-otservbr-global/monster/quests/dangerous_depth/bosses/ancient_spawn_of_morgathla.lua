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
	{ id = 7440, chance = 100000, maxCount = 7 }, -- Mastermind Potion
	{ id = 9631, chance = 100000 }, -- Scarab Pincers
	{ id = 3098, chance = 100000 }, -- Ring of Healing
	{ id = 3035, chance = 100000, maxCount = 444 }, -- Platinum Coin
	{ id = 3328, chance = 71000 }, -- Daramian Waraxe
	{ id = 22193, chance = 66000, maxCount = 5 }, -- Onyx Chip
	{ id = 16120, chance = 61000, maxCount = 10 }, -- Violet Crystal Shard
	{ id = 238, chance = 59000, maxCount = 40 }, -- Great Mana Potion
	{ id = 22516, chance = 57000 }, -- Silver Token
	{ id = 16119, chance = 57000, maxCount = 11 }, -- Blue Crystal Shard
	{ id = 8084, chance = 55000 }, -- Springsprout Rod
	{ id = 7643, chance = 55000, maxCount = 34 }, -- Ultimate Health Potion
	{ id = 16121, chance = 51000, maxCount = 11 }, -- Green Crystal Shard
	{ id = 9632, chance = 49000, maxCount = 5 }, -- Ancient Stone
	{ id = 7642, chance = 49000, maxCount = 22 }, -- Great Spirit Potion
	{ id = 22721, chance = 46000 }, -- Gold Token
	{ id = 3042, chance = 36000, maxCount = 88 }, -- Scarab Coin
	{ id = 5892, chance = 30000, maxCount = 11 }, -- Huge Chunk of Crude Iron
	{ id = 5904, chance = 22000, maxCount = 11 }, -- Magic Sulphur
	{ id = 3043, chance = 21000, maxCount = 2 }, -- Crystal Coin
	{ id = 3039, chance = 21000, maxCount = 3 }, -- Red Gem
	{ id = 3440, chance = 19700 }, -- Scarab Shield
	{ id = 3030, chance = 18400, maxCount = 35 }, -- Small Ruby
	{ id = 9057, chance = 18400, maxCount = 38 }, -- Small Topaz
	{ id = 11454, chance = 17100 }, -- Luminous Orb
	{ id = 3041, chance = 15800, maxCount = 3 }, -- Blue Gem
	{ id = 3028, chance = 15800, maxCount = 39 }, -- Small Diamond
	{ id = 3032, chance = 14500, maxCount = 38 }, -- Small Emerald
	{ id = 3038, chance = 11800, maxCount = 3 }, -- Green Gem
	{ id = 8082, chance = 10500 }, -- Underworld Rod
	{ id = 3033, chance = 10500, maxCount = 39 }, -- Small Amethyst
	{ id = 281, chance = 10500, maxCount = 3 }, -- Giant Shimmering Pearl
	{ id = 3037, chance = 10500, maxCount = 3 }, -- Yellow Gem
	{ id = 3046, chance = 10500 }, -- Magic Light Wand
	{ id = 3018, chance = 9200 }, -- Scarab Amulet
	{ id = 830, chance = 9200 }, -- Terra Hood
	{ id = 3025, chance = 7900 }, -- Ancient Amulet
	{ id = 7428, chance = 7900 }, -- Bonebreaker
	{ id = 3036, chance = 7900, maxCount = 3 }, -- Violet Gem
	{ id = 3339, chance = 6600 }, -- Djinn Blade
	{ id = 27655, chance = 3900 }, -- Plan for a Makeshift Armour
	{ id = 50176, chance = 3900 }, -- Depth Claws
	{ id = 27657, chance = 3900 }, -- Crude Wood Planks
	{ id = 14042, chance = 2600 }, -- Warrior's Shield
	{ id = 27656, chance = 2600 }, -- Tinged Pot
	{ id = 812, chance = 2600 }, -- Terra Legs
	{ id = 3331, chance = 1300 }, -- Ravager's Axe
	{ id = 811, chance = 1300 }, -- Terra Mantle
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
