local mType = Game.createMonsterType("The Sandking")
local monster = {}

monster.description = "The Sandking"
monster.experience = 0
monster.outfit = {
	lookType = 1013,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"CultsOfTibiaBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1444,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 50000
monster.maxHealth = 50000
monster.race = "venom"
monster.corpse = 25866
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 30,
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
	staticAttackChance = 95,
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
	{ text = "CRRRK!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 30 }, -- platinum coin
	{ id = 3028, chance = 80000, maxCount = 10 }, -- small diamond
	{ id = 3033, chance = 80000, maxCount = 10 }, -- small amethyst
	{ id = 3030, chance = 80000, maxCount = 10 }, -- small ruby
	{ id = 3032, chance = 80000, maxCount = 10 }, -- small emerald
	{ id = 9057, chance = 80000, maxCount = 10 }, -- small topaz
	{ id = 11454, chance = 80000 }, -- luminous orb
	{ id = 3324, chance = 80000 }, -- skull staff
	{ id = 16121, chance = 80000, maxCount = 3 }, -- green crystal shard
	{ id = 16120, chance = 80000, maxCount = 3 }, -- violet crystal shard
	{ id = 16119, chance = 80000, maxCount = 3 }, -- blue crystal shard
	{ id = 7642, chance = 80000, maxCount = 10 }, -- great spirit potion
	{ id = 238, chance = 80000, maxCount = 10 }, -- great mana potion
	{ id = 7643, chance = 80000, maxCount = 10 }, -- ultimate health potion
	{ id = 7440, chance = 80000 }, -- mastermind potion
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3098, chance = 80000 }, -- ring of healing
	{ id = 20062, chance = 80000 }, -- cluster of solace
	{ id = 3067, chance = 80000 }, -- hailstorm rod
	{ id = 14087, chance = 80000 }, -- grasshopper legs
	{ id = 19400, chance = 80000 }, -- arcane staff
	{ id = 5892, chance = 80000 }, -- huge chunk of crude iron
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 3339, chance = 80000 }, -- djinn blade
	{ id = 7417, chance = 80000 }, -- runed sword
	{ id = 11674, chance = 80000 }, -- cobra crown
	{ id = 7404, chance = 80000 }, -- assassin dagger
	{ id = 22721, chance = 80000 }, -- gold token
	{ id = 22516, chance = 80000 }, -- silver token
	{ id = 16161, chance = 80000 }, -- crystalline axe
	{ id = 14086, chance = 80000 }, -- calopteryx cape
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -500, range = 4, radius = 4, effect = CONST_ME_STONES, target = true },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -650, radius = 5, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.defenses = {
	defense = 30,
	armor = 30,
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
