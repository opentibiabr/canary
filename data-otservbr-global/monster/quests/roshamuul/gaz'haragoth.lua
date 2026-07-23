local mType = Game.createMonsterType("Gaz'Haragoth")
local monster = {}

monster.description = "Gaz'Haragoth"
monster.experience = 1000000
monster.outfit = {
	lookType = 591,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 350000
monster.maxHealth = 350000
monster.race = "undead"
monster.corpse = 20228
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 20,
}

monster.bosstiary = {
	bossRaceId = 1003,
	bossRace = RARITY_NEMESIS,
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
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.events = {
	"GazHaragothHeal",
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "NO ONE WILL ESCAPE ME!", yell = true },
	{ text = "I'LL KEEP THE ORDER UP!", yell = true },
	{ text = "I've beaten tougher demons then you even know!", yell = true },
	{ text = "You puny humans will be my snacks!", yell = true },
}

monster.loot = {
	{ id = 20062, chance = 100000, maxCount = 18 }, -- Cluster of Solace
	{ id = 10344, chance = 100000 }, -- Twin Sun Charm
	{ id = 10342, chance = 100000 }, -- Unity Charm
	{ id = 10345, chance = 100000 }, -- Solitude Charm
	{ id = 10343, chance = 100000 }, -- Spiritual Charm
	{ id = 3043, chance = 100000, maxCount = 10 }, -- Crystal Coin
	{ id = 10341, chance = 100000 }, -- Phoenix Charm
	{ id = 20063, chance = 100000 }, -- Dream Matter
	{ id = 6499, chance = 76000 }, -- Demonic Essence
	{ id = 20264, chance = 76000, maxCount = 3 }, -- Unrealized Dream
	{ id = 5914, chance = 39000 }, -- Yellow Piece of Cloth
	{ id = 5911, chance = 39000 }, -- Red Piece of Cloth
	{ id = 7643, chance = 37000, maxCount = 193 }, -- Ultimate Health Potion
	{ id = 16123, chance = 34000, maxCount = 29 }, -- Brown Crystal Splinter
	{ id = 7642, chance = 32000, maxCount = 186 }, -- Great Spirit Potion
	{ id = 238, chance = 32000, maxCount = 186 }, -- Great Mana Potion
	{ id = 6528, chance = 24000, maxCount = 194 }, -- Infernal Bolt
	{ id = 16122, chance = 24000, maxCount = 27 }, -- Green Crystal Splinter
	{ id = 3041, chance = 24000 }, -- Blue Gem
	{ id = 3052, chance = 24000 }, -- Life Ring
	{ id = 5954, chance = 17100 }, -- Demon Horn
	{ id = 16120, chance = 17100, maxCount = 26 }, -- Violet Crystal Shard
	{ id = 16124, chance = 17100, maxCount = 27 }, -- Blue Crystal Splinter
	{ id = 7368, chance = 14600, maxCount = 189 }, -- Assassin Star
	{ id = 281, chance = 14600 }, -- Giant Shimmering Pearl
	{ id = 16119, chance = 12200, maxCount = 22 }, -- Blue Crystal Shard
	{ id = 20070, chance = 9800 }, -- Crude Umbral Axe
	{ id = 16121, chance = 9800, maxCount = 20 }, -- Green Crystal Shard
	{ id = 20064, chance = 7300 }, -- Crude Umbral Blade
	{ id = 826, chance = 7300 }, -- Magma Coat
	{ id = 20088, chance = 7300 }, -- Crude Umbral Spellbook
	{ id = 20067, chance = 7300 }, -- Crude Umbral Slayer
	{ id = 20277, chance = 4900 }, -- Psychedelic Tapestry
	{ id = 20280, chance = 4900 }, -- Nightmare Beacon
	{ id = 20279, chance = 4900 }, -- Eye Pod
	{ id = 20282, chance = 2400 }, -- Nightmare Hook
	{ id = 20274, chance = 2400 }, -- Nightmare Horn
	{ id = 20074, chance = 2400 }, -- Umbral Chopper
	{ id = 20276, chance = 2400 }, -- Dream Warden Mask
	{ id = 20066, chance = 2400 }, -- Umbral Masterblade
	{ id = 20085, chance = 2400 }, -- Crude Umbral Crossbow
	{ id = 20079, chance = 2400 }, -- Crude Umbral Hammer
	{ id = 3079, chance = 2400 }, -- Boots of Haste
	{ id = 20082, chance = 2400 }, -- Crude Umbral Bow
	{ id = 20068, chance = 2400 }, -- Umbral Slayer
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -5000 },
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_ICEDAMAGE, minDamage = -900, maxDamage = -1100, range = 7, radius = 7, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = true },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_DEATHDAMAGE, minDamage = -100, maxDamage = -1000, length = 8, spread = 3, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 2000, chance = 19, type = COMBAT_DEATHDAMAGE, minDamage = -100, maxDamage = -800, range = 7, radius = 6, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "melee", interval = 1800, chance = 40, minDamage = 0, maxDamage = -1000 },
	{ name = "combat", interval = 3000, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -4000, maxDamage = -6000, length = 8, spread = 3, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_FIREDAMAGE, minDamage = -1600, maxDamage = -3400, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2500, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -480, range = 7, radius = 5, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "gaz'haragoth iceball", interval = 2000, chance = 24, minDamage = -1000, maxDamage = -1000, target = false },
	{ name = "gaz'haragoth death", interval = 4000, chance = 6, target = false },
	{ name = "gaz'haragoth paralyze", interval = 2000, chance = 12, target = false },
	{ name = "gaz'haragoth summon", interval = 1000, chance = 100, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 55,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 2500, maxDamage = 3500, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 4000, chance = 80, speedChange = 700, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
