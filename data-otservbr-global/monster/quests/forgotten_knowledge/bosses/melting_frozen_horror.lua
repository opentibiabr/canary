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
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 30 }, -- Platinum Coin
	{ id = 9661, chance = 100000 }, -- Frosty Heart
	{ id = 16121, chance = 61437, maxCount = 3 }, -- Green Crystal Shard
	{ id = 16120, chance = 65359, maxCount = 3 }, -- Violet Crystal Shard
	{ id = 3033, chance = 20915, maxCount = 10 }, -- Small Amethyst
	{ id = 3028, chance = 20915, maxCount = 10 }, -- Small Diamond
	{ id = 3032, chance = 20261, maxCount = 10 }, -- Small Emerald
	{ id = 15793, chance = 19607, maxCount = 100 }, -- Crystalline Arrow
	{ id = 7643, chance = 52941, maxCount = 5 }, -- Ultimate Health Potion
	{ id = 7642, chance = 60784, maxCount = 5 }, -- Great Spirit Potion
	{ id = 3041, chance = 16993 }, -- Blue Gem
	{ id = 3038, chance = 17647 }, -- Green Gem
	{ id = 3036, chance = 3267 }, -- Violet Gem
	{ id = 3333, chance = 7189 }, -- Crystal Mace
	{ id = 7449, chance = 88235 }, -- Crystal Sword
	{ id = 16160, chance = 1000 }, -- Crystalline Sword
	{ id = 8050, chance = 3703 }, -- Crystalline Armor
	{ id = 15793, chance = 19607, maxCount = 100 }, -- Crystalline Arrow
	{ id = 8059, chance = 3030 }, -- Frozen Plate
	{ id = 7441, chance = 100000 }, -- Ice Cube
	{ id = 3284, chance = 79084 }, -- Ice Rapier
	{ id = 11652, chance = 1000 }, -- Broken Key Ring
	{ id = 7459, chance = 36601 }, -- Pair of Earmuffs
	{ id = 19363, chance = 1000 }, -- Runic Ice Shield
	{ id = 16175, chance = 1587 }, -- Shiny Blade
	{ id = 23518, chance = 99346 }, -- Spark Sphere
	{ id = 24978, chance = 1851 }, -- Coal Eyes
	{ id = 14247, chance = 15032 }, -- Ornate Crossbow
	{ id = 24977, chance = 3418 }, -- Glowing Carrot
	{ id = 24958, chance = 5128 }, -- Part of a Rune (Five)
	{ id = 22516, chance = 20261 }, -- Silver Token
	{ id = 22721, chance = 29411 }, -- Gold Token
	{ id = 238, chance = 60784 }, -- Great Mana Potion
	{ id = 3391, chance = 18300 }, -- Crusader Helmet
	{ id = 7290, chance = 11764 }, -- Shard
	{ id = 16119, chance = 71895 }, -- Blue Crystal Shard
	{ id = 3030, chance = 20915 }, -- Small Ruby
	{ id = 281, chance = 20261 }, -- Giant Shimmering Pearl
	{ id = 9057, chance = 15686 }, -- Small Topaz
	{ id = 7368, chance = 13725 }, -- Assassin Star
	{ id = 3332, chance = 2222 }, -- Hammer of Wrath
	{ id = 3039, chance = 19607 }, -- Red Gem
	{ id = 3067, chance = 12418 }, -- Hailstorm Rod
	{ id = 3037, chance = 20915 }, -- Yellow Gem
	{ id = 7383, chance = 3703 }, -- Relic Sword
	{ id = 5892, chance = 3418 }, -- Huge Chunk of Crude Iron
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
