local mType = Game.createMonsterType("Melting Frozen Horror")
local monster = {}

monster.description = "a melting frozen horror"
monster.experience = 65000
monster.outfit = {
	lookType = 261,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"ForgottenKnowledgeBossDeath",
	"MeltingDeath",
}

monster.health = 70000
monster.maxHealth = 70000
monster.race = "undead"
monster.corpse = 7282
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5,
}

monster.bosstiary = {
	bossRaceId = 1336,
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
	canPushCreatures = false,
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
	{ text = "Chrrrrrk! Chrrrk!", yell = false },
}

monster.loot = {
	{ id = 9661, chance = 100000 }, -- Frosty Heart
	{ id = 7441, chance = 100000 }, -- Ice Cube
	{ id = 3031, chance = 100000, maxCount = 395 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 44 }, -- Platinum Coin
	{ id = 23518, chance = 99000 }, -- Spark Sphere
	{ id = 7449, chance = 87000 }, -- Crystal Sword
	{ id = 3284, chance = 78000 }, -- Ice Rapier
	{ id = 16120, chance = 67000, maxCount = 5 }, -- Violet Crystal Shard
	{ id = 16119, chance = 67000, maxCount = 5 }, -- Blue Crystal Shard
	{ id = 16121, chance = 62000, maxCount = 5 }, -- Green Crystal Shard
	{ id = 238, chance = 62000, maxCount = 15 }, -- Great Mana Potion
	{ id = 7642, chance = 61000, maxCount = 13 }, -- Great Spirit Potion
	{ id = 7643, chance = 55000, maxCount = 16 }, -- Ultimate Health Potion
	{ id = 7459, chance = 41000 }, -- Pair of Earmuffs
	{ id = 3028, chance = 24000, maxCount = 19 }, -- Small Diamond
	{ id = 22721, chance = 24000 }, -- Gold Token
	{ id = 15793, chance = 21000, maxCount = 198 }, -- Crystalline Arrow
	{ id = 3037, chance = 21000 }, -- Yellow Gem
	{ id = 3030, chance = 19700, maxCount = 19 }, -- Small Ruby
	{ id = 3033, chance = 19700, maxCount = 19 }, -- Small Amethyst
	{ id = 3039, chance = 19700 }, -- Red Gem
	{ id = 22516, chance = 17100 }, -- Silver Token
	{ id = 3038, chance = 17100 }, -- Green Gem
	{ id = 281, chance = 17100 }, -- Giant Shimmering Pearl
	{ id = 3032, chance = 15800, maxCount = 17 }, -- Small Emerald
	{ id = 14247, chance = 15800 }, -- Ornate Crossbow
	{ id = 3391, chance = 15800 }, -- Crusader Helmet
	{ id = 9057, chance = 15800, maxCount = 19 }, -- Small Topaz
	{ id = 3041, chance = 14500 }, -- Blue Gem
	{ id = 3067, chance = 13200 }, -- Hailstorm Rod
	{ id = 7368, chance = 9200, maxCount = 80 }, -- Assassin Star
	{ id = 7290, chance = 7900, maxCount = 5 }, -- Shard
	{ id = 3333, chance = 5300 }, -- Crystal Mace
	{ id = 3036, chance = 5300 }, -- Violet Gem
	{ id = 24977, chance = 3900 }, -- Glowing Carrot
	{ id = 24978, chance = 2600 }, -- Coal Eyes
	{ id = 24958, chance = 3700 }, -- Part of a Rune (Five)
	{ id = 5892, chance = 2600 }, -- Huge Chunk of Crude Iron
	{ id = 8059, chance = 2600 }, -- Frozen Plate
	{ id = 16175, chance = 1300 }, -- Shiny Blade
	{ id = 24954, chance = 3700 }, -- Part of a Rune (One)
	{ id = 24955, chance = 3700 }, -- Part of a Rune (Two)
	{ id = 24956, chance = 3700 }, -- Part of a Rune (Three)
	{ id = 24957, chance = 3700 }, -- Part of a Rune (Four)
	{ id = 24959, chance = 3700 }, -- Part of a Rune (Six)
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -70, maxDamage = -300 },
	{ name = "hirintror freeze", interval = 2000, chance = 15, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -750, maxDamage = -1050, range = 7, radius = 3, shootEffect = CONST_ANI_ICE, effect = CONST_ME_BLOCKHIT, target = true },
	{ name = "ice golem paralyze", interval = 2000, chance = 11, target = false },
	{ name = "hirintror skill reducer", interval = 2000, chance = 10, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 60,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, radius = 7, effect = CONST_ME_BLOCKHIT, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 1 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -1 },
}

monster.heals = {
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
