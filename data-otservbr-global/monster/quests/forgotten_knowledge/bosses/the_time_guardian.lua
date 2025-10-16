local mType = Game.createMonsterType("The Time Guardian")
local monster = {}

monster.description = "The Time Guardian"
monster.experience = 50000
monster.outfit = {
	lookType = 945,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"ForgottenKnowledgeBossDeath",
}

monster.health = 150000
monster.maxHealth = 150000
monster.race = "undead"
monster.corpse = 25085
monster.speed = 170
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5,
}

monster.bosstiary = {
	bossRaceId = 1290,
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
	{ text = "This place is sacred!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 30 }, -- platinum coin
	{ id = 16120, chance = 80000, maxCount = 3 }, -- violet crystal shard
	{ id = 16121, chance = 80000, maxCount = 3 }, -- green crystal shard
	{ id = 16119, chance = 80000, maxCount = 3 }, -- blue crystal shard
	{ id = 7643, chance = 80000, maxCount = 10 }, -- ultimate health potion
	{ id = 238, chance = 80000, maxCount = 5 }, -- great mana potion
	{ id = 7642, chance = 80000, maxCount = 10 }, -- great spirit potion
	{ id = 3030, chance = 80000, maxCount = 10 }, -- small ruby
	{ id = 3033, chance = 80000, maxCount = 10 }, -- small amethyst
	{ id = 3028, chance = 80000, maxCount = 10 }, -- small diamond
	{ id = 9057, chance = 80000, maxCount = 10 }, -- small topaz
	{ id = 24969, chance = 80000 }, -- ancient watch
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 7439, chance = 80000 }, -- berserk potion
	{ id = 7440, chance = 80000 }, -- mastermind potion
	{ id = 24970, chance = 80000 }, -- frozen time
	{ id = 10323, chance = 80000 }, -- guardian boots
	{ id = 12306, chance = 80000 }, -- leather whip
	{ id = 3081, chance = 80000 }, -- stone skin amulet
	{ id = 3098, chance = 80000 }, -- ring of healing
	{ id = 11454, chance = 80000 }, -- luminous orb
	{ id = 5809, chance = 80000 }, -- soul stone
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 821, chance = 80000 }, -- magma legs
	{ id = 3324, chance = 80000 }, -- skull staff
	{ id = 3439, chance = 80000 }, -- phoenix shield
	{ id = 22516, chance = 80000 }, -- silver token
	{ id = 22721, chance = 80000 }, -- gold token
	{ id = 7417, chance = 80000 }, -- runed sword
	{ id = 8076, chance = 80000 }, -- spellscroll of prophecies
	{ id = 20062, chance = 80000 }, -- cluster of solace
	{ id = 3032, chance = 80000 }, -- small emerald
	{ id = 7387, chance = 80000 }, -- diamond sceptre
	{ id = 824, chance = 80000 }, -- glacier robe
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 823, chance = 80000 }, -- glacier kilt
	{ id = 5892, chance = 80000 }, -- huge chunk of crude iron
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 190, attack = 300 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -600, maxDamage = -780, range = 7, radius = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -600, maxDamage = -780, length = 9, spread = 0, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -600, maxDamage = -780, length = 9, spread = 0, effect = CONST_ME_ENERGYAREA, target = false },
	-- energy damage
	{ name = "condition", type = CONDITION_ENERGY, interval = 2000, chance = 20, minDamage = -2000, maxDamage = -2000, radius = 7, effect = CONST_ME_BLOCKHIT, target = false },
	-- bleed
	{ name = "condition", type = CONDITION_BLEEDING, interval = 2000, chance = 20, minDamage = -2000, maxDamage = -2000, length = 9, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
}

monster.defenses = {
	defense = 70,
	armor = 70,
	--	mitigation = ???,
	{ name = "time guardian", interval = 2000, chance = 10, target = false },
	{ name = "time guardiann", interval = 2000, chance = 10, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 80 },
	{ type = COMBAT_EARTHDAMAGE, percent = 80 },
	{ type = COMBAT_FIREDAMAGE, percent = 80 },
	{ type = COMBAT_LIFEDRAIN, percent = 80 },
	{ type = COMBAT_MANADRAIN, percent = 80 },
	{ type = COMBAT_DROWNDAMAGE, percent = 80 },
	{ type = COMBAT_ICEDAMAGE, percent = 80 },
	{ type = COMBAT_HOLYDAMAGE, percent = 80 },
	{ type = COMBAT_DEATHDAMAGE, percent = 80 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
