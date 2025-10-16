local mType = Game.createMonsterType("The Scourge of Oblivion")
local monster = {}

monster.description = "The Scourge Of Oblivion"
monster.experience = 75000
monster.outfit = {
	lookType = 875,
	lookHead = 79,
	lookBody = 3,
	lookLegs = 4,
	lookFeet = 2,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"SecretLibraryBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1642,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 800000
monster.maxHealth = 800000
monster.race = "venom"
monster.corpse = 23561
monster.speed = 225
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 25,
}

monster.strategiesTarget = {
	nearest = 100,
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

monster.summon = {
	maxSummons = 8,
	summons = {
		{ name = "Charger", chance = 15, interval = 1000, count = 3 },
		{ name = "Spark of Destruction", chance = 15, interval = 1000, count = 5 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "The Scourge Of Oblivion prepares a devestating attack!", yell = false },
	{ text = "The Scourge Of Oblivion activates its reflective shields!", yell = false },
}

monster.loot = {
	{ id = 25759, chance = 80000, maxCount = 100 }, -- royal star
	{ id = 3043, chance = 80000, maxCount = 13 }, -- crystal coin
	{ id = 3035, chance = 80000, maxCount = 15 }, -- platinum coin
	{ id = 23374, chance = 80000, maxCount = 20 }, -- ultimate spirit potion
	{ id = 3033, chance = 80000, maxCount = 12 }, -- small amethyst
	{ id = 3028, chance = 80000, maxCount = 12 }, -- small diamond
	{ id = 3032, chance = 80000, maxCount = 12 }, -- small emerald
	{ id = 3030, chance = 80000, maxCount = 12 }, -- small ruby
	{ id = 22516, chance = 80000, maxCount = 22 }, -- silver token
	{ id = 7443, chance = 80000, maxCount = 10 }, -- bullseye potion
	{ id = 7440, chance = 80000, maxCount = 10 }, -- mastermind potion
	{ id = 22721, chance = 80000, maxCount = 8 }, -- gold token
	{ id = 23375, chance = 80000, maxCount = 6 }, -- supreme health potion
	{ id = 23373, chance = 80000, maxCount = 6 }, -- ultimate mana potion
	{ id = 16119, chance = 80000, maxCount = 3 }, -- blue crystal shard
	{ id = 16121, chance = 80000, maxCount = 3 }, -- green crystal shard
	{ id = 16120, chance = 80000, maxCount = 3 }, -- violet crystal shard
	{ id = 30060, chance = 80000 }, -- giant emerald
	{ id = 30061, chance = 80000 }, -- giant sapphire
	{ id = 30059, chance = 80000 }, -- giant ruby
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 23526, chance = 80000 }, -- collar of blue plasma
	{ id = 22726, chance = 80000 }, -- rift shield
	{ id = 19400, chance = 80000 }, -- arcane staff
	{ id = 5892, chance = 80000 }, -- huge chunk of crude iron
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 3006, chance = 80000 }, -- ring of the sky
	{ id = 8061, chance = 80000 }, -- skullcracker armor
	{ id = 7427, chance = 80000 }, -- chaos mace
	{ id = 23518, chance = 80000 }, -- spark sphere
	{ id = 23520, chance = 80000 }, -- plasmatic lightning
	{ id = 3010, chance = 80000 }, -- emerald bangle
	{ id = 5479, chance = 80000 }, -- cats paw
	{ id = 2995, chance = 80000 }, -- piggy bank
	{ id = 23509, chance = 80000 }, -- mysterious remains
	{ id = 23535, chance = 80000 }, -- energy bar
	{ id = 23527, chance = 80000 }, -- collar of green plasma
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 23528, chance = 80000 }, -- collar of red plasma
	{ id = 5809, chance = 80000 }, -- soul stone
	{ id = 9057, chance = 80000 }, -- small topaz
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 23476, chance = 80000 }, -- void boots
	{ id = 7439, chance = 80000 }, -- berserk potion
	{ id = 3324, chance = 80000 }, -- skull staff
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 22867, chance = 80000 }, -- rift crossbow
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 22727, chance = 80000 }, -- rift lance
	{ id = 22866, chance = 80000 }, -- rift bow
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 28791, chance = 1000 }, -- library ticket
	{ id = 8075, chance = 80000 }, -- spellbook of lost souls
	{ id = 7414, chance = 80000 }, -- abyss hammer
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 250, attack = 350 },
	{ name = "combat", interval = 1000, chance = 7, type = COMBAT_MANADRAIN, minDamage = -900, maxDamage = -1500, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_POFF, target = false },
	{ name = "drunk", interval = 2000, chance = 20, radius = 5, effect = CONST_ME_SMALLCLOUDS, target = false, duration = 9000 },
	{ name = "strength", interval = 1000, chance = 9, range = 7, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "energy strike", interval = 2000, chance = 30, minDamage = -2000, maxDamage = -2700, range = 1, target = false },
	{ name = "combat", interval = 2000, chance = 8, type = COMBAT_FIREDAMAGE, minDamage = -1550, maxDamage = -2550, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -1075, maxDamage = -2405, range = 7, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -600, maxDamage = -1500, radius = 8, effect = CONST_ME_LOSEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -750, maxDamage = -1200, length = 8, spread = 0, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "choking fear drown", interval = 2000, chance = 20, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -450, maxDamage = -1400, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -800, maxDamage = -2300, radius = 8, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "speed", interval = 1000, chance = 12, speedChange = -800, radius = 6, effect = CONST_ME_POISONAREA, target = false, duration = 60000 },
	{ name = "strength", interval = 1000, chance = 8, radius = 5, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 1000, chance = 34, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -700, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -950, length = 8, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.defenses = {
	defense = 160,
	armor = 160,
	--	mitigation = ???,
	{ name = "combat", interval = 6000, chance = 25, type = COMBAT_HEALING, minDamage = 2000, maxDamage = 5000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 8, speedChange = 1901, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
	{ name = "invisible", interval = 1000, chance = 4, effect = CONST_ME_MAGIC_BLUE },
	{ name = "invisible", interval = 1000, chance = 17, effect = CONST_ME_MAGIC_BLUE },
}

monster.reflects = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 100 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
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
